#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main()
{

int data1;
double data2;
char data3;
float data4;

//Verify that the total size of above data
//becomes 17 bytes

int result=sizeof(data1)+sizeof(data2)+sizeof(data3)+sizeof(data4);
// printf("Total size:%d\n",result); // commented out to make output exactly 4 line



//Open the file
    FILE* f  = fopen("little_bin_file", "r");
        
        if (f == NULL) {
            printf("file not exist.");
            return 0;
        }

//Read and print the integer
fread(&data1,sizeof(int),1,f);
printf("integer datatype %d\n",data1);

//Read and print the floating-point
fread(&data2,sizeof(double),1,f);
printf("double datatype %lf\n",data2);

//Read and print the character
fread(&data3,sizeof(char),1,f);
printf("char datatype %cr\n",data3);

//Read and print the floating-point
fread(&data4,sizeof(float),1,f);
printf("float datatype %f\n",data4);


//Close the file
fclose(f);
}



