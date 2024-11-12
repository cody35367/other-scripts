#include <stdio.h>
#include <stdint.h>

typedef struct {
    int32_t v12_1:12;
    int32_t v12_2:12;
    int32_t v1_1:1;
    int32_t v7_1:7;
    int32_t v12_3:12;
    int32_t v12_4:12;
    int32_t v8_1:8;
} PWRIO_PDU_CH_HK_T;

int main() {
    PWRIO_PDU_CH_HK_T test = {0};
    test.v12_1=-4096;
    test.v12_2=-2048;
    test.v1_1=1;
    test.v7_1=-4;
    test.v12_3=-2049;
    test.v12_4=-2047;
    test.v8_1=-5;

    printf("%d %d %d %d %d %d %d\n", test.v12_1, test.v12_2, test.v1_1, test.v7_1, test.v12_3, test.v12_4, test.v8_1);
}