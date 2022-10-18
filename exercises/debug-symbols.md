# Debug Symbols

Debug information is important to analysis. 

The following example shows whether or not [ELF](https://man7.org/linux/man-pages/man5/elf.5.html) exeutabls are with debug information. 

Without debug information:

```bash
$ file badptr
ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2,
  for GNU/Linux 3.2.0, BuildID[sha1]=1750142df4a12d9201e199bbc982fb2c02284b5e, stripped
```

With debug information:

```bash
$ file badptr.debug 
ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2,
  for GNU/Linux 3.2.0, BuildID[sha1]=688f91327a501225959c1079cf98caf8e8422052, with debug_info, not stripped
```

Also, [readelf](https://man7.org/linux/man-pages/man1/readelf.1.html) tells more details.

```bash
$ readelf -S badptr.debug | grep debug
  [25] .debug_aranges    PROGBITS         0000000000000000  00002e04
  [26] .debug_info       PROGBITS         0000000000000000  00002e34
  [27] .debug_abbrev     PROGBITS         0000000000000000  00002ef5
  [28] .debug_line       PROGBITS         0000000000000000  00002f8b
  [29] .debug_str        PROGBITS         0000000000000000  00002fea
```

Note that we can wipe out the debug information from ELF executables by [strip](https://man7.org/linux/man-pages/man1/strip.1.html).
