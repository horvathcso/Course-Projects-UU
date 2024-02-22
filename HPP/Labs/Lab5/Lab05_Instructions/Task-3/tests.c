#include <stdio.h>
#include <math.h>


int main(){

/*
    // Testing Inf and NaN
    double d = 100;
    float f = 100;

    for(int i=0; i<1025;i++){
        d = pow(10,i);
        f = pow(10,i);
        printf("i= %d: float:%f,  double:%lf\n",i,f,d);
    }
    printf("sqrt(-1): %f\n", sqrt(-1));

*/

    // Testing precision
    double one_d = 1;
    double eps_d;
    double one_eps_d;
    float one_f = 1;
    float eps_f;
    float one_eps_f;
    int bool_d = 0;
    int bool_f =0;

    for(int i=0; i<1024; i++){
        eps_d = pow(0.5,i);
        eps_f = pow(0.5,i);
        one_eps_d = 1+eps_d;
        one_eps_f = 1+eps_f;
        if (one_eps_d <= one_d && bool_d==0)
        {
            bool_d=1;
            printf("Double becomes one at eps: 0.5^%d\n",i);
        }
        if (one_eps_f <= one_f && bool_f==0)
        {
            bool_f=1;
            printf("Float becomes one at eps: 0.5^%d\n",i);
        }

    }
}