#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

int N=10;

void* the_thread_func(void* arg) {
  /* Do something here? */
  int *p=(int *) malloc(N*sizeof(int));
  for(int i=0; i<N; i++){
   p[i]=i; 
  }
  return p;
}

int main() {
  printf("This is the main() function starting.\n");

  /* Start thread. */
  pthread_t thread;
  printf("the main() function now calling pthread_create().\n");
  if(pthread_create(&thread, NULL, the_thread_func, NULL) != 0) {
    printf("ERROR: pthread_create failed.\n");
    return -1;
  }

  printf("This is the main() function after pthread_create()\n");

  /* Do something here? */
  long int sum=0;
  for(int i=0;i<100000000;i++)
    sum+=i;
  /* Wait for thread to finish. */
  printf("the main() function now calling pthread_join().\n");
  
  int * res;
  if(pthread_join(thread, (void**)(&res)) != 0) {
    printf("ERROR: pthread_join failed.\n");
    return -1;
  }
  for(int i=0; i<N; i++)    
    printf("result in array[%d]: %d\n",i,res[i]);

  free(res);
  return 0;
}
