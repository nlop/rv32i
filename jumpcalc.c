#include <stdio.h>
#include <stdint.h>
#include <string.h>

void jstring(const int32_t jump, char *string);
void bstring(const int32_t jump, char *string);

int main(const int argc, const char *argv[]) {
    uint32_t pc;
    uint32_t target;
    int32_t jump;
    char jstring_out[6];
    char bstring_out[8];
    sscanf(argv[1], "%x", &pc);
    sscanf(argv[2], "%x", &target);
    jump = target - pc;
    printf("PC: %08x -> %08x, JUMP: %08x\n", pc, target, jump);
    jstring(jump, jstring_out);
    bstring(jump, bstring_out);
    printf("J := X'%s'\n", jstring_out);
    printf("B := X'%c', O'%c', B'%s'\n", bstring_out[0], bstring_out[1], bstring_out + 2);
}

void bstring(const int32_t jump, char *string) {
    uint8_t bbyte;
    char hexstr[3];
    bbyte =  (jump >> 9) & 0x08; /* B{12} (hex) */
    bbyte |=  (jump >> 8) & 0x07; /* B{10 - 8} */
    sprintf(hexstr, "%01x", bbyte);
    memcpy(string, hexstr, 1 * sizeof(char));
    bbyte =  (jump >> 5) & 0x07; /* B{7 - 5} (oct) */
    sprintf(hexstr, "%01o", bbyte);
    memcpy(string + 1, hexstr, 1 * sizeof(char));
    for(int8_t i = 4; i > 0; i--) { /* B{4 - 1} (bin)*/
        uint8_t tmp = (jump >> i) & 0x01;
        if (tmp != 0)
            string[2 + (4 - i)] = '1';
        else
            string[2 + (4 - i)] = '0';
    }
    bbyte = (jump >> 11) & 0x01; /*B{11} (bin) */
    if (bbyte != 0)
        string[6] = '1';
    else
        string[6] = '0';
    string[7] = '\0';
}

void jstring(const int32_t jump, char *string) {
    uint8_t jbyte;
    char hexstr[3];
    jbyte = (jump >> 12) & 0x80; /* J{20}*/
    jbyte |= (jump >> 4) & 0x7f; /* J{10 - 4}*/
    sprintf(hexstr, "%02x", jbyte);
    memcpy(string, hexstr, 2 * sizeof(char));
    jbyte = (jump << 4) & 0xe0; /* J{3 - 1} */
    jbyte |= (jump >> 7) & 0x10; /* J{11} */
    jbyte |= (jump >> 16) & 0x0f; /* J{19 - 16} */
    sprintf(hexstr, "%02x", jbyte);
    memcpy(string + 2, hexstr, 2 * sizeof(char));
    jbyte =  (jump >> 12) & 0x0f; /* J{15 - 12} */
    sprintf(hexstr, "%01x", jbyte);
    memcpy(string + 4, hexstr, 1 * sizeof(char));
    string[5] = '\0';
}
