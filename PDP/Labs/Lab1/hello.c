/**********************************************************************
 * A simple "hello world" program for MPI/C
 *
 **********************************************************************/

#include <mpi.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
  
  MPI_Init(&argc, &argv);               /* Initialize MPI               */

  // Get the number of processes
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);


    // Get the rank of the process
    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    // Print off a hello world message
    printf("Hello world!!\nRank %d out of %d processors\n",
            world_rank+1, world_size);

    // Finalize the MPI environment.
  

  MPI_Finalize();                       /* Shut down and clean up MPI   */

  return 0;
}
