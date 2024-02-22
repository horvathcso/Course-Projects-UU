#include <stdlib.h>
#include "sort_funcs.h"

#define no_BUBBLE 0

static int NN=20;

void bubble_sort(int* list, int N) {
  int i, j;
  for(i = 0; i < N-1; i++)
    for(j = 1+i; j < N; j++) {
      if(list[i] > list[j]) {
	// Swap
	int tmp = list[i];
	list[i] = list[j];
	list[j] = tmp;
      }
    }
}

#if no_BUBBLE
void merge_sort(int* list_to_sort, int N) {
  if(N == 1) {
    // Only one element, no sorting needed. Just return directly in this case.
    return;
  }
  int n1 = N / 2;
  int n2 = N - n1;
  // Allocate new lists
  
  // original
  //int* list1 = (int*)malloc(n1*sizeof(int));
  //int* list2 = (int*)malloc(n2*sizeof(int));
  
  // reducing malloc calls
  // int * list12= (int*) malloc((n1+n2)*sizeof(int));
  int list12 [n1+n2];
  int i;
  for(i = 0; i < n1; i++)
    //list1[i] = list_to_sort[i];
    list12[i] = list_to_sort[i];
  for(i = 0; i < n2; i++)
    list12[i+n1] = list_to_sort[n1+i];
  // Sort list1 and list2
  merge_sort(list12, n1);
  merge_sort(&list12[n1], n2);
  // Merge!
  int i1 = 0;
  int i2 = 0;
  i = 0;
  while(i1 < n1 && i2 < n2) {
    if(list12[i1] < list12[i2+n1]) {
      list_to_sort[i] = list12[i1];
      i1++;
    }
    else {
      list_to_sort[i] = list12[i2+n1];
      i2++;
    }
    i++;
  }
  while(i1 < n1)
    list_to_sort[i++] = list12[i1++];
  while(i2 < n2)
    list_to_sort[i++] = list12[n1+i2++];
  // adding memory leak 
  //free(list1);
  //free(list2);

  //opt memory useage
  // free(list12);
}

#else

void merge_sort(int* list_to_sort, int N) {
  //if(N == 1) {
    // Only one element, no sorting needed. Just return directly in this case.
    //return;
  //}
  if(N<=NN){
    bubble_sort(list_to_sort, N);
    return;
  }
  int n1 = N / 2;
  int n2 = N - n1;
  // Allocate new lists
  
  // original
  //int* list1 = (int*)malloc(n1*sizeof(int));
  //int* list2 = (int*)malloc(n2*sizeof(int));
  
  // reducing malloc calls
  // int * list12= (int*) malloc((n1+n2)*sizeof(int));
  int list12 [n1+n2];
  int i;
  for(i = 0; i < n1; i++)
    //list1[i] = list_to_sort[i];
    list12[i] = list_to_sort[i];
  for(i = 0; i < n2; i++)
    list12[i+n1] = list_to_sort[n1+i];
  // Sort list1 and list2
  merge_sort(list12, n1);
  merge_sort(&list12[n1], n2);
  // Merge!
  int i1 = 0;
  int i2 = 0;
  i = 0;
  while(i1 < n1 && i2 < n2) {
    if(list12[i1] < list12[i2+n1]) {
      list_to_sort[i] = list12[i1];
      i1++;
    }
    else {
      list_to_sort[i] = list12[i2+n1];
      i2++;
    }
    i++;
  }
  while(i1 < n1)
    list_to_sort[i++] = list12[i1++];
  while(i2 < n2)
    list_to_sort[i++] = list12[n1+i2++];
  // adding memory leak 
  //free(list1);
  //free(list2);

  //opt memory useage
  // free(list12);
}
#endif