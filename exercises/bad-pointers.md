# Bad Pointers

Given a problematic program named `badptr`. Can you find the address where the bad pointer points to?

```bash
$ ./badptr
Segmentation fault (core dumped)
```

Execute the problematic program with debug information by [gdb](https://man7.org/linux/man-pages/man1/gdb.1.html).

```bash
$ gdb -q --args ./badptr.debug 
Reading symbols from ./badptr.debug...done.

(gdb) r
...

Program received signal SIGSEGV, Segmentation fault.
0x000000000040056d in main (argc=1, argv=0x7ffd1d893728) at /workspace/code/badptr.c:10
10          *ptr = 9527;
```

The variable `ptr` is an integer pointer that points to an address `0xdeadbeef`.

```bash
(gdb) ptype ptr
type = int *

(gdb) p ptr
$1 = (int *) 0xdeadbeef
```

See also [hexspeak](https://en.wikipedia.org/wiki/Hexspeak).
