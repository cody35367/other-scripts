#include <signal.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <time.h>

#define SHMPATH "/dev/shm/cody.test"
#define errExit(msg)    {perror(msg); exit(EXIT_FAILURE);}

bool terminate = false;

void handle_sigint(int sig) {
    terminate = true;
} 

int main(int argc, char *argv[]) {
    int            fd;
    uint32_t       *cnt;
    struct timespec begin, end;

    signal(SIGINT, handle_sigint);

    clock_gettime(CLOCK_MONOTONIC_RAW, &begin);
    fd = open(SHMPATH, O_RDONLY, 0);
    if (fd == -1)
        errExit("open");

    /* Map the object into the caller's address space. */
    cnt = mmap(NULL, sizeof(*cnt), PROT_READ,
                MAP_SHARED, fd, 0);

    close(fd);

    clock_gettime(CLOCK_MONOTONIC_RAW, &end);

    printf("cnt: 0x%016lx %u %u\n", cnt, sizeof(unsigned long int), sizeof(cnt));

    printf ("Total time = %.9f seconds\n",
            (end.tv_nsec - begin.tv_nsec) / 1000000000.0 +
            (end.tv_sec  - begin.tv_sec));

    while(!terminate) {
        printf("%u\n", *cnt);
        usleep(500000);
    }

    printf("Going to clean up...\n");

    exit(EXIT_SUCCESS);
}