#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>


#define save 0 // for saving resulting u value
#define root 0 // for I/O processes

#define print_time 0
#define print_norm 1

#define is_precise 0 // for iteration untill precision
#define eps 0.001
#define MAX_ITER 10000

int write_output(char *file_name, const double *matrix, int n) {
	/*
        A function to output the gathered global u value for plotting purposes
        This function can use to plot any 2d array with a 0 valued border
    */
    FILE *file;
	if (NULL == (file = fopen(file_name, "w"))) {
		perror("Couldn't open output file");
		return -1;
	}
    //first row with 0s
        if (0 > fprintf(file, "%.6f ", 0.0)) {perror("Couldn't write to output file");}
        for (int j = 0; j < n; j++) {
    		if (0 > fprintf(file, "%.6f ", 0.0)) {perror("Couldn't write to output file");}
        }
        if (0 > fprintf(file, "%.6f\n ", 0.0)) {perror("Couldn't write to output file");}
    //matrix body
	for (int i = 0; i < n; i++) {
        if (0 > fprintf(file, "%.6f ", 0.0)) {perror("Couldn't write to output file");}
        for (int j = 0; j < n; j++) {
    		if (0 > fprintf(file, "%.6f ", matrix[i*n+j])) {perror("Couldn't write to output file");}
        }
        if (0 > fprintf(file, "%.6f\n ", 0.0)) {perror("Couldn't write to output file");}
	}
    //last row with 0s
        if (0 > fprintf(file, "%.6f ", 0.0)) {perror("Couldn't write to output file");}
        for (int j = 0; j < n; j++) {
    		if (0 > fprintf(file, "%.6f ", 0.0)) {perror("Couldn't write to output file");}
        }
        if (0 > fprintf(file, "%.6f ", 0.0)) {perror("Couldn't write to output file");}

	if (0 != fclose(file)) {
		perror("Warning: couldn't close output file");
	}
	return 0;
}

void print_local(double* l,  double* d_left, double* d_right, double* d_up, double* d_down, int h, int v, int rank){
    /*
        For debuging purpose a print function for local data.
        To avoid collision of different processes it uses sleep(rank)
    */
    sleep(rank);
    printf("         ");
        for (int j = 0; j < h; j++){
            printf("%lf ",d_up[j]);
        }
    printf("\n");
    for (int i = 0; i < v; i++){   
        printf("%lf ",d_left[i]);
        for (int j = 0; j < h; j++){
            printf("%lf ",l[i*h+j]);
        }
        printf("%lf ",d_right[i]);
        printf("\n");
    }
    printf("         ");
        for (int j = 0; j < h; j++){
            printf("%lf ",d_down[j]);
        }
    printf("\n\n");
}

void fill_u(double* glob_u,double* loc_u, int x, int y, int h, int v,int n){
    /*
        A helperfunction for gather_u
        This function fills up the global u from local u data using the positioning variables
    */
    for (int i = 0; i < v; i++) {
        for (int j = 0; j < h; j++) {
            glob_u[(x+i)*n+y+j] = loc_u[i*h+j];
        }
    }
}

void gather_u(double** glob_u, double* u, int n, int hsize, int vsize, int x_id, int y_id, int rank, int size){
    /*
        Gathreing the u values in the root process using MPI communication
    */
    
    if(rank==root) {
        *glob_u=(double*)malloc(n*n*sizeof(double));
        double* loc_u;
        for (int i = 0; i < size; i++) {
            if(i!=root){
                // communication
                int data[4];
                MPI_Recv(data, 4, MPI_INT, i, i, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
                int h = data[0]; int v = data[1]; int x = data[2]; int y = data[3];
                loc_u=(double*)malloc(h*v*sizeof(double));
                MPI_Recv(loc_u, h*v, MPI_DOUBLE, i, i, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

                // fill in the local u values in the global u
                fill_u(*glob_u, loc_u, x-1, y-1, h, v, n);
                free(loc_u);
            }
            else{
                // fill in the root process own data
                fill_u(*glob_u, u, x_id-1, y_id-1, hsize, vsize, n);
            }
        }
    }
    else{
        int data[4]={hsize,vsize,x_id,y_id};
        MPI_Send(data, 4, MPI_INT, root, rank, MPI_COMM_WORLD);
        MPI_Send(u, hsize*vsize, MPI_DOUBLE, root, rank, MPI_COMM_WORLD);
    }
    
}

double vector_update1(double * __restrict u, double * __restrict d, double * __restrict g, double * __restrict q, double tau, int size) {
    /*
        Implementation for line 6,7,8 vector update and local dot product 
    */
    double dot=0;
    for(int i=0; i<size; i++) {
        u[i] += tau*d[i];
        g[i] += tau*q[i];
        dot += g[i]*g[i];
    }
    return dot;
}

void vector_update2(double * __restrict d, double * __restrict g, double beta, int size) {
    /*
        Implementation for line 10 vector update
    */
    for(int i=0; i<size; i++) {
        d[i] = beta * d[i] - g[i];
    }
}

void get_vhxy_size(int* vsize, int* hsize, int*x, int*y, int n, int size, int ver, int hor, int vgrid, int hgrid){
    /*
        set up the process coorinat variables based on the 2D Cartesian grid
            hsize, vsize - horizontal and vertical size of the locally calculated variable
            x,y the vertical and horizontal coordinates of the top left coorner of the local data in the global grid
    */
    int vdiv = n/vgrid;
    int vrem = n%vgrid;

    int hdiv = n/hgrid;
    int hrem = n%hgrid;
    if(ver<vrem)
        (*vsize)=vdiv+1;
    else
        (*vsize)=vdiv;
    if(hor<hrem)
        (*hsize)=hdiv+1;
    else
        (*hsize)=hdiv;
    
    *x=1;
    *y=1;
    for (int i = 0; i < ver; i++){
        if(i<vrem)
            *x+=vdiv+1;
        else
            *x+=vdiv; 
    }
    for (int i = 0; i < hor; i++){
        if(i<hrem)
            *y+=hdiv+1;
        else
            *y+=hdiv; 
    }  
}

void set_up_gd(double* g,double* d,int hsize,int  vsize,int x_id,int y_id,int n){
    /*
        Based in the process position variables set up the local starting values defined by a given function
    */
    double bij; double h = 1/(double)(n+1); 
    double xi, yi;
    for (int i = 0; i < vsize; i++){
        for (int j = 0; j < hsize; j++){   
            xi=(i+x_id)/(double)(n+1);
            yi=(j+y_id)/(double)(n+1);
            bij = 2*h*h*(xi*(1-xi)+yi*(1-yi));
            g[i*hsize+j]=-bij;
            d[i*hsize+j]=bij;
        }
    }
}   

void border_sync(int hsize, int  vsize, double* d, double* d_left, double* d_right, double* d_up, double* d_down, int left, int right, int up, int down, MPI_Comm* comm2D, MPI_Datatype* col_type){
    /*
        Simple implementation of the border data exchange with the neighbours
            Note: The Cartesian grid is non periodic, so at the border the send/recv are ignored
    */
    // rows | top - bottom
    MPI_Sendrecv(d, hsize, MPI_DOUBLE, up, 1, d_up, hsize, MPI_DOUBLE, up, 1, *comm2D, MPI_STATUS_IGNORE);
    MPI_Sendrecv(&(d[hsize*(vsize-1)]), hsize, MPI_DOUBLE, down, 1, d_down, hsize, MPI_DOUBLE, down, 1, *comm2D, MPI_STATUS_IGNORE);

    //cols | left - right
    MPI_Sendrecv(d, 1, *col_type, left, 1, d_left, vsize, MPI_DOUBLE, left, 1, *comm2D, MPI_STATUS_IGNORE);
    MPI_Sendrecv(&(d[hsize-1]), 1, *col_type, right, 1, d_right, vsize, MPI_DOUBLE, right, 1, *comm2D, MPI_STATUS_IGNORE);
}

void inner_stencil(double* stencil,double* d,int hsize,int vsize){
    /*
        Stencil calculation except the border
    */
    for (int i = 1; i < vsize-1; i++){
        for (int j = 1; j < hsize-1; j++){
            stencil[i*hsize+j] = 4*d[i*hsize+j] - d[(i-1)*hsize+j] - d[(i+1)*hsize+j] - d[i*hsize+(j-1)] - d[i*hsize+(j+1)];
        }
    }
}

void outer_stencil(double* stencil, double* d, double* d_left, double* d_right, double* d_up, double* d_down, int hsize, int vsize){
    /*
        Stencil calculation at the border
    */
    // corner
    stencil[0]=4*d[0]-d_up[0]-d_left[0]-d[1]-d[hsize];
    stencil[hsize-1]=4*d[hsize-1]-d_up[hsize-1]-d_right[0]-d[hsize-2]-d[2*hsize-1];
    stencil[(vsize-1)*hsize]=4*d[(vsize-1)*hsize]-d_down[0]-d_left[vsize-1]-d[(vsize-1)*hsize+1]-d[(vsize-2)*hsize];
    stencil[vsize*hsize-1]=4*d[vsize*hsize-1]-d_down[hsize-1]-d_right[vsize-1]-d[vsize*hsize-2]-d[(vsize-1)*hsize-1];
    
    // border | left -right
    for (int i = 1; i < vsize-1; i++){
        stencil[i*hsize] = 4*d[i*hsize] - d[(i-1)*hsize] - d[(i+1)*hsize] - d_left[i] - d[i*hsize+(+1)];
        stencil[i*hsize+hsize-1] = 4*d[i*hsize+hsize-1] - d[(i-1)*hsize+hsize-1] - d[(i+1)*hsize+hsize-1] - d[i*hsize+-1+hsize-1] - d_right[i];
    }
    // border | top - bottom
    for (int j = 1; j < hsize-1; j++){
        stencil[j] = 4*d[j] - d_up[j] - d[hsize+j] - d[j-1] - d[j+1];
        stencil[(vsize-1)*hsize+j] = 4*d[(vsize-1)*hsize+j] - d[(vsize-2)*hsize+j] - d_down[j] - d[(vsize-1)*hsize+(j-1)] - d[(vsize-1)*hsize+(j+1)];
    }
}


int main(int argc, char **argv) {
	if (2 != argc) {
		printf("Usage: cg n\n Here n denotes the number of nodes on one side\n");
		return 1;
	}
    // problem variable
	int n = atoi(argv[1]);

    //Communication variables
    int reorder; int ndims; int periods[2]; int coord[2]; int dims[2];
    MPI_Comm comm2D;
    MPI_Datatype col_type;
    int up, down, left, right;
    int rank, size;


    //local variables
                                // note x_id is vertical and y_id is horizontal
    int vsize, hsize, loc_size, x_id, y_id;                                       // local rectangle size and position
    double* g; double* d; double* u; double* q; double* glob_u;                   // vectors
    double* d_left; double* d_right; double* d_up; double* d_down;                // d vector local border
    double q0,q1,loc_q1, beta, dTq, tau, loc_dTq;                                 // scalar values
    double s_time, r_time, time;

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // Createing 2D structure
    periods[0]=0; periods[1]=0;
    dims[0]=0; dims[1]=0;
    MPI_Dims_create(size, 2, dims);
    reorder=1, ndims=2;
    MPI_Cart_create(MPI_COMM_WORLD,ndims,dims,periods,reorder,&comm2D);
    MPI_Cart_shift(comm2D,1,1,&left,&right);
    MPI_Cart_shift(comm2D,0,1,&up,&down);

    // Defining indexes of the local variables based on rank
    MPI_Cart_coords(comm2D, rank, 2, coord);
    get_vhxy_size(&vsize, &hsize, &x_id, &y_id, n, size ,coord[0], coord[1], dims[0], dims[1]);

    //allocating local variables
    loc_size=hsize*vsize;
    g = (double*)malloc(loc_size*sizeof(double));
    d = (double*)malloc(loc_size*sizeof(double));
    u = (double*)calloc(loc_size,sizeof(double));
    q = (double*)malloc(loc_size*sizeof(double));
    d_left = (double*)calloc(vsize,sizeof(double));
    d_right = (double*)calloc(vsize,sizeof(double));
    d_up = (double*)calloc(hsize,sizeof(double));
    d_down = (double*)calloc(hsize,sizeof(double));

    // set up local part of vectors starting value
    set_up_gd(g,d,hsize, vsize, x_id, y_id, n);

    // set up MPI type for column
    MPI_Type_vector(vsize, 1, hsize, MPI_DOUBLE, &col_type);
    MPI_Type_commit(&col_type);

// Start timer - the begining of the algorithm
    s_time= MPI_Wtime();
    
    // q0
    loc_q1=0;
    for (int i = 0; i < loc_size; i++)
            loc_q1+=d[i]*d[i]; 
    MPI_Allreduce(&loc_q1, &q0, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);


    
#if is_precise
    // line 3/1
    for (int i = 0; i<MAX_ITER; i++) {
#else
    // for 200 iter - instead of line 3
    for (int i = 0; i < 200; i++) {       
#endif  
        //sync boundaries -line 4/1
        border_sync(hsize, vsize, d, d_left, d_right, d_up, d_down, left, right, up, down, &comm2D, &col_type);

        // 2D stencil application - line 4/2
            // inner stencil
            inner_stencil(q, d, hsize, vsize);
            //outer stencil
            outer_stencil(q, d, d_left, d_right, d_up, d_down, hsize, vsize);

        //dq dot product 
            //line 5/1
        loc_dTq=0;
        for (int i = 0; i < loc_size; i++){
            loc_dTq+=d[i]*q[i];
        }
        //dot product sharing qTq
            //line 5/2
        MPI_Allreduce(&loc_dTq, &dTq, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
        tau=q0/dTq;

        //u, g update + gTg dot product
            // line 6,7,8/1
        loc_q1=vector_update1(u, d, g, q, tau, loc_size);
        
        //dot product sharing q1
            //line 8/2
        MPI_Allreduce(&loc_q1, &q1, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);

        //line 9
        beta=q1/q0;

        // d update
            //line 10
        vector_update2(d, g, beta, loc_size);

        //line 11
        q0=q1;

    #if is_precise
        //line 3/2
        if(sqrt(q0)<eps){
            break;
        }
    #endif
    }


    // ||g||^2
        loc_q1=0;
        for (int i = 0; i < loc_size; i++)
                loc_q1+=g[i]*g[i]; 
    MPI_Allreduce(&loc_q1, &q0, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);

// Stop timer - end of the given task    
r_time = MPI_Wtime();

    MPI_Reduce(&r_time, &time, 1, MPI_DOUBLE, MPI_MAX, root, MPI_COMM_WORLD);

    // printing data from root
    if(rank==root){
        #if print_norm
        printf("%.10f\n", sqrt(q0));
        #endif
        #if print_time
        printf("%lf\n", time);
        #endif
    }

#if save
    //gatharing and saving of the resulting vector
     gather_u(&glob_u, u, n, hsize, vsize, x_id, y_id, rank, size);
     if(rank==root){
        char out[80];
        sprintf(out, "out_%d.txt", n);
        write_output(out,glob_u,n);
        free(glob_u);
     }
#endif

        
    free(d);
    free(u);
    free(g);
    free(q);
    free(d_left);free(d_right);free(d_up);free(d_down);
    MPI_Comm_free(&comm2D);
    MPI_Finalize();
	return 0;
}
