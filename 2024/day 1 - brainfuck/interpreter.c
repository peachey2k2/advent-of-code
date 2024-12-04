#include <stdio.h>
#include <stdlib.h>

#define MEM_SIZE 30000
#define STACK_MAX 1000

size_t loop_stack[STACK_MAX];
size_t stack_ptr = -1;

unsigned char memory[MEM_SIZE] = {0};
size_t pointer = 0;

void run(char *code, long length) {
    for (int i = 0; i < length; i++) {
        switch (code[i]) {
            case '>': pointer++;                    break;
            case '<': pointer--;                    break;
            case '+': memory[pointer]++;            break;
            case '-': memory[pointer]--;            break;
            case '.': putchar(memory[pointer]);     break;
            case ',': memory[pointer] = getchar();  break;
            case ']':
                i = loop_stack[stack_ptr]; goto hell;
            case '[':
                loop_stack[++stack_ptr] = i;
            hell:
                if (memory[pointer] == 0) {
                    for (int brackets = 1; brackets > 0;) {
                        switch (code[++i]) {
                            case '[': brackets++; break;
                            case ']': brackets--; break;
                        }
                    }
                    stack_ptr--;
                }
                break;
        }
    }
    putchar('\n');
}

int main(int argc, char **argv) {
    if (argc < 2) return 1;

    printf("Reading file \"%s\"\n", argv[1]);

    FILE *file = fopen(argv[1], "r");
    fseek(file, 0, SEEK_END);
    long length = ftell(file);
    char *code = malloc(length);
    fseek(file, 0, SEEK_SET);
    fread(code, length, 1, file);
    fclose(file);

    run(code, length);

    free(code);
}