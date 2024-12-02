
#include <system/SystemClock.h>
#include <lib/support/logging/CHIPLogging.h>

#define CHRONO_SECONDS      1000

// using namespace chip:System::Clock;

namespace silabs {

struct Chronometer
{
    Chronometer(const char *tag = nullptr)
    {
        if(tag)
        {
            ChipLogProgress(DeviceLayer, "~~~ %s", tag);
        }
        start();
    }

    void start(const char *tag = nullptr)
    {
        if(tag)
        {
            _end = chip::System::SystemClock().GetMonotonicTimestamp();
            _log(tag);
        }
        _start = chip::System::SystemClock().GetMonotonicTimestamp();
        _end = _start;
    }

    void mark(const char *tag = nullptr)
    {
        _end = chip::System::SystemClock().GetMonotonicTimestamp();
        _log(tag);
    }

    void _log(const char *tag = nullptr)
    {
        uint32_t millis = (_start < _end) ? ((uint32_t)_end.count() - (uint32_t)_start.count()) : 0;
        uint32_t seconds = 0;
        if(millis > CHRONO_SECONDS)
        {
            seconds = millis / CHRONO_SECONDS;
            millis = millis % CHRONO_SECONDS;
        }
        // chip::LoggingChipLogProgress(DeviceLayer, "%s: %04" PRIu32 "s, %04" PRIu32 "ms", seconds, millis);
        ChipLogProgress(DeviceLayer, "~~~ %s: %us %ums", tag ? tag : "Time", (unsigned)seconds, (unsigned)millis);
    }

    chip::System::Clock::Timestamp _start;
    chip::System::Clock::Timestamp _end;
};

} // namespace silabs
