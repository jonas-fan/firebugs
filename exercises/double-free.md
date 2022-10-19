# Double-free

Given a problematic program named `doublefree`. Can you find the address to be released multiple times?

```bash
$ ./doublefree
free(): double free detected in tcache 2
Aborted (core dumped)
```

Execute the problematic program with debug information by [gdb](https://man7.org/linux/man-pages/man1/gdb.1.html).

```bash
$ gdb -q --args ./doublefree.debug 
Reading symbols from ./doublefree.debug...done.

(gdb) r
...
free(): double free detected in tcache 2

Program received signal SIGABRT, Aborted.
__GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
50        return ret;
```

The stack shows that something goes wrong in the frame `5`.

```bash
(gdb) bt
#0  __GI_raise (sig=sig@entry=6) at ../sysdeps/unix/sysv/linux/raise.c:50
#1  0x00007f5cce79de05 in __GI_abort () at abort.c:79
#2  0x00007f5cce80d037 in __libc_message (action=action@entry=do_abort, fmt=fmt@entry=0x7f5cce905c72 "%s\n") at ../sysdeps/posix/libc_fatal.c:181
#3  0x00007f5cce81419c in malloc_printerr (str=str@entry=0x7f5cce907868 "free(): double free detected in tcache 2") at malloc.c:5375
#4  0x00007f5cce815f0d in _int_free (av=0x7f5cceb3bbc0 <main_arena>, p=0x9f52b0, have_lock=<optimized out>) at malloc.c:4214
#5  0x000000000040061e in free_all (addrs=0x7ffd0111bec0, len=4) at /workspace/code/doublefree.c:11
#6  0x000000000040067e in main (argc=1, argv=0x7ffd0111bfc8) at /workspace/code/doublefree.c:23
```

Switch to the frame `5` and look into the source.

```bash
(gdb) frame 5
#5  0x000000000040061e in free_all (addrs=0x7ffd0111bec0, len=4) at /workspace/code/doublefree.c:11
11              free(addrs[i]);

(gdb) list free_all
2       #include <stdlib.h>
3
4       #define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
5
6       void free_all(void ** addrs, size_t len)
7       {
8           size_t i;
9
10          for (i = 0; i < len; i++) {
11              free(addrs[i]);
```

The address `0x9f52c0` are duplicated in the array, causing a double-free.

```bash
(gdb) p addrs
$1 = (void **) 0x7ffd0111bec0

(gdb) p (*addrs)@4
$2 = {0x9f52a0, 0x9f52c0, 0x9f52c0, 0x9f52e0}
```
