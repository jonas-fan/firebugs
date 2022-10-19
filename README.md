# firebugs

A workshop about Linux debugging for beginners.

## Objects

This course targets on Linux users, especially beginners. The goal of this course is to share general concepts of debugging Linux applications.

As you may know, there are so many excellent utilities which are designed for debugging purpose on Linux, such as [strace](https://man7.org/linux/man-pages/man1/strace.1.html), [gdb](https://man7.org/linux/man-pages/man1/gdb.1.html), etc. In the following course exercises, we will be going to learn how to trace and diagnose common problems on Linux, but we won't cover all of techniques since we are not experts.

## Preparation

To have better experiences, you will need to check out this repostiroy and then build the buggy programs designed for exercises.

```bash
$ git clone https://github.com/jonas-fan/firebugs.git
$ cd firebugs
$ make
```

Or you prefer using Docker:

```bash
$ docker build -t firebugs .
```

## Exercises

Common sense:

- [User and Kernel Stacks](/exercises/user-and-kernel-stacks.md)
- [Tracing](/exercises/tracing.md)
- [Debug Symbols](/exercises/debug-symbols.md)

Problems:

- [Bad Pointers](/exercises/bad-pointers.md)
- [Busy Waiting](/exercises/busy-waiting.md)
- [Stack Overflows](/exercises/stack-overflows.md)
- [Double-free](/exercises/double-free.md)
- [Deadlocks](/exercises/deadlocks.md)

