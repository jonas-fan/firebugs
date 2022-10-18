# Deadlocks

Given a problematic program named `deadlock`. Can you find how a deadlock happens?

```bash
$ ./deadlock
^C (ctrl+c to break)
```

Execute the problematic program with debug information by [gdb](https://man7.org/linux/man-pages/man1/gdb.1.html).

```bash
$ gdb -q --args ./deadlock.debug 
Reading symbols from ./deadlock.debug...done.

(gdb) r
...
[New Thread 0x7fdcfde64700 (LWP 80)]
[New Thread 0x7fdcfd663700 (LWP 81)]
^C
Thread 1 "deadlock.debug" received signal SIGINT, Interrupt.
0x00007fdcfe2336bd in __GI___pthread_timedjoin_ex (threadid=140587129259776, thread_return=0x0, abstime=0x0, block=<optimized out>) at pthread_join_common.c:89
89              lll_wait_tid (pd->tid);
```

Looks like there are two threads (PID `80` and `81`) waiting for a lock.

```c
(gdb) set print pretty on

(gdb) info threads
  Id   Target Id                                       Frame
* 1    Thread 0x7fdcfe66f740 (LWP 76) "deadlock.debug" 0x00007fdcfe2336bd in __GI___pthread_timedjoin_ex (
                    threadid=140587129259776, thread_return=0x0, abstime=0x0, block=<optimized out>) at pthread_join_common.c:89
  2    Thread 0x7fdcfde64700 (LWP 80) "deadlock.debug" __lll_lock_wait () at ../sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:103
  3    Thread 0x7fdcfd663700 (LWP 81) "deadlock.debug" __lll_lock_wait () at ../sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:103
```

Look into one of them. For example, the thread `80`.

```c
(gdb) thread 2
[Switching to thread 2 (Thread 0x7fdcfde64700 (LWP 80))]
#0  __lll_lock_wait () at ../sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:103
103     2:      movl    %edx, %eax

(gdb) bt
#0  __lll_lock_wait () at ../sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:103
#1  0x00007fdcfe234ac9 in __GI___pthread_mutex_lock (mutex=0x6010c0 <lock2>) at ../nptl/pthread_mutex_lock.c:80
#2  0x0000000000400780 in routine1 (data=0x0) at /workspace/code/deadlock.c:13
#3  0x00007fdcfe2321cf in start_thread (arg=<optimized out>) at pthread_create.c:479
#4  0x00007fdcfde9edd3 in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:95
```

The thread `80` is waiting for a lock that is being hold by the thread `81`.

```c
(gdb) p *((pthread_mutex_t *)0x6010c0)
$1 = {
  __data = {
    __lock = 2,
    __count = 0,
    __owner = 81,
    __nusers = 1,
    __kind = 0,
    __spins = 0,
    __elision = 0,
    __list = {
      __prev = 0x0,
      __next = 0x0
    }
  },
  __size = "\002\000\000\000\000\000\000\000Q\000\000\000\001", '\000' <repeats 26 times>,
  __align = 2
}
```

And the thread `81` is waiting for a lock that is being hold by the thread `80`.

```c
(gdb) thread 3
[Switching to thread 3 (Thread 0x7fdcfd663700 (LWP 81))]
#0  __lll_lock_wait () at ../sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:103
103     2:      movl    %edx, %eax

(gdb) bt
#0  __lll_lock_wait () at ../sysdeps/unix/sysv/linux/x86_64/lowlevellock.S:103
#1  0x00007fdcfe234ac9 in __GI___pthread_mutex_lock (mutex=0x601080 <lock1>) at ../nptl/pthread_mutex_lock.c:80
#2  0x00000000004007c8 in routine2 (data=0x0) at /workspace/code/deadlock.c:24
#3  0x00007fdcfe2321cf in start_thread (arg=<optimized out>) at pthread_create.c:479
#4  0x00007fdcfde9edd3 in clone () at ../sysdeps/unix/sysv/linux/x86_64/clone.S:95

(gdb) p *((pthread_mutex_t *)0x601080)
$2 = {
  __data = {
    __lock = 2,
    __count = 0,
    __owner = 80,
    __nusers = 1,
    __kind = 0,
    __spins = 0,
    __elision = 0,
    __list = {
      __prev = 0x0,
      __next = 0x0
    }
  },
  __size = "\002\000\000\000\000\000\000\000P\000\000\000\001", '\000' <repeats 26 times>,
  __align = 2
}
```

Both the threads `80` adn `81` are waiting the locks hold by each other, causing a deadlock.
