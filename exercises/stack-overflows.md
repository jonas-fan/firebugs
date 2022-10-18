# Stack Overflows

Given a problematic program named `recursive`. Can you see the growth of the stack?

```bash
$ ./recursive
Segmentation fault (core dumped)
```

Execute the problematic program with debug information by [gdb](https://man7.org/linux/man-pages/man1/gdb.1.html).

```c
$ gdb -q --args ./recursive.debug 
Reading symbols from ./recursive.debug...done.

(gdb) r
...

Program received signal SIGSEGV, Segmentation fault.
0x000000000040056b in countdown (i=9223372036854513936) at /workspace/code/recursive.c:9
9           return countdown(i - 1);
```

The function `countdown` has been called recursively more than `80000` times.

```c
(gdb) set pagination off

(gdb) bt
#0  0x000000000040056b in countdown (i=9223372036854513936) at /workspace/code/recursive.c:9
#1  0x0000000000400570 in countdown (i=9223372036854513937) at /workspace/code/recursive.c:9
#2  0x0000000000400570 in countdown (i=9223372036854513938) at /workspace/code/recursive.c:9
...
#84859 0x0000000000400570 in countdown (i=9223372036854598795) at /workspace/code/recursive.c:9
#84860 0x0000000000400570 in countdown (i=9223372036854598796) at /workspace/code/recursive.c:9
#84861 0x0000000000400570 in countdown (i=9223372036854598797) at /workspace/code/recursive.c:9

(gdb) list countdown
1       #include <stdint.h>
2
3       int64_t countdown(int64_t i)
4       {
5           if (i < 1) {
6               return 0;
7           }
8
9           return countdown(i - 1);
10      }
```
