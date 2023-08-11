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

#include <stdint.h>
#include <stddef.h>
size_t si_format_hex(const uint8_t *input, size_t in_size, char *output, size_t out_size);
void si_debug_hex(const char *tag, const uint8_t *data, size_t data_size);
