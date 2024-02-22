#include <stdio.h>

int main(){
    double d; int i; char c;
    d=1.2345;
    i=7;
    c='<';

    printf("Vaariable: %lf, adress: %p, size: %ld\n", d, &d, sizeof(d));
    printf("Vaariable: %d, adress: %p, size: %ld\n", i, &i, sizeof(i));
    printf("Vaariable: %c, adress: %p, size: %ld\n", c, &c, sizeof(c));
}