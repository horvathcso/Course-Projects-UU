#include <stdio.h>
#include <pthread.h>

void* the_thread_func(void* arg) {
  double * data=(double *)arg;
  for(int i=0; i<3;i++)
    printf("Data from thread: %lf\n", data[i]);
  return NULL;
}

int main() {
  printf("This is the main() function starting.\n");

  double data_for_thread[3];
  data_for_thread[0] = 5.7;
  data_for_thread[1] = 9.2;
  data_for_thread[2] = 1.6;

  double data_for_thread_B[3];
  data_for_thread_B[0] = -1;
  data_for_thread_B[1] = -3.1415;
  data_for_thread_B[2] = -0.6;

  /* Start thread. */
  pthread_t thread_1;
  pthread_t thread_2;
  printf("the main() function now calling pthread_create().\n");
  pthread_create(&thread_1, NULL, the_thread_func, data_for_thread);
  pthread_create(&thread_2, NULL, the_thread_func, data_for_thread_B);

  printf("This is the main() function after pthread_create()\n");

  /* Do something here? */

  /* Wait for thread to finish. */
  printf("the main() function now calling pthread_join().\n");
  pthread_join(thread_1, NULL);
  pthread_join(thread_2, NULL);

  return 0;
}

