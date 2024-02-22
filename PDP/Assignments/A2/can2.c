#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <math.h>
#include <mpi.h>
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

int main(int argc, char *argv[])
{
     // Arguments
    if (3 != argc) {
		printf("Usage: ./matmul input_file output_file\n");
		return 1;
	}
	char *input_name = argv[1];
	char *output_name = argv[2];

	// define variable
    int size, rank;
    int n, N_loc;
    int id0, id1;
    double s_time, loc_time, glob_time;
    double* A;
    double* B;
    double* C;
    double* A_loc;
    double* B_loc;
    double* C_loc;

    int source, up, right, down, left;
    int ndims, dims[2], periods[2], reorder;

    MPI_Datatype col_type;
    MPI_Comm comm2D;
    MPI_Status status;
    //MPI init
    MPI_Init(&argc, &argv);

    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

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
    dims[0] = sqrt(size); dims[1] = sqrt(size);
    if(rank==root && (dims[0]*dims[1]!=size || n%dims[0]!=0)){
        printf("Number of process should be a square number and it should divide n!!!\n");
    }
    periods[0]=1; periods[1]=1;
    reorder=0, ndims=2;
    MPI_Cart_create(MPI_COMM_WORLD,ndims,dims,periods,reorder,&comm2D);
    MPI_Cart_shift(comm2D,1,1,&left,&right);
    MPI_Cart_shift(comm2D,0,1,&up,&down);
    N_loc=n/dims[0];
    A_loc=(double*)malloc(N_loc*N_loc*sizeof(double));
    B_loc=(double*)malloc(N_loc*N_loc* sizeof(double));
    C_loc=(double* )calloc(N_loc*N_loc, sizeof(double));
   

	// Distributing the input data for Cannon's alg starting distribution
    MPI_Type_vector(N_loc, N_loc, n, MPI_DOUBLE, &col_type);
    MPI_Type_commit(&col_type);

    if(rank==root){
        for (int i = 0; i < dims[0]; i++){
            for (int j = 0; j < dims[0]; j++)
            {
                if(i!=0 || j!=0){
                    MPI_Send(&A[i*(N_loc*n)+(((j+i)%dims[0])*N_loc)], 1, col_type, i*dims[0]+j, i*dims[0]+j, MPI_COMM_WORLD);
                    MPI_Send(&B[((j+i)%dims[0])*(N_loc*n)+j*N_loc], 1, col_type, i*dims[0]+j, i*dims[0]+j, MPI_COMM_WORLD);
                }
            }
        }
        // using sendrecv to avoid deadlock when sending data to itself
        MPI_Sendrecv(A, 1, col_type, root, root, A_loc, N_loc*N_loc,  MPI_DOUBLE, root, root, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        MPI_Sendrecv(B, 1, col_type, root, root, B_loc, N_loc*N_loc,  MPI_DOUBLE, root, root, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }
    else{
        MPI_Recv(A_loc, N_loc*N_loc, MPI_DOUBLE, root, rank, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        MPI_Recv(B_loc, N_loc*N_loc, MPI_DOUBLE, root, rank, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }
    
    // As A,B no more needed we can free the memory for them in the root
    if(rank==root){
        free(A);
        free(B);
    }

    
    s_time = MPI_Wtime();
    
    for(int shift=0;shift<dims[0];shift++) {
    // Matrix multiplication
    for(int i=0;i<N_loc;i++){
        id0=i*N_loc;
        for(int k=0;k<N_loc;k++){
            id1=k*N_loc;
            for(int j=0;j<N_loc;j++)
                C_loc[id0+j]+=A_loc[id0+k]*B_loc[id1+j];
        }
    }
   
    if(shift==dims[0]-1) break;
    // Communication
    MPI_Sendrecv_replace(A_loc, N_loc*N_loc, MPI_DOUBLE, left, 0, right, 0, comm2D, MPI_STATUS_IGNORE);   
    MPI_Sendrecv_replace(B_loc, N_loc*N_loc, MPI_DOUBLE, up, 0, down, 0, comm2D, MPI_STATUS_IGNORE);   
    }

   // Gather timer data and C
    loc_time = MPI_Wtime() - s_time;
    MPI_Reduce(&loc_time, &glob_time, 1, MPI_DOUBLE, MPI_MAX, root, MPI_COMM_WORLD);


    
    if(rank==root){
        C=(double*)malloc(n*n*sizeof(double));
        for (size_t i = 0; i < dims[0]; i++){
            for (size_t j = 0; j < dims[0]; j++)
            {
                if(i!=0 || j!=0){
                    MPI_Recv(&C[i*(N_loc*n)+(j*N_loc)], 1, col_type, i*dims[0]+j, i*dims[0]+j, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                }
            }
        }
        MPI_Sendrecv(C_loc, N_loc*N_loc,  MPI_DOUBLE, root, root, C, 1, col_type, root, root,  MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }
    else{
        MPI_Send(C_loc, N_loc*N_loc, MPI_DOUBLE, root, rank, MPI_COMM_WORLD);
    }

 if(rank==root){
        printf("%.4lf\n",glob_time);
        write_output(output_name, C, n);
        free(C);
    }    
    
    free(A_loc);
    free(B_loc);
    free(C_loc);
    MPI_Comm_free( &comm2D );
    MPI_Finalize();
    return 0;
}