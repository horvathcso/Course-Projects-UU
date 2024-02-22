/*
    THIS CODE DOES NOT WORK
*/


#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <math.h>
#include <mpi.h>

#define root 0

int f(int i){
    int lower = -500;
    int upper = 500;
    int res = (rand() % (upper - lower + 1)) + lower; 
    return res;
}

int main(int argc, char *argv[]){
    /* Implementation follows the given serial source code search.c
            https://people.sc.fsu.edu/~jburkardt/c_src/search/search.c

            So given process: given function f as a c function to call f(i), i integer
                Task find smallest integer C in range [A,B] s.t. f(C) = x

            Possible application: Find integer root of a function in a given range [A,B]
            Note: With modification it can be use to find smallest given element in a list
    */
   
    // for random function implementation
    srand(time(NULL));

	// define variable
    int A = 0;
    int B = 1000000;
    int x=0;
    int size, rank;
    int kill=0;
    int i, j;
    int batch = 5;
    
    

    //MPI init
    MPI_Init(&argc, &argv);

    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    MPI_Request req[size];

    for (i = 0; i < size; i++)
    {
        if (i != rank)
        {
            MPI_Irecv(&kill, 1, MPI_INT, i, 0, MPI_COMM_WORLD, &req[i]);
        }
    }

    for (i = A + rank; i < B; )
    {
        if(kill==1)
            break;

        for (int k = 0; k < batch && i<B; k++)
        {
            if(f(i)==x)
            {
                for (j = 0; j < size; j++)
                {
                    kill=1;
                    if(j != rank)
                        MPI_Send(&kill, 1, MPI_INT, j, 0, MPI_COMM_WORLD);
                }
            printf("First appearance of x in range [A,B] of function f is at %d\n", i);
            break;
            }
            i=i+size;
        }
        MPI_Barrier(MPI_COMM_WORLD);
    }

    MPI_Finalize();
    return 0;

}