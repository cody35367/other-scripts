#include <signal.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>

#define SHMPATH "/dev/shm/cody.test"
#define errExit(msg)    {perror(msg); exit(EXIT_FAILURE);}

bool terminate = false;

void handle_sigint(int sig) { 
    terminate = true;
} 

int main(int argc, char *argv[]) {
    int            fd;
    uint32_t       *cnt;

    signal(SIGINT, handle_sigint); 

    fd = open(SHMPATH, O_RDONLY, 0);
    if (fd == -1)
        errExit("open");

    /* Map the object into the caller's address space. */
    cnt = mmap(NULL, sizeof(*cnt), PROT_READ,
                MAP_SHARED, fd, 0);

    close(fd);

    while(!terminate) {
        printf("%u\n", *cnt);
        usleep(500000);
    }

    printf("Going to clean up...\n");

    exit(EXIT_SUCCESS);
}