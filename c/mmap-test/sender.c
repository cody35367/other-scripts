#include <signal.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>

#define SHMPATH "/cody.test"
#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

bool terminate = false;

void handle_sigint(int sig) { 
    terminate = true;
} 

int main(int argc, char *argv[]) {
    int            fd;
    uint32_t       *cnt;

    signal(SIGINT, handle_sigint); 

    /* Create shared memory object and set its size to the size
        of our structure. */
    fd = shm_open(SHMPATH, O_CREAT | O_EXCL | O_RDWR, 0600);
    if (fd == -1)
        errExit("shm_open");

    if (ftruncate(fd, sizeof(*cnt)) == -1)
        errExit("ftruncate");

    /* Map the object into the caller's address space. */
    cnt = mmap(NULL, sizeof(*cnt), PROT_READ | PROT_WRITE,
                MAP_SHARED, fd, 0);

    close(fd);

    *cnt = 0;

    while(!terminate) {
        (*cnt)++;
        printf("%u\n", *cnt);
        usleep(500000);
    }

    printf("Going to clean up...\n");

    /* Unlink the shared memory object. Even if the peer process
        is still using the object, this is okay. The object will
        be removed only after all open references are closed. */
    shm_unlink(SHMPATH);

    exit(EXIT_SUCCESS);
}