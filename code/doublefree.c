#include <stdio.h>
#include <stdlib.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))

void free_all(void ** addrs, size_t len)
{
    size_t i;

    for (i = 0; i < len; i++) {
        free(addrs[i]);
    }
}

int main(int argc, const char ** argv)
{
    void * addrs[] = {
        [0]       = malloc(8),
        [1 ... 2] = malloc(8),
        [3]       = malloc(8),
    };

    free_all(addrs, ARRAY_SIZE(addrs));

    return 0;
}
