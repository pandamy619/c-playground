IMAGE_NAME = c-playground-image

.PHONY: build safe raw shell-safe shell-raw fmt fmt-local clean

# -----------------------------
# BUILD IMAGE
# -----------------------------
# Собираем образ один раз.
build:
	docker build -t $(IMAGE_NAME) .

# -----------------------------
# HOST ENTRYPOINTS
# -----------------------------
# safe: обычный контейнер без привилегий (алгоритмы, структуры данных, valgrind, gdb и т.д.)
safe:
	docker run -it --rm \
		-v $$(pwd):/workspace \
		-w /workspace \
		$(IMAGE_NAME) \
		/bin/bash

# raw: контейнер с расширенными правами (raw sockets, sniffing, ptrace, network host)
raw:
	docker run -it --rm \
		--cap-add=NET_RAW --cap-add=NET_ADMIN --cap-add=SYS_PTRACE \
		--security-opt seccomp=unconfined \
		--network host \
		-v $$(pwd):/workspace \
		-w /workspace \
		$(IMAGE_NAME) \
		/bin/bash

# -----------------------------
# IN-CONTAINER TARGETS
# -----------------------------
# Эти цели дергаем ТОЛЬКО когда мы уже внутри контейнера (developer@...:/workspace$)
# Они не используют docker, поэтому будут работать.

# shell-safe: просто alias, удобен если ты всё-таки случайно вызвал из контейнера make safe
shell-safe:
	@echo "You're already inside a container (safe mode)."

# shell-raw: аналогично, но напоминаем как выйти и зайти в raw
shell-raw:
	@echo "Raw mode requires extra capabilities."
	@echo "Exit this container, then run on HOST:  make raw"

# -----------------------------
# CODE FORMAT
# -----------------------------
# fmt-local: запускать ТОЛЬКО внутри контейнера или на хосте, где clang-format установлен.
fmt-local:
	clang-format -i examples/*.c

# fmt: универсальный таргет.
# Если clang-format доступен на хосте -> используем его.
# Если его нет -> запускаем временный контейнер $(IMAGE_NAME) и форматим через него.
fmt:
	@if command -v clang-format >/dev/null 2>&1; then \
		echo "[*] Using local clang-format"; \
		clang-format -i examples/*.c; \
	else \
		echo "[*] Using containerized clang-format"; \
		docker run --rm \
			-v $$(pwd):/workspace \
			-w /workspace \
			$(IMAGE_NAME) \
			clang-format -i examples/*.c; \
	fi

# -----------------------------
# CLEANUP
# -----------------------------
clean:
	docker rm -f c-playground-safe 2>/dev/null || true
	docker rm -f c-playground-raw 2>/dev/null || true
