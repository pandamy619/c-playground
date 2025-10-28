# 🧪 c-playground

Песочница для C.

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


