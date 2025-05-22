FROM centos:8

RUN sed -Ei 's/^(mirrorlist)/#\1/1' /etc/yum.repos.d/CentOS-Linux-AppStream.repo && \
    sed -Ei 's/^(mirrorlist)/#\1/1' /etc/yum.repos.d/CentOS-Linux-BaseOS.repo && \
    sed -Ei 's/^(mirrorlist)/#\1/1' /etc/yum.repos.d/CentOS-Linux-Extras.repo && \
    sed -Ei 's/^#(baseurl=http:\/\/)mirror/\1vault/1' /etc/yum.repos.d/CentOS-Linux-AppStream.repo && \
    sed -Ei 's/^#(baseurl=http:\/\/)mirror/\1vault/1' /etc/yum.repos.d/CentOS-Linux-BaseOS.repo && \
    sed -Ei 's/^#(baseurl=http:\/\/)mirror/\1vault/1' /etc/yum.repos.d/CentOS-Linux-Extras.repo && \
    dnf upgrade --refresh -y
