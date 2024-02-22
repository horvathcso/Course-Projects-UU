#include <stdio.h>
#include <stdlib.h>

void print_array(int *arr,int n){
    printf("[");
    for(int i=0; i<n-1; i++){
        printf("%d, ",arr[i]);
    }
    printf("%d]\n",arr[n-1]);

}

int main(){
    int *array= (int *) malloc(10*sizeof(int));
    int i=0;
    int sum=0;
    do
    {
        scanf(" %d", &array[i]);
        sum += array[i];
        i++;

        if(i%10==0){
            array = realloc(array, (i+10)*sizeof(int));
        }
    } while (array[i-1]!=0);

    print_array(array,i-1);
    printf("Sum: %d\n", sum);

}