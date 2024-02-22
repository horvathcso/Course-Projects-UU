#include <stdio.h>
int main(){
    double num1; double num2;
    char OP;
    printf("Give the calculation:\n");
 	scanf(" %lf", &num1);
    scanf(" %c", &OP);
    scanf(" %lf", &num2);

switch (OP)
{
case '+':
    printf("%lf\n", (num1+num2));
    break;

case '-':
    printf("%lf\n", (num1-num2));
    break;

case '*':
    printf("%lf\n", (num1*num2));
    break;

case '/':
    printf("%lf\n", (num1/num2));
    break;
default:
    printf("Error: Invalid operator\n");
    break;
}
}
