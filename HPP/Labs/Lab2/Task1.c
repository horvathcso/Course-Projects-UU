#include <stdio.h>

int main() {
	for (int i=100; i>=0; i=i-2)
		printf("%d \n",i);
	
	int i=100;
	while (i>=0){
		printf("%d \n",i);
		i=i-2;
	}

	i=100;
	do{
		printf("%d \n",i);
		i=i-2;
	}while(i>=0);

	return 0;
}
