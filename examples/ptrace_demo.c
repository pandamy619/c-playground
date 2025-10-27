// Минимальный пример ptrace: родитель "трассирует" дочерний процесс.
// Это иллюстрация работы отладчика.

#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/reg.h>   // ORIG_RAX / ORIG_EAX для x86 регистров
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

int main() {
    pid_t child = fork();
    if (child == -1) {
        perror("fork");
        return 1;
    }

    if (child == 0) {
        // Дочерний процесс
        // Разрешаем родителю трассировать нас
        if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) == -1) {
            perror("ptrace TRACEME");
            return 1;
        }
        // Останавливаемся, чтобы родитель успел подключиться
        raise(SIGSTOP);

        // Делаем какую-то фигню — например, просто вызываем execve /bin/ls
        execl("/bin/echo", "echo", "hello-from-child", NULL);
        perror("execl");
        return 1;
    } else {
        // Родительский процесс
        int status;
        waitpid(child, &status, 0); // ждём SIGSTOP

        if (WIFSTOPPED(status)) {
            printf("[parent] child %d stopped, attaching ptrace loop\n", child);
        }

        // Разрешаем дочке продолжать выполняться пошагово по системным вызовам
        while (1) {
            if (ptrace(PTRACE_SYSCALL, child, NULL, NULL) == -1) {
                if (errno == ESRCH) {
                    // процесс больше не существует
                    break;
                }
                perror("ptrace PTRACE_SYSCALL");
                break;
            }

            // ждём следующего системного вызова
            if (waitpid(child, &status, 0) == -1) {
                perror("waitpid");
                break;
            }

            if (WIFEXITED(status)) {
                printf("[parent] child exited with %d\n", WEXITSTATUS(status));
                break;
            }

#if defined(__x86_64__)
            // На x86_64 Linux номер системного вызова лежит в ORIG_RAX
            long syscall_num = ptrace(PTRACE_PEEKUSER, child,
                                      sizeof(long)*ORIG_RAX, NULL);
            printf("[parent] syscall: %ld\n", syscall_num);
#endif
        }
    }

    return 0;
}

