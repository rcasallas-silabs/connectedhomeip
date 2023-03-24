
#include "CHIPLogging.h"
#include <lib/core/CHIPError.h>

namespace chip {
namespace Progress {

enum Steps
{
    kStart = 0,
    kInit,
    kFirst
};

struct Step
{
    Step(const char * name): mName(name) {}
    const char *mName;
};

void Start(Steps step);
void Result(CHIP_ERROR err);

} // Progress
} // chip