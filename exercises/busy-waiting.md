# Busy Waiting

Given a problematic program named `busy`. Can you figure out why it does not stop?

```bash
$ ./busy
^C (ctrl+c to break)
```

Execute the problematic program with debug information by [gdb](https://man7.org/linux/man-pages/man1/gdb.1.html).

```bash
$ gdb -q --args ./busy.debug
Reading symbols from ./busy.debug...done.
(gdb) r
...
^C
Program received signal SIGINT, Interrupt.
dontstop () at /workspace/code/busy.c:5
5           while (i);
```

Find out where we are.

```bash
(gdb) bt
#0  dontstop () at /workspace/code/busy.c:5
#1  0x000000000040056e in main (argc=1, argv=0x7ffc771da058) at /workspace/code/busy.c:10
```

Show us the source.

```bash
(gdb) list dontstop
1       void dontstop(void)
2       {
3           int i = 0x0badf00d;
4
5           while (i);
6       }
7
8       int main(int argc, const char ** argv)
9       {
10          dontstop();
```
