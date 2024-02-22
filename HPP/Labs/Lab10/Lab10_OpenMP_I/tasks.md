## Task 1
If we run without `-fompenmp` than we the parallel section only runs once.

When we used the compiler flag, the openmp commands have effects and the section will run threadnumber timess (5 in this case).

If `num_threads(*)` removed, the nr of thread in the computer will be used 

It works setting the variable `export OMP_NUM_THREADS=3`, now 3 version is running insted of 4.

It is also working to set it from the program with `omp_set_num_threads(6)`. In this case we need the header `<omp.h>`

## Task 2
Loop variable is long int, because it should store number up to 3*10^9, and int is only up to around 2*10^9.

As I increase n from no1 the run times are getting slightly longer at each step, but not too much.
e.g: 6.3s, 6.9s,  7.9s, 8.3s, 10.0s, 12.4s, 14.46s, 16.8s, 18.6s ...

I don't really understand why it is increasing in this way.

## Task 3
The `omp_get_thread_num()` work as expected, the `omp_get_num_threads` returns the set value of num threads, while the max version is seemingly returns the environment variable `OMP_NUM_THREADS`

## Task 4
Yeah it works the thread functions can acces the correct parts of the daata.

And returning result is also work as expected.

## Task 5
runtimes: 0-8: 1.706s;   1-7: 1.519s;    2-6: 1.307s;   3-5: 1.145s;    4-4: 0.936s

For top I multiply by 10 so I can see whats happening: For 4-4 the CPU works around 200% almost the whole time, with other splits the 200% usage only happens in the begining than it is around 100% except 0-8, where it is only 100%

The speed up is close to expected 1.7 vs 0.9

## Task 9
When disabeled the inner parallelism content only run once in every outer paralleled iteration

I was able to make the task work, though had lots of problem with header and flags and how to use

The run time improved as expected when splitting to two thread (2 core 4 threads in my machine). So it is normal it is fastest at 2 threads
  
