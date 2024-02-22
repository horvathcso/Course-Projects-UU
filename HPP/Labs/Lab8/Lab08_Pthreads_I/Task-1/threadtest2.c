#include <stdio.h>
#include <pthread.h>
#include<unistd.h>

static int s= 1;
static int n=2;
static int l= 4;

void* the_thread_func(void* arg) {
  int a =*(int *)arg; 
printf("thread %d() starting doing some work.\n",a);
long int i;
double sum;
for(i = 0; i < 1000000000; i++)
sum += 1e-7;
for(i = 0; i < 1000000000; i++)
sum += 1e-7;
for(i = 0; i < 1000000000; i++)
sum += 1e-7;
printf("Result of work in thread %d(): sum = %f\n", a, sum);
  return NULL;
}

int main() {
  printf("This is the main() function starting.\n");

  /* Start thread. */
  pthread_t thread[n];
  printf("the main() function now calling pthread_create().\n");
  void* arg[n];
  int a[n];

  for(int i=0; i<n;i++){
  a[i]=i+1;
  arg[i] = &a[i];
  pthread_create(&thread[i], NULL, the_thread_func, arg[i]);
  }

  printf("This is the main() function after pthread_create()\n");

  /* Do something here? */
printf("main() starting doing some work.\n");
long int i;
double sum;
for(i = 0; i < 1000000000; i++)
sum += 1e-7;
for(i = 0; i < 1000000000; i++)
sum += 1e-7;
for(i = 0; i < 1000000000; i++)
sum += 1e-7;
printf("Result of work in main(): sum = %f\n", sum);

  /* Wait for thread to finish. */
  printf("the main() function now calling pthread_join().\n");
  for(int i=0; i<n;i++)
  pthread_join(thread[i], NULL);

  return 0;
}
