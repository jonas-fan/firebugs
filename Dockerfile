FROM rockylinux:8

ADD . /workspace

RUN yum update -y \
    && yum install -y \
        file \
        gcc \
        gdb \
        make \
        procps \
        strace \
    && yum install -y --disablerepo=* --enablerepo=*debug \
        glibc-debuginfo \
    && yum clean all

RUN cd /workspace && make

WORKDIR /workspace/output
