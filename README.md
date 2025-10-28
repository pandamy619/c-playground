# 🧪 c-playground

Песочница для языка C и системного программирования.  
Задачи:
- Учиться C (алгоритмы, структуры данных, память, указатели).
- Пробовать низкоуровневые штуки (raw sockets, sniffing, ptrace) в контролируемой среде.

## 📦 Что внутри образа
- GCC, Clang, Make
- GDB, Valgrind
- Сетевые утилиты (`tcpdump`, `iproute2`, `net-tools`)
- Вариант запуска с повышенными cap'ами для сетевых экспериментов

Образ основан на `debian:stable-slim`, создаётся локальным `Dockerfile`.

---

## 🚀 Быстрый старт

### 1. Собрать Docker-образ
```bash
make build
```

### 2. Запустить обычную безопасную среду (алгоритмы, структуры данных и т.д.)
```bash
make safe
```

Получишь bash внутри контейнера:
```bash
gcc examples/hello.c -o hello
./hello
```

### 3. Запустить расширенный режим (raw sockets, сетевой сниффинг, ptrace)
```bash
make raw
```

В расширенном режиме можно, например:
```bash
gcc examples/sniff_example.c -o sniff
sudo ./sniff
```

## 📂 Примеры кода

```
examples/hello.c
```
Самый базовый пример компиляции и запуска.

```
examples/sniff_example.c
```
Пример чтения пакетов через raw socket (режим make raw обязателен).

```
examples/ptrace_demo.c
```
Минимальный пример использования ptrace для отслеживания дочернего процесса.


## 💻 VS Code Devcontainer

В репозитории есть `.devcontainer/`. Это значит, что можно зайти в проект через VS Code и автоматически оказаться внутри готовой Linux-среды.

Что это даёт:
- GCC / Clang / GDB / Valgrind уже установлены
- расширения VS Code для C/отладки уже стоят
- контейнер стартует сразу с нужными капабилити:
  - NET_RAW, NET_ADMIN (raw sockets, sniffing)
  - SYS_PTRACE (ptrace / отладка системных вызовов)
  - seccomp=unconfined
  - `--network host`

То есть можно писать и отлаживать `examples/sniff_example.c` прямо из VS Code, без `make raw`.

Как пользоваться:
1. Открой папку `c-playground` в VS Code.
2. VS Code предложит “Reopen in Container” → согласиться.
3. После подготовки среды терминал внутри VS Code уже живёт в контейнере.
4. Компилируй и запускай как обычно:
   ```bash
   gcc examples/hello.c -o hello && ./hello
   gcc examples/sniff_example.c -o sniff && sudo ./sniff
