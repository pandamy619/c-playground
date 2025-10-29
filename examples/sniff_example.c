// Пример простейшего raw-сниффера TCP-пакетов.
// Цель — учебная. Это не прод-инструмент безопасности.

#include <arpa/inet.h>
#include <netinet/ip.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

int main() {
  // AF_INET + SOCK_RAW + IPPROTO_TCP -> слушаем TCP-пакеты
  int sock = socket(AF_INET, SOCK_RAW, IPPROTO_TCP);
  if (sock < 0) {
    perror("socket");
    fprintf(stderr, "Hint: нужно запускать контейнер с NET_RAW и --network "
                    "host (см. make raw)\n");
    return 1;
  }

  unsigned char buffer[65536];

  while (1) {
    ssize_t len = recv(sock, buffer, sizeof(buffer), 0);
    if (len < 0) {
      perror("recv");
      break;
    }

    struct iphdr *ip = (struct iphdr *)buffer;

    struct in_addr saddr, daddr;
    saddr.s_addr = ip->saddr;
    daddr.s_addr = ip->daddr;

    printf("TCP packet %s -> %s proto=%u len=%zd\n", inet_ntoa(saddr),
           inet_ntoa(daddr), ip->protocol, len);
    fflush(stdout);
  }

  close(sock);
  return 0;
}
