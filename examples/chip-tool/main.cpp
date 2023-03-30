/*
 *   Copyright (c) 2020 Project CHIP Authors
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

#include "commands/common/Commands.h"
#include "commands/example/ExampleCredentialIssuerCommands.h"

#include "commands/delay/Commands.h"
#include "commands/discover/Commands.h"
#include "commands/group/Commands.h"
#include "commands/interactive/Commands.h"
#include "commands/pairing/Commands.h"
#include "commands/payload/Commands.h"
#include "commands/storage/Commands.h"

#include <zap-generated/cluster/Commands.h>
#include <zap-generated/test/Commands.h>

#include <sys/ioctl.h>
#include <stdio.h>
#include <string.h>

void printRight(const char *text)
{
    static const char *LINE = "................................................................................................................................";
    struct winsize w;
    size_t text_len = strlen(text);
    size_t line_len = strlen(LINE);

    ioctl(0, TIOCGWINSZ, &w);

    printf ("* lines %d\n", w.ws_row);
    printf ("* columns %d\n", w.ws_col);
    if(text_len > line_len) {
        printf("%s\n", text);
    }
    else {
        printf("%s%s\n", LINE + text_len, text);
    }
    printf("TEST(%zu; %zu): %s\n", line_len, text_len, &LINE[line_len - 10]);
}

// ================================================================================
// Main Code
// ================================================================================
int main(int argc, char * argv[])
{
    printRight("MAIN");
    // ExampleCredentialIssuerCommands credIssuerCommands;
    // Commands commands;
    // registerCommandsDelay(commands, &credIssuerCommands);
    // registerCommandsDiscover(commands, &credIssuerCommands);
    // registerCommandsInteractive(commands, &credIssuerCommands);
    // registerCommandsPayload(commands);
    // registerCommandsPairing(commands, &credIssuerCommands);
    // registerCommandsTests(commands, &credIssuerCommands);
    // registerCommandsGroup(commands, &credIssuerCommands);
    // registerClusters(commands, &credIssuerCommands);
    // registerCommandsStorage(commands);

    // return commands.Run(argc, argv);

    return 0;
}
