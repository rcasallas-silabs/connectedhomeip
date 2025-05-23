/*
 *   Copyright (c) 2024 Project CHIP Authors
 *   All rights reserved.
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 */

#include "InteractiveCommands.h"

#include <platform/logging/LogV.h>
#include <system/SystemClock.h>

#include <editline.h>

#include <stdarg.h>
#include <stdio.h>
#include <string>
#include <thread>
#include <vector>

#if defined(PW_RPC_ENABLED)
#include <rpc/RpcClient.h>
#include <rpc/RpcServer.h>
#endif

using namespace chip;

namespace {

constexpr char kInteractiveModePrompt[]          = ">>> ";
constexpr char kInteractiveModeHistoryFileName[] = "chip_tool_history";
constexpr char kInteractiveModeStopCommand[]     = "quit()";

#if defined(PW_RPC_ENABLED)
constexpr uint16_t kRetryIntervalS = 3;
#endif

// File pointer for the log file
FILE * sLogFile = nullptr;

std::queue<std::string> sCommandQueue;
std::mutex sQueueMutex;
std::condition_variable sQueueCondition;

void ReadCommandThread()
{
    char * command;
    while (true)
    {
        command = readline(kInteractiveModePrompt);
        if (command != nullptr && *command)
        {
            std::unique_lock<std::mutex> lock(sQueueMutex);
            sCommandQueue.push(command);
            free(command);
            sQueueCondition.notify_one();
        }
    }
}

void OpenLogFile(const char * filePath)
{
    sLogFile = fopen(filePath, "a");
    if (sLogFile == nullptr)
    {
        perror("Failed to open log file");
    }
}

void CloseLogFile()
{
    if (sLogFile != nullptr)
    {
        fclose(sLogFile);
        sLogFile = nullptr;
    }
}

void ClearLine()
{
    printf("\r\x1B[0J"); // Move cursor to the beginning of the line and clear from cursor to end of the screen
}

void ENFORCE_FORMAT(3, 0) LoggingCallback(const char * module, uint8_t category, const char * msg, va_list args)
{
    if (sLogFile == nullptr)
    {
        return;
    }

    uint64_t timeMs       = System::SystemClock().GetMonotonicMilliseconds64().count();
    uint64_t seconds      = timeMs / 1000;
    uint64_t milliseconds = timeMs % 1000;

    flockfile(sLogFile);

    fprintf(sLogFile, "[%llu.%06llu] CHIP:%s: ", static_cast<unsigned long long>(seconds),
            static_cast<unsigned long long>(milliseconds), module);
    vfprintf(sLogFile, msg, args);
    fprintf(sLogFile, "\n");
    fflush(sLogFile);

    funlockfile(sLogFile);
}

#if defined(PW_RPC_ENABLED)
void AttemptRpcClientConnect(System::Layer * systemLayer, void * appState)
{
    if (admin::StartRpcClient() == CHIP_NO_ERROR)
    {
        // print to console
        fprintf(stderr, "Connected to Fabric-Bridge\n");
    }
    else
    {
        // print to console
        fprintf(stderr, "Failed to connect to Fabric-Bridge, retry in %d seconds....\n", kRetryIntervalS);
        systemLayer->StartTimer(System::Clock::Seconds16(kRetryIntervalS), AttemptRpcClientConnect, nullptr);
    }
}

void ExecuteDeferredConnect(intptr_t ignored)
{
    AttemptRpcClientConnect(&DeviceLayer::SystemLayer(), nullptr);
}
#endif

} // namespace

std::string InteractiveStartCommand::GetCommand() const
{
    std::unique_lock<std::mutex> lock(sQueueMutex);
    sQueueCondition.wait(lock, [&] { return !sCommandQueue.empty(); });

    std::string command = sCommandQueue.front();
    sCommandQueue.pop();

    if (!command.empty())
    {
        add_history(command.c_str());
        write_history(GetHistoryFilePath().c_str());
    }

    return command;
}

std::string InteractiveStartCommand::GetHistoryFilePath() const
{
    std::string storageDir;
    if (GetStorageDirectory().HasValue())
    {
        storageDir = GetStorageDirectory().Value();
    }
    else
    {
        // Match what GetFilename in ExamplePersistentStorage.cpp does.
        const char * dir = getenv("TMPDIR");
        if (dir == nullptr)
        {
            dir = "/tmp";
        }
        storageDir = dir;
    }

    return storageDir + "/" + kInteractiveModeHistoryFileName;
}

CHIP_ERROR InteractiveStartCommand::RunCommand()
{
    read_history(GetHistoryFilePath().c_str());

    if (mLogFilePath.HasValue())
    {
        OpenLogFile(mLogFilePath.Value());

        // Redirect logs to the custom logging callback
        Logging::SetLogRedirectCallback(LoggingCallback);
    }

#if defined(PW_RPC_ENABLED)
    admin::SetRpcRemoteServerPort(mFabricBridgeServerPort.Value());
    admin::InitRpcServer(mLocalServerPort.Value());
    ChipLogProgress(NotSpecified, "PW_RPC initialized.");
    DeviceLayer::PlatformMgr().ScheduleWork(ExecuteDeferredConnect, 0);
#endif

    std::thread readCommands(ReadCommandThread);
    readCommands.detach();

    int status;
    while (true)
    {
        std::string command = GetCommand();
        if (!command.empty() && !ParseCommand(command, &status))
        {
            break;
        }
    }

    SetCommandExitStatus(CHIP_NO_ERROR);
    CloseLogFile();

    return CHIP_NO_ERROR;
}

bool InteractiveCommand::ParseCommand(const std::string & command, int * status)
{
    if (command == kInteractiveModeStopCommand)
    {
        // If scheduling the cleanup fails, there is not much we can do.
        // But if something went wrong while the application is leaving it could be because things have
        // not been cleaned up properly, so it is still useful to log the failure.
        LogErrorOnFailure(DeviceLayer::PlatformMgr().ScheduleWork(ExecuteDeferredCleanups, 0));
        return false;
    }

    ClearLine();

    *status = mHandler->RunInteractive(command.c_str(), GetStorageDirectory(), NeedsOperationalAdvertising());

    return true;
}

bool InteractiveCommand::NeedsOperationalAdvertising()
{
    return mAdvertiseOperational.ValueOr(true);
}

void PushCommand(const std::string & command)
{
    std::unique_lock<std::mutex> lock(sQueueMutex);

    ChipLogProgress(NotSpecified, "PushCommand: %s", command.c_str());
    sCommandQueue.push(command);
    sQueueCondition.notify_one();
}
