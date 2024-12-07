#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

long target;
long nums[15];
size_t count = 0;

int check_p1();
int check_p2();

int main() {
    time_t start = clock();

    FILE *file = fopen("../input.txt", "r");
    char line[50];
    long accum[2] = {0, 0};

    while (fgets(line, sizeof(line), file)) {
        sscanf(line, "%ld:", &target);
        char *tok = strtok(strchr(line, ':') + 1, " ");
        while (tok != NULL) {
            sscanf(tok, "%ld", &nums[count++]);
            tok = strtok(NULL, " ");
        }
        nums[count] = -1;

        if (check_p1()) {
            accum[0] += target;
            accum[1] += target;
        } else if (check_p2()) {
            accum[1] += target;
        }
        count = 0;
    }

    printf("p1: %ld\np2: %ld\ntime: %lf msec\n", accum[0], accum[1], (double)(clock() - start)*1000/CLOCKS_PER_SEC);
}

int rec_p1(const long cur, const long *next) {
    if (*next < 0) return cur == target;

    return (
        rec_p1(cur + *next, next + 1) ||
        rec_p1(cur * *next, next + 1)
    );
}

int check_p1() { return rec_p1(nums[0], &nums[1]); }

long num_concat(long a, const long b) {
    for (long i = b; i > 0; i /= 10) {
        a *= 10;
    }
    return a + b;
}

int rec_p2(const long cur, const long *next) {
    if (*next < 0) return cur == target;

    return (
        rec_p2(cur + *next, next + 1) ||
        rec_p2(cur * *next, next + 1) ||
        rec_p2(num_concat(cur, *next), next + 1)
    );
}

int check_p2() { return rec_p2(nums[0], &nums[1]); }
