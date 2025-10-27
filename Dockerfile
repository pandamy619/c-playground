# Dockerfile for c-playground
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

# Устанавливаем тулчейн для разработки на C и полезные утилиты
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
    && rm -rf /var/lib/apt/lists/*

# Создаем непривилегированного пользователя (чтобы по умолчанию не жить под root)
ARG USER=developer
ARG UID=1000
RUN useradd -m -u ${UID} -s /bin/bash ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Рабочая директория
WORKDIR /workspace

# По умолчанию будем заходить как обычный пользователь
USER ${USER}

CMD ["/bin/bash"]

