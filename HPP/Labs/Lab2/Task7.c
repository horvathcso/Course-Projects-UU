#include <stdio.h>

int main(){
    int n, i, pol, pow;
    printf("Give a number to check if it is polindrome: ");
    scanf(" %d",&n);

    i=1;
    pow=10;
    while (n/pow>0)
    {
       i++;
       pow=pow*10;
    }

    char str[i];
    sprintf(str, "%d", n);
    
    pol=0;
    for(int j=0; j<i/2; j++){
        if(str[j]!=str[i-j-1])
            pol=1;
    }

    if(pol==1)
        printf("It is not palindrome\n");
    else
        printf("It is a palindrome\n");
    

}