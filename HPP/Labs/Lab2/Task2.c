#include <stdio.h>

int main(){
	int a; int b;
	printf("Give the number a:");
 	scanf("%d", &a);

	printf("Give the number b:");
	scanf("%d", &b);

	for(int i=0; i<a; i++){
		for(int j=0; j<b; j++){
			if(i==0 || i==a-1){
				printf("*");
			}
			else{
				if(j==0 || j==b-1){
					printf("*");
				}
				else{
					printf(".");
				}
			}
		}
		printf("\n");
	
	}
}
