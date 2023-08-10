#pragma once

namespace chip
{

class Progress
{
public:
    Progress() = default;

    static void Debug(const char *format, ...);
};

} // namespace chip
