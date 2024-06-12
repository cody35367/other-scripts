#include <stdio.h>
#include <dirent.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <inttypes.h>
#include <stdlib.h>

static uint8_t terminated = 0;

void handle_sigint(int sig) {
    if (sig == SIGINT) {
        terminated = 1;
    }
}

uint8_t scroll_for_good_file(struct dirent **deList, int itemsInDir, char *dirname) {
    FILE *fptr;
    char filename[256] = {0};
    char chrRdBuff;
    size_t bytesRead = 0;
    uint8_t foundGoodFile = 0;
    uint32_t badCount = 0;
    static uint32_t curIdx = 0;
    while((!foundGoodFile) && badCount < 2 && itemsInDir > 0) {
        snprintf(filename, sizeof(filename), "%s/%s", dirname, deList[curIdx]->d_name);
        fptr = fopen(filename, "r");
        if(fptr != NULL) {
            bytesRead = fread(&chrRdBuff, 1, sizeof(chrRdBuff), fptr);
            if (bytesRead == sizeof(chrRdBuff)) {
                printf("%s: %c\n", filename, chrRdBuff);
                foundGoodFile = 1;
            } else {
                printf("%d bytes in %s, ignoring\n", bytesRead, filename);
                badCount++;
            }
            fclose(fptr);
        } else {
            printf("[%d]: %s \"%s\", skipping...\n", errno, strerror(errno), filename);
            badCount++;
        }
        curIdx = (curIdx + 1) % itemsInDir;
    }
    return foundGoodFile;
}

int filterRegFiles(const struct dirent *de) {
    if (de->d_type == DT_REG) {
        return 1;
    }
    return 0;
}

int main(int argc, char *argv[]) {
    struct dirent **deList;
    int itemsInDir = 0;
    if (argc == 2) {
        signal(SIGINT, handle_sigint);
        itemsInDir = scandir(argv[1], &deList, filterRegFiles, alphasort);
        if (itemsInDir == -1) {
            printf("[%d]: %s \"%s\"\n", errno, strerror(errno), argv[1]);
            return 2; 
        }
        while (!terminated) {
            if (scroll_for_good_file(deList, itemsInDir, argv[1])) {
                usleep(1000000);
            } else {
                printf("Too many bads\n");
                break;
            }
        }
        free(deList);
        printf("\n");
    } else {
        printf("Only one argument (directory) expected\n");
        return 1;
    }
    return 0;
}