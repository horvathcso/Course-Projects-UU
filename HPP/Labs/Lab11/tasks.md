## Task 1
private only initialize -> unpredictable, firstprivate also copy the current value
  
  
## Task 2
Runtime 3 task 2 thread

real	0m2,377s
user	0m3,640s
sys	0m0,005s

3 task 3 thread

real	0m1,357s
user	0m3,961s
sys	0m0,000s



## Task 3

Runtime simple_loop: no `-fopenmp` : 2.366s, with flag: 0.922s (2,663 user) and result is still correct

It works the same with one line openmp command `#pragma omp parallel for`

Other-loop with simple paralelization the result is not fix. Possible fix is to calculate y deterministicly evry time pow(1.01, i+1)

## Task 4
Yeah it is ok. The for loop tasks are independents.

Run times: 1th: 5.7s, 2th: 4.4s, 3th: 3.4s, 4th 3.1s

We cant see expected improvment due to load imbalance

schedule: 4th 

- static: 1.93s, - with self deifinid chunk size it is slower
 - dynamic 2.05s - with different chunk size I can't get improvement, 
 - guided 1.95s - similar performance with different small chunk sizes
 
## Task 5
timing original code

- 1th: 0.99s
- 2th: 0.54s
- 3th: 0.49s
- 4th: 0.40s

It works as expected after modification. I can make it with one line of modification. It's pperformanc is similar as original

## Task 6
It is easier to make he same parallelization it is have the same effect in change of result due to change in floting point representation.

I get an around 2 time speed up with 2 thread (I have 2 core), no further improvement. 

1.25s 0.67s

## Task 7
With smaller N values the spread up is increasing, eg from 2.01->1.69s to 2,50->1.77s

This means that the effect of false sharing can't be seen.

But the overall user time becomes more in the small N casess which suggest it can be caused by false sharing

The usertime is aound N_threads*original time which suggest some anomaly in the background, but this is the case for all the values not only N=8, 


## Task 8
By adding the parallel single and task directive I achived an improvment in thime from 3.0s 1.1s with N=500

## Task 9
best runtimes:
old: 0.495s 10^7
new: 0.504s 10^7

The old way of optimizing is slightly better, but very simmilar. It may be due to my computer has few cores and thus waiting for the task to finish is not too optimal in time

But it is also the case in the uni machines.
