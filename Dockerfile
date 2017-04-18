FROM centos
MAINTAINER k-tahiro

RUN yum install -y deltarpm && \
    yum update -y

RUN yum install -y gcc make zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel sudo vim git less wget

RUN git clone https://github.com/riywo/anyenv /opt/anyenv && \
    echo "export ANYENV_ROOT=/opt/anyenv" >>/etc/profile.d/anyenv.sh && \
    echo 'export PATH="${ANYENV_ROOT}/bin:$PATH"' >>/etc/profile.d/anyenv.sh && \
    echo 'eval "$(anyenv init -)"' >>/etc/profile.d/anyenv.sh && \
    export ANYENV_ROOT="/opt/anyenv" && \
    export PATH="${ANYENV_ROOT}/bin:$PATH" && \
    eval "$(anyenv init -)" && \
    anyenv install pyenv && \
    anyenv install ndenv && \
    eval "$(anyenv init -)" && \
    pyenv install 3.6.1 && \
    pyenv global 3.6.1 && \
    ndenv install 6.10.2 && \
    ndenv global 6.10.2

RUN useradd developer && \
    echo "developer:developer" | chpasswd && \
    echo 'developer ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers

USER developer
WORKDIR /home/developer

RUN TMP_DIR="$(mktemp -d)" && \
    git clone https://github.com/metalefty/X11RDP-RH-Matic.git "${TMP_DIR}" && \
    cd "${TMP_DIR}" && \
    ./X11RDP-RH-Matic.sh --with-xorg-driver --nox11rdp

CMD /bin/bash
