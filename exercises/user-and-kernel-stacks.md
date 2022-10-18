# User and Kernel Stacks

Have you ever wondered what user and kernel stacks of running applications look like?

On Intel x86-64 architecture, a process's virtual memory looks like (see [Linux kernel mm (x86_64)](https://www.kernel.org/doc/Documentation/x86/x86_64/mm.txt) for more details):

```
0xffffffffffffffff  +---------------+
                    |               |
     128 TiB        |    kernel     |  shared between all processes
   (2^47 bytes)     |               |
                    |               |
0xffff7fffffffffff  |---------------|
                    |               |
    ~16M TiB        | non-canonical |
                    |               |
0x00007fffffffffff  |---------------|
                    |   argv, env   |
                    |---------------|
                    |               |
                    |    stack      |
                    |               |
                    |---------------|  <- top of stack
                    |               |
                    |               |
     128 TiB        |               |
   (2^47 bytes)     |---------------|  <- program break
                    |               |
                    |     heap      |
                    |               |
                    |---------------|  <- end
                    |     bss       |
                    |---------------|  <- edata
                    |     data      |
                    |---------------|  <- etext
                    |     text      |
0x0000000000400000  |---------------|
                    |               |
0x0000000000000000  +---------------+
```


By [gstack](https://linux.die.net/man/1/gstack) and [proc](https://man7.org/linux/man-pages/man5/proc.5.html), we are able to see the user and kernel stacks of running processes.

For example,

```bash
$ sleep 300 &
[1] 14

$ gstack 14
#0  0x00007fbc9b4bf145 in nanosleep () from /lib64/libpthread.so.0
#1  0x000055a29f4dd057 in rpl_nanosleep ()
#2  0x000055a29f4d75c0 in xnanosleep ()
#3  0x000055a29f48c548 in single_binary_main_sleep ()
#4  0x000055a29f4126b1 in launch_program ()
#5  0x000055a29f411a5a in main ()

$ cat /proc/14/stack
[<0>] __do_sys_restart_syscall+0x22/0x30
[<0>] do_syscall_64+0x59/0xc0
[<0>] entry_SYSCALL_64_after_hwframe+0x61/0xcb
```
