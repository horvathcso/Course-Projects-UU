#include <stdio.h>
#include <stdlib.h>

int binom(int n,int k){ //function for binomial coefficient. Can also do this recursively.
	double product=1;
	for(int i=1;i<=k;i++){
		product*=(double)(n+1-i)/i; //given on assignment and well known. Need "(double)" to avoid int(fraction)=0.
	}
	return (int)product; //return of type int so print looks good
}


void main(int argc, char const *argv[])
{
	int n =(atoi(argv[1])); //"second" carg is number of rows
	if(n==0 || n<0){printf("Error: n needs to be an integer bigger to or equal to 1\n"); return;}
	int k_count = 0; //column number
	for(int i=0;i<n;i++){
		for(int k=0;k<=k_count;k++){
			printf("%d ", binom(i,k));
		}
		k_count++; //up column number
		printf("\n");
	}
}
