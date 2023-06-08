#include "Progress.h"
#include "CHIPLogging.h"
#include <stddef.h>
#include <string.h>
#include <stdio.h>
#include <stdint.h>
#include <sys/ioctl.h>

// using Log = chip::Logging::Log;

namespace chip {
namespace Progress {

namespace {
const char *LINE = "................................................................................................................................................................................................................................................................";
size_t sHeaderLen = 0;
size_t sTerminalWidth = 128;



}



void Init()
{
    struct winsize w;
    ioctl(0, TIOCGWINSZ, &w);
    printf ("* lines %d\n", w.ws_row);
    printf ("* columns %d\n", w.ws_col);
    sTerminalWidth = w.ws_col;
}


void Start(const char *step)
{
    printf("%s...", step);
    sHeaderLen = strlen(step) + 3;
}

void Result(CHIP_ERROR err)
{
    if(CHIP_NO_ERROR == err)
    {
        Finish("OK");
    }
    else
    {
        char buffer[1024];
        FormatCHIPError(buffer, static_cast<uint16_t>(sTerminalWidth), err);
        Finish(buffer);
    }
}

void Finish(const char *tail)
{
    size_t offset = sHeaderLen;
    size_t tail_len = strlen(tail);
    size_t line_len = strlen(LINE);

    if(offset + tail_len > sTerminalWidth) {
        printf("\n%s\n", tail);
    }
    else {
        if(sTerminalWidth + offset < line_len) {
            offset += line_len - sTerminalWidth;
        }
        printf("%s%s\n", &LINE[offset + tail_len], tail);
    }
    // printf("TEST(%zu; %zu): %s\n", line_len, left_len + tail_len, &LINE[line_len - 10]);
}

} // Progress
} // chip