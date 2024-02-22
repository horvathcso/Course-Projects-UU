#include <stdio.h>
#include <string.h>

int main(int argc, char const *argv[]){
double price;
char product[20];
char filename[30];
int n;

strcpy(filename,argv[1]);
 FILE* ptr = fopen(filename, "r");
    if (ptr == NULL) {
        printf("no such file.");
        return 0;
    }


fscanf(ptr, "%d", &n);

for (int i = 0; i < n; i++)
{
    fscanf(ptr, "%s %lf", product, &price);
    printf("%s %.1lf\n", product, price);
}


}