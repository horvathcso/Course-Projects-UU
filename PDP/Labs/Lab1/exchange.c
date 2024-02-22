/**********************************************************************
 * Point-to-point communication using MPI
 *
 **********************************************************************/

#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  int rank, size;
  double a, b;
  MPI_Status status;

  MPI_Init(&argc, &argv);               /* Initialize MPI               */
  MPI_Comm_size(MPI_COMM_WORLD, &size); /* Get the number of processors */
  MPI_Comm_rank(MPI_COMM_WORLD, &rank); /* Get my number                */
  
  a = 100.0 + (double) rank;  /* Different a on different processors */

  /* Exchange variable a, notice the send-recv order */
  for (size_t i = 0; i < size; i++)
  {
    if(rank==i){
      if(rank==0){
          MPI_Send(&a, 1, MPI_DOUBLE, (rank+1)%size, (rank+1)%size, MPI_COMM_WORLD);
          MPI_Recv(&b, 1, MPI_DOUBLE, (rank-1+size)%size, rank, MPI_COMM_WORLD, &status);
          printf("Processor %d got %f from processor %d\n", rank, b, (rank-1+size)%size);      
      }
      else{
        MPI_Recv(&b, 1, MPI_DOUBLE, (rank-1+size)%size, rank, MPI_COMM_WORLD, &status);
          MPI_Send(&a, 1, MPI_DOUBLE, (rank+1)%size, (rank+1)%size, MPI_COMM_WORLD);  
          printf("Processor %d got %f from processor %d\n", rank, b, (rank-1+size)%size);
      }
        }
      }

  MPI_Finalize(); 

  return 0;
}
