#include <stdio.h>
#define CHECK_BIT(var,pos) ((var) & (1<<(pos)))

int main(int argc, char *args[]){
    int a = 9;
    for (int i = 0; i < 8; i++)
    {
        printf("Check bit %d is %d\n",i,CHECK_BIT(a,i));
    }
    
    return 0;
}