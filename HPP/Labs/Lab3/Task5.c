#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void print_array (char **strings, size_t nptrs)
{
    for (size_t i = 0; i < nptrs; i++)
        printf("%s, ", strings[i]);
    putchar ('\n');
}

int CmpString (const void* p1, const void* p2){
    const char* p1_c = *(const char**)p1;
    const char* p2_c = *(const char**)p2;
    return strcmp(p1_c,p2_c);
}

int main(){
char *arrStr[] = {"daa", "cbab", "bbbb", "bababa", "ccccc", "aaaa"};
int arrStrLen = sizeof(arrStr) / sizeof(char *);
qsort(arrStr, arrStrLen, sizeof(char *), CmpString);

print_array(arrStr, sizeof arrStr /sizeof *arrStr);
}