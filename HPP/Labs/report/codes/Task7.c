#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

static int n=2;

void* the_thread_func_sub(void* arg) {
    int * data= (int *)arg;
    int a =*data;
    data++;
    int b =*data;
    printf("Calling subthread started from thread %d with subnumber %d\n",b,a);

    return NULL;
}

void* the_thread_func_main(void* arg) {
  int a =*(int *)arg; 
  printf("Thread %d started from main start running.\n",a);
  pthread_t threadi[n];
  int argi[2*n];
  int ai[n];

  for(int i=0; i<n;i++){
  argi[2*i] = i+1;
  argi[2*i+1] = a;
  pthread_create(&threadi[i], NULL, the_thread_func_sub, &argi[2*i]);
  }

printf("Thread %d finished creating subprocess.\n",a);
  for(int i=0; i<n; i++){
    pthread_join(threadi[i],NULL);
  }
printf("Thread %d finished running.\n",a);
  return NULL;
}

int main(){

pthread_t thread[n];
  printf("the main() function now calling pthread_create().\n");
  void * arg[n];
  int a[n];

  for(int i=0; i<n;i++){
  a[i]=i+1;
  arg[i] = &a[i];
  pthread_create(&thread[i], NULL, the_thread_func_main, arg[i]);
  }

  printf("This is the main() function after pthread_create()\n");
  printf("the main() function now calling pthread_join().\n");
  for(int i=0; i<n;i++)
  pthread_join(thread[i], NULL);

  return 0;
}
