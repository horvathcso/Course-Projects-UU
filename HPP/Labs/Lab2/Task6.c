#include <stdio.h>

int main(){
    int div1; int div2;
    printf("Enter dividend:");
    scanf(" %d",&div1);
    printf("Enter divisor:");
    scanf(" %d",&div2);
    printf("Quotient = %d\n",(div1/div2));
    printf("Remainder = %d\n",(div1%div2));
}