#include <stdio.h>
#include <math.h>

int main(){
    double n; double sq; double comp;
    printf("Give an integer to determinate if it's a square number:\n");
    scanf("%lf", &n);

    sq = sqrt(n);
    comp=(double)(int)sq;

    if(sq==comp){
        printf("Square\n");
    }
    else
        printf("Non sqare\n");
}