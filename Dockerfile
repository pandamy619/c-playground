# Dockerfile for c-playground
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        g++ \
        clang \
        make \
        gdb \
        valgrind \
        iproute2 \
        net-tools \
        tcpdump \
        iputils-ping \
        vim \
        less \
        sudo \
        python3 \
        python3-pip \
        git \
        clang-format \
    && rm -rf /var/lib/apt/lists/*

# создаём непривилегированного пользователя,
# чтобы файлы не были от root и чтобы жить безопаснее
ARG USER=developer
ARG UID=1000
RUN useradd -m -u ${UID} -s /bin/bash ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# рабочая директория, в неё VS Code и make будут монтировать проект
WORKDIR /workspace

# по умолчанию будем работать не от root'а
USER ${USER}

CMD ["/bin/bash"]
