#include <stdio.h>
#include <pthread.h>
#include<unistd.h>

static int s= 1;
static int n=2;
static int l= 4;

void* the_thread_func(void* arg) {
  int a =*(int *)arg; 
  for(int i=0; i<2 ;i++){
    sleep(s);
    printf("Thread: %d\n",a);}
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
  for (int i = 0; i < l; i++)
  {printf("main\n"); 
  sleep(s);
  }
  
  /* Wait for thread to finish. */
  printf("the main() function now calling pthread_join().\n");
  for(int i=0; i<n;i++)
  pthread_join(thread[i], NULL);

  return 0;
}
