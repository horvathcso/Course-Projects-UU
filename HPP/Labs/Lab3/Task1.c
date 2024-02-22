#include <stdio.h>

const int M=5;
const int N=5;

void print_matrix(int m[N][M]){
    for(int i=0; i<N; i++){
        printf("|");
        for(int j=0; j<M; j++){
            if(j==M-1)
            {
            if(m[i][j]<0)
            printf("%d", m[i][j]);
            else
            printf(" %d", m[i][j]);
            }
            else
            {
            if(m[i][j]<0)
            printf("%d ", m[i][j]);
            else
            printf(" %d ", m[i][j]);
            }
        }
        printf("|\n");
    }
}

int main(){
    int matrix[N][M];
    for(int i=0; i<N; i++){
        for(int j=0; j<M; j++){
            if(i==j)
                matrix[i][j]=0;
            else
            if(i<j)
                matrix[i][j]=1;
            else    
                matrix[i][j]=-1;
        }
    }
    print_matrix(matrix);
}