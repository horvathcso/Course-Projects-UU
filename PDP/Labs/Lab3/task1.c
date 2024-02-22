#include  <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include  "mpi.h"

#define root 0

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
        matrix[i]=(rand() % 1000)/1000.0;
    }
}

void right_communicate(double* matrix, int n, int k, int s_size, int right, int left, MPI_Request* request){
    double* rcv = (double*) malloc(s_size * n * sizeof(double));
    MPI_Isend(&matrix[n*k-(s_size*n)], s_size*n, MPI_DOUBLE, right, 1, MPI_COMM_WORLD, request);
    MPI_Recv(rcv, s_size*n, MPI_DOUBLE, left, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    MPI_Wait(request, MPI_STATUS_IGNORE);

    for (size_t i = 0; i < n*k-(s_size*n); i++)
    {
        matrix[n*k-1-i]=matrix[n*k-1-i-(s_size*n)];
    }
    for (size_t i = 0; i < s_size*n; i++)
    {
        matrix[i]=rcv[i];
    }

    free(rcv);
}

void comm_pi(int i, double* matrix, int rank, MPI_Datatype* Vectype, int n){
    if(rank == i){
        MPI_Sendrecv(&matrix[n-1], 1, *Vectype, i+1, 1, &matrix[n-1], 1, *Vectype, i+1, 2, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }
    else if(rank == i+1){
        MPI_Sendrecv(&matrix[0], 1, *Vectype, i, 2, &matrix[0], 1, *Vectype, i, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }
}

void main( int argc, char *argv[] )
{
    int m = 2;
    int n = 10;
    int k;
    double* A_local;

    int left, right;
    int ierr, rank, size;
    MPI_Datatype Dtype;
    MPI_Datatype Vectype;
    MPI_Status status;
    MPI_Request request;
    int i,j;

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

// TASK A
    // define Dtype containing m row
        // Note: I doesn't chek that m<k
    MPI_Type_contiguous(m*n,MPI_DOUBLE,&Dtype);
    MPI_Type_commit(&Dtype);

    
    // define variables
    k = n/size;

    right = rank + 1;
	if (right == size) right = 0;
	
	left = rank - 1;
    if (left == -1) left = size-1;

    A_local=(double*)malloc(k*n*sizeof(double));
    fill_matrix(A_local, k*n);

    print_local(A_local, n, k, rank);
    // Asked right communication
    right_communicate(A_local, n, k, 2, right, left, &request);

    print_local(A_local, n, k, rank);

//TASK B
    MPI_Type_vector(n,1,n,MPI_DOUBLE,&Vectype);
    MPI_Type_commit(&Vectype);
    
    comm_pi(0, A_local, rank, &Vectype, n);

    print_local(A_local, n, k, rank);

//TASK C
    // It is the same if I define storage staticly


    free(A_local);
    MPI_Finalize();

}