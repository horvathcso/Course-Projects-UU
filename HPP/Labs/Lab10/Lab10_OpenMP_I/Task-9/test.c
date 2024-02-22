#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char* argv[]){
omp_set_nested(1);

#pragma omp parallel
{
    printf("Outer\n");
    #pragma omp parallel
    {
        printf("Inner\n");
    }
}
}