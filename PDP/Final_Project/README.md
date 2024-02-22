#Individual project created by Csongor Horváth - Maj of 2023
####Course: Parallel and Distributed Programming
##The usage of the code
###Settings of the code

There are several options available for how to use the code. All can be done by changing the 0s and 1s in the top of the file. I list the options below.

- `#define print_norm 1` print the final calculated norm (True in submitted version)
- `#define print_time 0` print run time (False in submitted version)
- `#define is_precise 0` determines whether iteration goes until convergence with the given parameters `#define eps` for stopping at given precision and `#define MAX_ITER` for stopping after a given number of iterations. When is_precise is false, the loop goes for 200 iterations (this is the case in submitted version)
- `#defini save 0` - to gather and save the result vector (u) in a file *named out_${n}.txt* (False in submitted version)

### Compiling and running the code
After setting the necessary options in the top of the code according to the above guide, let's compile and run the code.

- To compile the code, let's run the make file (`make`) - or run the next command `mpicc -std=c99 -g -O3 -o cg cg.c -lm`
- For running the compiled code, use the following command: `mpirun -n ${p} ./cg ${n}`. Here `p` is the number of processes used, and `n` is the only necessary input parameter explained in the assignment and in the report. Also, you may use `-oversubscribe` for running. Note: The program is working with an arbitrary p value, but square p values are encouraged.
- After running the code, you will see the chosen data. If both data is printed, then the norm appears earlier. It is also easy to know which is which as time is printed with 4 digit precision and the norm is 10.
- If you finish using the program, you can use `make clean` to delete the binary file.

### Final details

For theoretical background, implementation details, optimization efforts, and scaling experiments, you should read the report found in this tar file.

If you have any questions after testing and reading the report, please contact the author at Studium or at the following e-mail address: `sifuto2013@gmail.com`.





