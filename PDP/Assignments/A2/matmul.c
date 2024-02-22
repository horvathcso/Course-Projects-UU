#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#define root 0
#define FROM_FILE 1

int read_input(const char *file_name, double **matrix1, double **matrix2) {
	FILE *file;
	if (NULL == (file = fopen(file_name, "r"))) {
		perror("Couldn't open input file");
		return -1;
	}
	int n_val;
	if (EOF == fscanf(file, "%d", &n_val)) {
		perror("Couldn't read element count from input file");
		return -1;
	}
	if (NULL == (*matrix1 = malloc(n_val * n_val * sizeof(double)))) {
		perror("Couldn't allocate memory for input");
		return -1;
	}
	if (NULL == (*matrix2 = malloc(n_val * n_val * sizeof(double)))) {
		perror("Couldn't allocate memory for input");
		return -1;
	}
	for (int i=0; i<n_val*n_val; i++) {
		if (EOF == fscanf(file, "%lf", &((*matrix1)[i]))) {
			perror("Couldn't read elements from input file");
			return -1;
		}
	}
	for (int i=0; i<n_val*n_val; i++) {
		if (EOF == fscanf(file, "%lf", &((*matrix2)[i]))) {
			perror("Couldn't read elements from input file");
			return -1;
		}
	}
	if (0 != fclose(file)){
		perror("Warning: couldn't close input file");
	}
	return n_val;
}

int write_output(char *file_name, const double *matrix, int n_val) {
	FILE *file;
	if (NULL == (file = fopen(file_name, "w"))) {
		perror("Couldn't open output file");
		return -1;
	}
	for (int i = 0; i < n_val*n_val; i++) {
		if (0 > fprintf(file, "%.6f ", matrix[i])) {
			perror("Couldn't write to output file");
		}
	}
	if (0 != fclose(file)) {
		perror("Warning: couldn't close output file");
	}
	return 0;
}

void print_local(double* matrix, int n, int k, int rank){
    sleep(rank);
    printf("From process: %d\n", rank);
    for (size_t i = 0; i < k; i++)
    {
        for (size_t j = 0; j < n; j++)
        {
            printf("%lf ",matrix[i*n+j]);
        }
        printf("\n");
        
    }   
}
void fill_matrix(double* matrix, int length){
    srand(clock()); 
    for (size_t i = 0; i < length; i++)
    {
        matrix[i]=(rand() % 10000)/100000.0;
    }
}

int main(int argc, char **argv){
    // Arguments
    if (3 != argc) {
		printf("Usage: ./matmul input_file output_file\n");
		return 1;
	}
	char *input_name = argv[1];
	char *output_name = argv[2];

	// define variables
    int left, right;
    int size, rank;
    int n, m;
    int id0, id1, id2;
    double s_time, loc_time, glob_time;
    double* A;
    double* B;
    double* C;
    double* A_rows;
    double* B_cols;
    double* C_rows;

    MPI_Datatype col_type;

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
	#if FROM_FILE
    if (0 > (n = read_input(input_name, &A, &B))) {
		return 2;
	}
    #else
    n=1000;
    A=(double*)malloc(n*n*sizeof(double));
    B=(double*)malloc(n*n*sizeof(double));
    fill_matrix(A, n*n);
    fill_matrix(B, n*n);
    #endif
    }

	//Broadcast n & init varibles
    MPI_Bcast(&n, 1, MPI_INT, root, MPI_COMM_WORLD);
    
    m=n/size;
    A_rows=(double*)malloc(m*n*sizeof(double));
    B_cols=(double*)calloc(m*n, sizeof(double));
    C_rows=(double* )calloc(m*n, sizeof(double));


	// Distributing the input data by row & col
    MPI_Type_vector(n, m, n, MPI_DOUBLE, &col_type);
    MPI_Type_commit(&col_type);

    MPI_Scatter(A, m*n, MPI_DOUBLE, A_rows, m*n, MPI_DOUBLE, root, MPI_COMM_WORLD);

    if(rank==root){
        for (size_t i = 1; i < size; i++)
        {
            MPI_Send(&B[i*m], 1, col_type, i, i, MPI_COMM_WORLD);
        }
        // using sendrecv to avoid deadlock when sending data to itself
        MPI_Sendrecv(B, 1, col_type, root, root, B_cols, m*n,  MPI_DOUBLE, root, root, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }
    else{
        MPI_Recv(B_cols, m*n, MPI_DOUBLE, root, rank, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }

    // As A,B no more needed we can free the memory for them in the root
    if(rank==root){
        free(A);
        free(B);
    }


s_time = MPI_Wtime();

// Calculate C vals
for (size_t l = 0; l < size; l++)
{
    id0=(rank+l)%size*m;
    for (size_t i = 0; i < m; i++)
    {
        id1=i*n;
        for (size_t j = 0; j < n; j++)
        {
            id2=j*m;
            for(size_t k = 0; k < m; k++)
            {
                C_rows[k+id0+id1]+=A_rows[j+id1]*B_cols[id2+k];
            }  
        }
    }
    // Change col blocks  
    if(l!=l-1)
    MPI_Sendrecv_replace(B_cols, m*n, MPI_DOUBLE, left, 0, right, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);   
}

    // Gather timer data and C
    loc_time = MPI_Wtime() - s_time;
    
    MPI_Reduce(&loc_time, &glob_time, 1, MPI_DOUBLE, MPI_MAX, root, MPI_COMM_WORLD);
    if(rank==root)
    C=(double*)malloc(n*n*sizeof(double));
    MPI_Gather(C_rows, n*m, MPI_DOUBLE, C, n*m, MPI_DOUBLE, root, MPI_COMM_WORLD);
    
    if(rank==root){
        printf("%.4lf\n",glob_time);
        write_output(output_name, C, n);
        free(C);
    }    
    
    free(A_rows);
    free(B_cols);
    free(C_rows);
    MPI_Finalize();
}