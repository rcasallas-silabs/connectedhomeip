#include "Progress.h"
#include "CHIPLogging.h"
#include <stdio.h>

namespace chip
{

void Progress::Debug(const char *format, ...)
{
   char buffer[1024];
   va_list args;
   va_start(args, format);
   vsnprintf(buffer,sizeof(buffer), format, args);
   printf("%s\n", buffer);
   va_end(args);
}

} // namespace chip


size_t si_format_hex(const uint8_t *input, size_t in_size, char *output, size_t out_size)
{
    size_t in_offset = 0;
    size_t out_left = 0;
    size_t out_off = 0;
    int n;

    while(out_off < out_size && in_offset < in_size)
    {
        out_left = out_size - out_off;
        //printf("\nLEFT! %zu\n", out_left);
        if(in_offset % 16 == 0)
        {
            if(in_offset == 0)
            {
                n = snprintf(&output[out_off], out_left, "%02x", (unsigned)input[in_offset]);
            }
            else
            {
                n = snprintf(&output[out_off], out_left, "  %02x", (unsigned)input[in_offset]);
            }
        }
        else if(in_offset % 4 == 0)
        {
            n = snprintf(&output[out_off], out_left, "  %02x", (unsigned)input[in_offset]);
        }
        else
        {
            n = snprintf(&output[out_off], out_left, " %02x", (unsigned)input[in_offset]);
        }
        if(out_off + (size_t)n >= out_size)
        {
            // printf("(%zu: %zu, %zu, %d)\n", in_offset, out_size, out_off, n);
            break;
        }

        // printf("[%zu: %zu, %zu, %d]\n", in_offset, out_size, out_off, n);
        out_off += (size_t) n;
        in_offset++;
    }

    // printf("<%zu: %zu, %zu, %d>\n", in_offset, out_size, out_off, n);
    output[out_off] = 0;
    return in_offset;
}


void si_debug_hex(const char *tag, const uint8_t *data, size_t data_size)
{
    char buffer[1024];
    si_format_hex(data, data_size, buffer, sizeof(buffer));
    printf("%s(%u): %s\n", tag, (unsigned) data_size, buffer);
}
