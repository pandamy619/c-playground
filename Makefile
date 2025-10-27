IMAGE_NAME = c-playground-image

.PHONY: build safe raw clean

# Собрать образ (один раз, потом можно юзать safe/raw)
build:
	docker build -t $(IMAGE_NAME) .

# Запуск безопасного режима (алгоритмы, структуры данных, gdb, valgrind)
safe:
	docker run -it --rm \
		-v $$(pwd):/workspace \
		-w /workspace \
		$(IMAGE_NAME) \
		/bin/bash

# Запуск расширенного режима (raw sockets, sniffing, ptrace)
raw:
	docker run -it --rm \
		--cap-add=NET_RAW --cap-add=NET_ADMIN --cap-add=SYS_PTRACE \
		--security-opt seccomp=unconfined \
		--network host \
		-v $$(pwd):/workspace \
		-w /workspace \
		$(IMAGE_NAME) \
		/bin/bash

# На случай, если вдруг запустил через docker-compose и хочешь подчиститься
clean:
	docker rm -f c-playground-safe 2>/dev/null || true
	docker rm -f c-playground-raw 2>/dev/null || true

