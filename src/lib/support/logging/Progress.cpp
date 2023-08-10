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
