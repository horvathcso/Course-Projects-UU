#include "stencil.h"
#define root 0
#define to_right 201
#define to_left 102

int main(int argc, char **argv) {
	if (4 != argc) {
		printf("Usage: stencil input_file output_file number_of_applications\n");
		return 1;
	}
	char *input_name = argv[1];
	char *output_name = argv[2];
	int num_steps = atoi(argv[3]);

	
	double *input0=NULL;
    double *input=NULL;
    double *left_stecil=NULL;
    double *right_stecil=NULL;
    double *run_times=NULL;
    int num_values, length;
    int left, right;
    int size;
    int rank;
	double max_runtime;

	MPI_Request recv_status_right;
	MPI_Request request_right;
	MPI_Request recv_status_left;
	MPI_Request request_left;

    //MPI init
    MPI_Init(&argc, &argv);

    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    right = rank + 1;
	if (right == size) right = 0;
	
	left = rank - 1;
	if (left == -1) left = size-1;

	
    if(rank==root){
    // Read input file
    
	if (0 > (num_values = read_input(input_name, &input0))) {
		return 2;
	}
    }
	//Broadcastin the length of the input
    MPI_Barrier(MPI_COMM_WORLD);
    MPI_Bcast(&num_values, 1, MPI_INT, root, MPI_COMM_WORLD);
    MPI_Barrier(MPI_COMM_WORLD);
    length=num_values/size;
    input=(double*)malloc(length*sizeof(double));

	// Distributing the input data
    MPI_Scatter(input0, length, MPI_DOUBLE, input, length, MPI_DOUBLE, root, MPI_COMM_WORLD);


	// Stencil values
	double h = 2.0*PI/num_values;
	const int STENCIL_WIDTH = 5;
	const int EXTENT = STENCIL_WIDTH/2;
	const double STENCIL[] = {1.0/(12*h), -8.0/(12*h), 0.0, 8.0/(12*h), -1.0/(12*h)};


    left_stecil=(double*)malloc(EXTENT*sizeof(double));
    right_stecil=(double*)malloc(EXTENT *sizeof(double));

	// Start timer
	MPI_Barrier(MPI_COMM_WORLD);
	double start = MPI_Wtime();

	// Allocate data for result
	double *output;
	if (NULL == (output = malloc(length * sizeof(double)))) {
		perror("Couldn't allocate memory for output");
		return 2;
	}

	// Repeatedly apply stencil
	for (int s=0; s<num_steps; s++) {

		// Send processes for sync with neighbours
		MPI_Isend(input, EXTENT , MPI_DOUBLE, left, to_left, MPI_COMM_WORLD, &request_left);
		MPI_Isend(&input[length-EXTENT], EXTENT , MPI_DOUBLE, right, to_right, MPI_COMM_WORLD, &request_right);
		MPI_Irecv(&left_stecil[0], EXTENT, MPI_DOUBLE, left, to_right, MPI_COMM_WORLD, &recv_status_left);
		MPI_Irecv(&right_stecil[0], EXTENT, MPI_DOUBLE, right, to_left, MPI_COMM_WORLD, &recv_status_right);

		
		for (int i=EXTENT; i<length-EXTENT; i++) {
			double result = 0;
			for (int j=0; j<STENCIL_WIDTH; j++) {
				int index = i - EXTENT + j;
				result += STENCIL[j] * input[index];
			}
			output[i] = result;
		}
		
		// Receive process for sync with neighbours - just before it's application
		MPI_Wait(&recv_status_left, MPI_STATUS_IGNORE);


		for (int i=0; i<EXTENT; i++) {
			double result = 0;
			for (int j=0; j<STENCIL_WIDTH; j++) {
				int index = (i - EXTENT + j);
				if (index>=0)
					result += STENCIL[j] * input[index];
				else
					result += STENCIL[j] * left_stecil[EXTENT+index];
			}
			output[i] = result;
		}


		// Receive process for sync with neighbours - just before it's application
		MPI_Wait(&recv_status_right, MPI_STATUS_IGNORE);

		for (int i=length-EXTENT; i<length; i++) {
			double result = 0;
			for (int j=0; j<STENCIL_WIDTH; j++) {
				int index = (i - EXTENT + j);
				if (index<length)
					result += STENCIL[j] * input[index];
				else
					result += STENCIL[j] * right_stecil[index-length];
			}
			output[i] = result;
		}
		// Swap input and output
		MPI_Wait(&request_left, MPI_STATUS_IGNORE);
		MPI_Wait(&request_right, MPI_STATUS_IGNORE);
		
		if (s < num_steps-1) {
			double *tmp = input;
			input = output;
			output = tmp;
		}
	}
	free(input);
	// Stop timer
	double my_execution_time = MPI_Wtime() - start;


    //Gather data and runtime on root
	MPI_Gather(output, length, MPI_DOUBLE, input0, length, MPI_DOUBLE, root ,MPI_COMM_WORLD);
	
    if(rank==root)
        run_times=(double *)calloc(size,sizeof(double));
	
	MPI_Reduce(&my_execution_time, &max_runtime, 1, MPI_DOUBLE, MPI_MAX, root, MPI_COMM_WORLD);
    // Write results from root
    if(rank==root){

            printf("%f\n", max_runtime);
        #ifdef PRODUCE_OUTPUT_FILE
            if (0 != write_output(output_name, input0, num_values)) {
                return 2;
            }
        #endif
    }

	// Clean up
	free(output);
    free(input0);
    MPI_Finalize();
	return 0;
}


int read_input(const char *file_name, double **values) {
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
	if (NULL == (*values = malloc(num_values * sizeof(double)))) {
		perror("Couldn't allocate memory for input");
		return -1;
	}
	for (int i=0; i<num_values; i++) {
		if (EOF == fscanf(file, "%lf", &((*values)[i]))) {
			perror("Couldn't read elements from input file");
			return -1;
		}
	}
	if (0 != fclose(file)){
		perror("Warning: couldn't close input file");
	}
	return num_values;
}


int write_output(char *file_name, const double *output, int num_values) {
	FILE *file;
	if (NULL == (file = fopen(file_name, "w"))) {
		perror("Couldn't open output file");
		return -1;
	}
	for (int i = 0; i < num_values; i++) {
		if (0 > fprintf(file, "%.4f ", output[i])) {
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
