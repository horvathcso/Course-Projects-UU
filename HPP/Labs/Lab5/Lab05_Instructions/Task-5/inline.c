#include <stdio.h>
#include <math.h>

#define FAST 1  

#if FAST
static inline __attribute__((always_inline)) long int f2(long int a, long int b){
    return (a*b);
}
static inline __attribute__((always_inline))  long int f3(long int a, long int b, long int c){
    return (a*b*c);
}
static inline __attribute__((always_inline))  long int f4(long int a, long int b, long int c, long int d){
    return (a*b*c*d);
}

#else
long int f2(long int a, long int b){
    return (a*b);
}
 long int f3(long int a, long int b, long int c){
    return (a*b*c);
}
 long int f4(long int a, long int b, long int c, long int d){
    return (a*b*c*d);
}

#endif


int main(){
    long int j,k,l;
    long int x=5;
    for(long int i=1; i<50000000; i++){
        j=f2(i,x);
        k=f3(i,j,x);
        l=f4(x,i,j,k);
        j=f2(i,x);
        k=f3(i,j,x);
        l=f4(x,i,j,k);
        j=f2(i,x);
        k=f3(i,j,x);
        l=f4(x,i,j,k);
        j=f2(i,x);
        k=f3(i,j,x);
        l=f4(x,i,j,k);
        j=f2(i,x);
        k=f3(i,j,x);
        l=f4(x,i,j,k);
        //  j=factorial(j);
        
    }
}
