#include "Progress.h"
#include "CHIPLogging.h"


// using Log = chip::Logging::Log;

namespace chip {
namespace Progress {

namespace {

static Step sStopStep("None");
static Step sInitStep("Init");
static Step sFirst("First");

static Step * sSteps[] = {
    &sStopStep,
    &sInitStep,
    &sFirst,
};

Step * sCurrent = &sStopStep;
Step * sPrevious = &sStopStep;
}


void Start(Steps step)
{
    sPrevious = sCurrent;
    sCurrent = sSteps[step];
    chip::Logging::Log(chip::Logging::kLogModule_Shell, chip::Logging::kLogCategory_Error, "> %s", sCurrent->mName);
}

void Result(CHIP_ERROR err)
{
    chip::Logging::Log(chip::Logging::kLogModule_Shell, chip::Logging::kLogCategory_Error, "* %s: %d",
        sCurrent->mName, err.AsInteger());
}

} // Progress
} // chip