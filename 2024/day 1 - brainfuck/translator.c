#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define INIT_OUT_CAP 1000
#define MAX(_a, _b) (((_a) > (_b)) ? (_a) : (_b))

void translate(char *code, long length, char **out, long *out_len) {
    int accum = 0;

    long out_cap = INIT_OUT_CAP;

    for (int i = 0; i < length; i++) {
        char cur = code[i];
        if (cur >= '0' && cur <= '9') {
            accum *= 10;
            accum += cur;
        }

        switch (cur) {
            case '>': 
            case '<': 
            case '+': 
            case '-': 
                if (out_cap < (*out_len) + accum) {
                    while (out_cap < (*out_len) + accum) {
                        out_cap *= 2;
                    }
                    *out = realloc(*out, out_cap);
                }
                accum = MAX(accum, 1);
                memset((*out) + (*out_len), cur, accum);
                (*out_len) += accum;
                accum = 0;
                break;

            case '.':
            case ',':
            case '[':
            case ']':
                if (out_cap < (*out_len) + accum) {
                    out_cap *= 2;
                    *out = realloc(*out, out_cap);
                }
                (*out)[(*out_len)++] = cur;
                accum = 0;
        }
    }
}

int main(int argc, char **argv) {
    if (argc < 3) return 1;

    printf("Reading file \"%s\"\n", argv[1]);

    FILE *file = fopen(argv[1], "r");
    fseek(file, 0, SEEK_END);
    long length = ftell(file);
    char *code = malloc(length);
    fseek(file, 0, SEEK_SET);
    fread(code, length, 1, file);
    fclose(file);

    char* out = malloc(INIT_OUT_CAP);
    long out_len = 0;
    translate(code, length, &out, &out_len);

    file = fopen(argv[2], "w");
    fwrite(out, out_len, 1, file);
    fclose(file);

    free(out);
}