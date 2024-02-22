#include <stdio.h>


void swap(int *a, int *b) 
	{ 
	int temp = *a; 
	*a = *b; 
	*b = temp; 
	}

// bubble sort function
void bubbleSort(int array[], int n) 
	{ 
		int i, j; 
		for (i = 0; i < n-1; i++)       
		for (j = 0; j < n-i-1; j++) if (array[j] > array[j+1]) 
		swap(&array[j], &array[j+1]); 
	}   

int main(){
	int nums[3]; 
	printf("Give the first number:");
 	scanf("%d", &nums[0]);

	printf("Give the second number:");
	scanf("%d", &nums[1]);

	printf("Give the third number:");
	scanf("%d", &nums[2]);

	bubbleSort(nums, 3);
	
	int a;
	printf("How many largest do you want to get back (1,2,3):");
	scanf("%d", &a);

	if(a==1 || a==2 || a==3)
	printf("The %d. largest number was: %d \n", a, nums[3-a]);	
	else
		printf("Error! Only 3 elements were given, but you asked for the %d largest\n", a);
}
