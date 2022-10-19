# Tracing

You probably would like to know what applications will do during execution.

In user space, [strace](https://man7.org/linux/man-pages/man1/strace.1.html) can be used for live tracing on running processes.

Let's say you want to trace a program:

```bash
$ strace -- sleep 3
execve("/usr/bin/sleep", ["sleep", "3"], 0x7fff64f0a0d0 /* 9 vars */) = 0
brk(NULL)                               = 0x5636d1128000
arch_prctl(0x3001 /* ARCH_??? */, 0x7fff5c99d8a0) = -1 EINVAL (Invalid argument)
...
nanosleep({tv_sec=3, tv_nsec=0}, NULL)  = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++
```

You most likely want more details, such as process ID, timestamp, and execution time on each system call.

```bash
$ strace -f -T -ttt -- sleep 3
1665725477.788122 execve("/usr/bin/sleep", ["sleep", "3"], 0x7ffea1165048 /* 9 vars */) = 0 <0.001497>
1665725477.790436 brk(NULL)             = 0x55eea794f000 <0.000633>
1665725477.794375 arch_prctl(0x3001 /* ARCH_??? */, 0x7fff078f7fb0) = -1 EINVAL (Invalid argument) <0.000339>
...
1665725477.847466 nanosleep({tv_sec=3, tv_nsec=0}, NULL) = 0 <3.001283>
1665725480.848888 close(1)              = 0 <0.000007>
1665725480.848940 close(2)              = 0 <0.000004>
1665725480.849009 exit_group(0)         = ?
1665725480.849513 +++ exited with 0 +++
```

Of course you just need statistics:

```bash
$ strace -c -- sleep 3
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 21.91    0.002246          57        39        13 openat
 18.07    0.001853          47        39           mmap
 14.16    0.001452          51        28           close
 10.96    0.001124          43        26           fstat
  9.40    0.000964          40        24           read
  8.11    0.000832          41        20           mprotect
  4.20    0.000431          39        11           lseek
  3.73    0.000382          47         8         5 prctl
  2.52    0.000258         258         1           nanosleep
  1.08    0.000111          55         2         2 statfs
  0.93    0.000095          95         1           munmap
  0.90    0.000092          30         3           brk
  0.86    0.000088          44         2           rt_sigaction
  0.58    0.000059          29         2         2 access
  0.46    0.000047          47         1           prlimit64
  0.43    0.000044          22         2         1 arch_prctl
  0.43    0.000044          44         1           futex
  0.43    0.000044          44         1           set_tid_address
  0.43    0.000044          44         1           set_robust_list
  0.42    0.000043          43         1           rt_sigprocmask
  0.00    0.000000           0         1           execve
------ ----------- ----------- --------- --------- ----------------
100.00    0.010253          47       214        23 total
```

Then, you may be wondering the files in which it's interesed.

```bash
$ strace -f -T -ttt -- sleep 3 2>&1 | grep openat | (head; tail)
1665726004.876083 openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3 <0.000448>
1665726004.882655 openat(AT_FDCWD, "/lib64/librt.so.1", O_RDONLY|O_CLOEXEC) = 3 <0.003752>
1665726004.893572 openat(AT_FDCWD, "/lib64/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3 <0.000381>
...
1665726004.924475 openat(AT_FDCWD, "/usr/lib/locale/C.utf8/LC_NUMERIC", O_RDONLY|O_CLOEXEC) = 3 <0.000009>
1665726004.924572 openat(AT_FDCWD, "/usr/lib/locale/C.UTF-8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = -1 ENOENT (No such file or directory) <0.000006>
1665726004.924594 openat(AT_FDCWD, "/usr/lib/locale/C.utf8/LC_CTYPE", O_RDONLY|O_CLOEXEC) = 3 <0.000008>
```
