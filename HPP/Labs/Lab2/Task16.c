#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct product
{
char name[50];
double price;
}product_t;


int main(int argc, char const *argv[]){
char filename[30];
int n;

strcpy(filename,argv[1]);
 FILE* ptr = fopen(filename, "r");
    if (ptr == NULL) {
        printf("no such file.");
        return 0;
    }


fscanf(ptr, "%d", &n);
struct product *arr_of_prod=(struct product *) malloc(n*sizeof(product_t));

for (int i = 0; i < n; i++)
{
    fscanf(ptr, "%s %lf", arr_of_prod[i].name, &arr_of_prod[i].price);
    printf("%s %.1lf\n", arr_of_prod[i].name, arr_of_prod[i].price);
}
}