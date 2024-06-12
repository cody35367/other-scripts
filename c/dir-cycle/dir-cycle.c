#include <stdio.h>
#include <dirent.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <inttypes.h>

static uint8_t terminated = 0;

void handle_sigint(int sig) {
    if (sig == SIGINT) {
        terminated = 1;
    }
}

int main(int argc, char *argv[]) {
    struct dirent *de;
    DIR *dr;
    FILE *fptr;
    char filename[256] = {0};
    char strRdBuff[100];
    if (argc == 2) {
        signal(SIGINT, handle_sigint);
        dr = opendir(argv[1]);
        if (dr == NULL) {
            printf("[%d]: %s \"%s\"\n", errno, strerror(errno), argv[1]);
            return 2; 
        }
        while (!terminated) {
            de = readdir(dr);
            if (de == NULL) {
                rewinddir(dr);
                de = readdir(dr);
            }
            if (de->d_type == DT_REG) {
                snprintf(filename, sizeof(filename), "%s/%s", argv[1], de->d_name);
                fptr = fopen(filename, "r");
                if(fptr != NULL) {
                    while(fgets(strRdBuff, sizeof(strRdBuff), fptr)) {
                        printf("%s: %s", filename, strRdBuff);
                    }
                    fclose(fptr);
                } else {
                    printf("[%d]: %s \"%s\", skipping...\n", errno, strerror(errno), filename);
                }
                usleep(1000000);
            }
        }
        closedir(dr);
        printf("\n");
    } else {
        printf("Only one argument (directory) expected\n");
        return 1;
    }
    return 0;
}