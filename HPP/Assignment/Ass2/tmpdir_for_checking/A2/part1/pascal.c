#include <stdio.h>
#include <stdlib.h>

void main(int argc, char const *argv[]) 
{
	int n =(atoi(argv[1])); //"second" carg is number of rows. n too big will cause binom(n,k) to return an int larger than maximum int size in c and hence return negative values. Use long int instead.
	if(n==0 || n<0){printf("Error: n needs to be an integer bigger to or equal to 1\n"); return;} 
	
    int pascal[n][n]; // matrix to store the number in pascal triangle 
    for(int i=0;i<n;i++){ //loop over rows
        for(int k=0;k<=i;k++){ //loop over columns
			if(k==0 || k==i){ // the end of each row is 1
                pascal[i][k]=1;
                printf("%d ", pascal[i][k]);
            }
            else{ // recursive calculation from the row above
                pascal[i][k]=pascal[i-1][k]+pascal[i-1][k-1];
                printf("%d ", pascal[i][k]);
            }
		}
		printf("\n");
	}
}