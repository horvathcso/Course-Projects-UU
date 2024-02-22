#include <stdio.h>
#include <stdlib.h>

void print_array (double *arr, int nptrs)
{
    for (int i = 0; i < nptrs; i++)
        printf("%lf, ", arr[i]);
    putchar ('\n');
}

int CmpDouble (const void* p1, const void* p2){
    const double *p1_d= (const double*) p1;
    const double *p2_d= (const double*) p2;
    return *p2_d-*p1_d;
}

int main(){
double arrDouble[] = {9.3, -2.3, 1.2, -0.4, 2, 9.2, 1, 2.1, 0, -9.2};
int arrlen=10;
qsort (arrDouble, arrlen, sizeof(double), CmpDouble);

print_array(arrDouble, arrlen);
}