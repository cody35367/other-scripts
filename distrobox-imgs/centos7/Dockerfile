FROM centos:7

COPY ./CentOS-Vault.repo /etc/yum.repos.d/

RUN yum-config-manager --disable "CentOS-7 - Base" && \
    yum-config-manager --disable "CentOS-7 - Extras" && \
    yum-config-manager --disable "CentOS-7 - Updates" && \
    yum upgrade -y
