#include <stdint.h>

int64_t countdown(int64_t i)
{
    if (i < 1) {
        return 0;
    }

    return countdown(i - 1);
}

int main(int argc, const char ** argv)
{
    countdown(INT64_MAX);
    
    return 0;
}
