#include <stdio.h>

int main(){
double price;
char product[20];
int n;


 FILE* ptr = fopen("data.txt", "r");
    if (ptr == NULL) {
        printf("no such file.");
        return 0;
    }


fscanf(ptr, "%d", &n);

for (int i = 0; i < n; i++)
{
    fscanf(ptr, "%s %lf", product, &price);
    printf("%s %lf\n", product, price);
}


}