#include <stdio.h>
#include <stdlib.h>

void print_array(int *arr,int n){
    printf("[");
    for(int i=0; i<n-1; i++){
        printf("%d, ",arr[i]);
    }
    printf("%d]\n",arr[n-1]);

}

int main()
{
int *arr;
int n;
scanf("%d", &n);
arr = (int *)malloc(n*sizeof(int));
for(int i=0; i<n; ++i) arr[i] = rand() % 100; // random number from 0 to 99
print_array(arr, n);
return 0;
}