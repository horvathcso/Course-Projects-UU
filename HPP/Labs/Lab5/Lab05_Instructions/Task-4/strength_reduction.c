#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
   int i;
   int a = 1, b = 2, c = 3, d = 1;
   float x = 0.1, y = 0.5, z = 0.33;
   printf("%d %d %d %d, %f %f %f\n", a, b, c, d, x, y, z);

//Original
/*
for (i=0; i<50000000; i++)
   {
      c = d*2;
      b = c*15;
      a = b/16;
      d = b/a;

      z = 0.33;
      y = 2*z;
      x = y / 1.33;
      z = x / 1.33;
   }*/

//My version
const float per133=1/1.33;
for (i=0; i<50000000; i++)
   {b=30;
      c = d <<1 ;
      b = c+c+c+c+c+c+c+c+c+c+c+c+c+c+c;
      a = b >> 4;
      d = b/a;

      // z = 0.33;
      
   }
   y = 0.66;
   x = 0.66 *per133;
   z = 0.66 *per133 *per133;
   printf("%d %d %d %d, %f %f %f\n", a, b, c, d, x, y, z);
 
   return 0;
}
