FROM rockylinux:8

ADD . /workspace

RUN yum install -y                              \
        file                                    \
        gcc                                     \
        gdb                                     \
        make                                    \
        procps                                  \
        strace                                  \
        yum-utils                               \
    && debuginfo-install --enablerepo=*debug -y \
        glibc                                   \
        libstdc++                               \
    && yum clean all

RUN cd /workspace && make

WORKDIR /workspace/output
