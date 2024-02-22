#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


#define root 0
#define save 1

int read_input(const char *file_name, int **values) {
	FILE *file;
	if (NULL == (file = fopen(file_name, "r"))) {
		perror("Couldn't open input file");
		return -1;
	}
	int num_values;
	if (EOF == fscanf(file, "%d", &num_values)) {
		perror("Couldn't read element count from input file");
		return -1;
	}
	if (NULL == (*values = malloc(num_values * sizeof(int)))) {
		perror("Couldn't allocate memory for input");
		return -1;
	}
	for (int i=0; i<num_values; i++) {
		if (EOF == fscanf(file, "%d", &((*values)[i]))) {
			perror("Couldn't read elements from input file");
			return -1;
		}
	}
	if (0 != fclose(file)){
		perror("Warning: couldn't close input file");
	}
	return num_values;
}

int write_output(char *file_name, const int *output, int num_values) {
	FILE *file;
	if (NULL == (file = fopen(file_name, "w"))) {
		perror("Couldn't open output file");
		return -1;
	}
	for (int i = 0; i < num_values; i++) {
		if (0 > fprintf(file, "%d ", output[i])) {
			perror("Couldn't write to output file");
		}
	}
	if (0 > fprintf(file, "\n")) {
		perror("Couldn't write to output file");
	}
	if (0 != fclose(file)) {
		perror("Warning: couldn't close output file");
	}
	return 0;
}

int is_power_of_two(int x){
    return (x != 0) && ((x & (x - 1)) == 0);
}

int log_2(int x){
    int count=0;
    int pow=1;
    while(x > pow){
        count++; 
        pow*=2;
    }

    return count;
}

// Codes for serial sorting
    int partition(int** arr, int low, int high) {
    int pivot = *(*arr + high);
    int i = (low - 1);

    for (int j = low; j <= high - 1; j++) {
        if (*(*arr + j) < pivot) {
        i++;
        int temp = *(*arr + i);
        *(*arr + i) = *(*arr + j);
        *(*arr + j) = temp;
        }
    }
    int temp = *(*arr + i + 1);
    *(*arr + i + 1) = *(*arr + high);
    *(*arr + high) = temp;

    return (i + 1);
    }

    void quickSort(int** arr, int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
    }

    void serial_sort(int** arr, int length) {
    quickSort(arr, 0, length - 1);
    }

int print_list(int* arr, int n){
    for (size_t i = 0; i < n; i++)
    {
        printf("%d ",arr[i]);
    }
    printf("\n");
    
}

int get_pivot(int median, int is_empty ,MPI_Comm* comm, int rank, int size, int pivot_strategy){
	int res; int all_empty; int sum;
	int* medians=(int*)malloc(size*sizeof(int));
	MPI_Allreduce(&is_empty, &all_empty, 1, MPI_INT, MPI_SUM, *comm);
	MPI_Gather(&median, 1, MPI_INT, medians, 1, MPI_INT, root, *comm);
	if(!all_empty){
		if(rank==root){
		switch (pivot_strategy)
			{
			case 1:
				res=median;
				break;
			
			case 2:
				serial_sort(&medians, size);
				res=medians[size/2];
				break;

			case 3:
				sum=0;
				for (int i = 0; i < size; i++)
					sum +=medians[i];
				res=sum/size;
				break;
			}

		for (int i = 0; i < size; i++)
			medians[i]=res;
		}
	}
	else{ // case where some of the processes has currently empty sets
		int* empties=(int*)malloc(size*sizeof(int));
		MPI_Gather(&is_empty, 1, MPI_INT, empties, 1, MPI_INT, root, *comm);
		if(rank==root){
			res=0;
			switch (pivot_strategy)
				{
				case 1:
					for (int i = 0; i < size; i++){
					if(!empties[i]){
						res=medians[i];
						break;
					}
					}
					break;
				
				case 2:
					int max=0;
					for (int i = 0; i < size; i++){
						if(medians[i]>max)
							max=medians[i];
					}
					for (int i = 0; i < size; i++){
						if(empties[i]){
							medians[i]=max+1;
						}
					}
					serial_sort(&medians, size);
					res=medians[(size-all_empty)/2];
					break;

				case 3:
					int sum=0;
					for (int i = 0; i < size; i++){
						if(empties[i]){
							sum += medians[i];
						}
					}
					if(size-all_empty!=0)
					res=sum/(size-all_empty);
					break;
				}
		for (int i = 0; i < size; i++)
			medians[i]=res;
		}
		free(empties);
	}
	// scattering pivot value
	MPI_Scatter(medians, 1, MPI_INT, &res, 1, MPI_INT, root, *comm);
	free(medians);
	return res;
}

void merge_lists(int* lis1, int* lis2, int len1, int len2, int** arr_pointer){
	int* merge;
	if(len1+len2==0){
		merge=NULL;
	}
	else{
	int i=0; int j=0;
	merge = (int*)malloc((len1+len2)*sizeof(int));
	while (i<len1 && j<len2)
	{
		if(lis1[i]<lis2[j]){
			merge[i+j]=lis1[i];
			i++;
		}
		else{
			merge[i+j]=lis2[j];
			j++;
		}
	}
	while(i<len1){
		merge[i+j]=lis1[i];
		i++;
	}
	while(j<len2){
		merge[i+j]=lis2[j];
		j++;
	}
	}
	free(*arr_pointer);
	*arr_pointer = merge;
}

int main(int argc, char **argv) {
	if (4 != argc) {
		printf("Usage: qsort input_file output_file pivot_strategy(1-3)\n");
		return 1;
	}
	char *input_name = argv[1];
	char *output_name = argv[2];
	int pivot_strategy = atoi(argv[3]);

	
	int *local_data=NULL;
    int *input=NULL;
	int* output=NULL;

    double run_time;
    double max_runtime;
    int size; int log2size;
    int rank; 
    int n; int length; int length_shift=0;
    int median, pivot;
	int goal_idx, send_size, cnt, rec_size;
	int idx_send, idx_use;
	int* buffer=NULL;
	int* sendc=NULL; int* recc=NULL; int* displ=NULL;
	int i;
	int is_empty=0;

	

	MPI_Request send_req1;
	MPI_Request send_req2;
	

    //MPI init
    MPI_Init(&argc, &argv);

    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);


if(!is_power_of_two(size))//checking if number of processor really is a power of 2
    {printf("The number of processors shouldd be a powwer of 2!\n"); return 0;}
	
log2size = log_2(size);
MPI_Comm comm[log2size];
int ranks[log2size];
int sizes[log2size];
int color;

//Setting up the data 
    if(rank==root){
    // Read input file
	if (0 > (n = read_input(input_name, &input))) {
		return 2;
	}
    }


	// Start timer
	MPI_Barrier(MPI_COMM_WORLD);
	double start = MPI_Wtime();


//ALG step 1 - Distributing data as equal as possible
    MPI_Bcast(&n, 1, MPI_INT, root, MPI_COMM_WORLD);
    length=n/size;

if(n<size){
	if(rank==root){
		double start = MPI_Wtime();
		serial_sort(&input,n);
		run_time=MPI_Wtime()-start;
		output=input;
	}
}
else{
    if(n%size==0){ // Distribution if it is possible equally
            local_data=(int*)malloc(length*sizeof(int));
            MPI_Scatter(input, length, MPI_INT, local_data, length, MPI_INT, root, MPI_COMM_WORLD);
        }

    else{ // Distribution if it is impossible equally
        length++;
        local_data=(int*)malloc(length*sizeof(int));
        if(rank >= n%size) 
            length_shift=-1;  
        
        sendc=(int*)malloc(size*sizeof(int));
    	displ=(int*)malloc(size*sizeof(int));
        for (int i = 0; i < size; i++)
        {
            if (i < n%size)
                {sendc[i]=length;
                if(i!=0)
                    displ[i]=displ[i-1]+length;
                else
                    displ[i]=0;}
            else
                {sendc[i]=length-1;
				if (i==n%size)
					displ[i]=displ[i-1]+length;
				else
	                displ[i]=displ[i-1]+(length-1);}
        }
        MPI_Scatterv(input, sendc, displ, MPI_INT, local_data, length, MPI_INT, root, MPI_COMM_WORLD);
		length=length+length_shift;
		free(sendc);free(displ);
        }

	if(rank==root)
		free(input);

// ALG 2 - Sort the data locally for each process
	serial_sort(&local_data, length);

//ALG 3 - Perform global sort (Note even if it a recursive algorithms it is implemented withouth recursion as the depth is fix)
	MPI_Comm_dup(MPI_COMM_WORLD,&(comm[0]));
	for (i = 0; i < log2size; i++)
	{
	// Setting up the splitting of the communication
		MPI_Comm_size(comm[i], &(sizes[i]));
    	MPI_Comm_rank(comm[i], &(ranks[i]));
		color=ranks[i]/(sizes[i]/2);
		MPI_Comm_split(comm[i], color, ranks[i], &(comm[i+1]));
	
	//ALG 3.1 get pivot element with 
		if(length==0){
			is_empty=1;
			median=0;}
		else{
			is_empty=0;
			median=local_data[(length)/2];}
		pivot=get_pivot(median, is_empty, &comm[i], ranks[i], sizes[i], pivot_strategy);

	//ALG 3.2 divide data according to pivot
		//finding splitting points
		for (cnt = 0; cnt < length; cnt++){
			if(local_data[cnt]>pivot){
				break;
			}
		}

		//setting up indexes to exchange data
		if(ranks[i] < sizes[i]/2){
			goal_idx=ranks[i]+sizes[i]/2;	
			send_size=length-cnt;
			idx_send=cnt;
			idx_use=0;
		}
		else{
			goal_idx=ranks[i]-sizes[i]/2;
			send_size=cnt;
			idx_send=0;
			idx_use=cnt;
		}
	
	//ALG 3.3 Communicate data in the given pair
		//Note: it is possible that some list is empty in this process, which needs some care
		MPI_Isend(&send_size, 1, MPI_INT, goal_idx, 0, comm[i],&send_req1);
		MPI_Recv(&rec_size, 1, MPI_INT, goal_idx, 0, comm[i], MPI_STATUS_IGNORE);
		MPI_Wait(&send_req1, MPI_STATUS_IGNORE);
		
		if (send_size!=0)
			MPI_Isend(&(local_data[idx_send]), send_size, MPI_INT, goal_idx, 0, comm[i], &send_req2);
		
		if(rec_size!=0){
			buffer=(int*)malloc(rec_size*sizeof(int));
			MPI_Recv(buffer, rec_size, MPI_INT, goal_idx, 0, comm[i], MPI_STATUS_IGNORE);
		}

		if (send_size!=0)
			MPI_Wait(&send_req2, MPI_STATUS_IGNORE);

	//ALG 3.4 merge the local and recived list - modify local length
		merge_lists(&(local_data[idx_use]), buffer, length-send_size, rec_size, &local_data);
		length=length-send_size+rec_size;
		free(buffer);
		buffer=NULL;
	}

//ALG 5 - Gather sorted data in the root
	recc=(int*)calloc(size,sizeof(int));
	displ=(int*)malloc(size*sizeof(int));

	//Get the length of the arrays in the processes
	MPI_Gather(&length, 1, MPI_INT, recc, 1, MPI_INT, root, MPI_COMM_WORLD);
	displ[0]=0;
	for (int i = 1; i < size; i++){
			displ[i]=displ[i-1]+recc[i-1];
	}

	//Gather the final ordered list
	if(rank==root)
		output=(int*)malloc(n*sizeof(int));
	MPI_Gatherv(local_data, length, MPI_INT, output, recc, displ, MPI_INT, root, MPI_COMM_WORLD);

//Stop clock

	run_time = MPI_Wtime()-start;
	//get the measured runtime
	MPI_Reduce(&run_time, &max_runtime, 1, MPI_DOUBLE, MPI_MAX, root, MPI_COMM_WORLD);	

	// Clean up
	free(local_data);
    free(recc);
	free(displ);
}

	// Write results from root
    if(rank==root){
		printf("%lf\n", max_runtime);
		
		#if save
		if (0 != write_output(output_name, output, n)) {
			return 2;
		}
		free(output);
		#endif
    }

	if(n>=size)
	for (int i = 0; i < log2size; i++){
		MPI_Comm_free(&comm[i]);
	}
	
	MPI_Finalize();
	return 0;
}