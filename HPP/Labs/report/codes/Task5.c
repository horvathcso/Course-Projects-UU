#include <stdio.h>
#include <pthread.h>

static int n=10;

void* the_thread_func(void* arg) {
  int a =*(int *)arg; 
    printf("Thread: %d\n",a);
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
    printf("main\n"); 
  
  /* Wait for thread to finish. */
  printf("the main() function now calling pthread_join().\n");
  for(int i=0; i<n;i++)
  pthread_join(thread[i], NULL);

  return 0;
}

