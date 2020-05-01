FROM registry.fedoraproject.org/f32/fedora-toolbox

RUN \
dnf upgrade --refresh -y && \
rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo && \
dnf check-update --refresh && \
dnf install -y \
    git \
    vim \
    fish \
    curl \
    libX11-xcb \
    code