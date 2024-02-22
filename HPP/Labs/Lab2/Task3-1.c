#include <stdio.h>

int main(){
	int a; int b;
	printf("Give the first number:");
 	scanf("%d", &a);

	printf("Give the second number:");
	scanf("%d", &b);

	if(a%2==0 && b%2==0){	
		printf("The sum of the two number, since both is even: %d \n", (a+b));
	}
	else{
		printf("The product of the two number: %d \n", (a*b));
	}
	}
