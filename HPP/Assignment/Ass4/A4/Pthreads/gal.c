#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/time.h>

typedef struct particle{
	double x;
	double y;
	double m;
	double ux;
	double uy;
	double br;
}particle_t;


typedef struct thread_data{
	int LB;
	int UB;
}data_t;


//Global Variables	
int N;
double G;
double eps0;
particle_t* particles;
double dt;
int nsteps;

static inline double pow3(double x){   
	return x*x*x;
	}

static inline double pow2(double x){ 
	return x*x;
	}

//Pthread function
void* thread_func(void *arg){
data_t* data=(data_t*)arg;

int LB=data->LB;
int UB=data->UB;
for(int i=LB;i<=UB;i++){ //For setting acceleration of ith particle 
	
	double ax=0,ay=0;
	for(int j=0;j<N;j++){ //Interaction by jth particle, j<i
			double rij=sqrt(pow2((particles[i].x-particles[j].x))+ \
			pow2((particles[i].y-particles[j].y)));
			double C=(-G*(particles[j].m))/(pow3((rij+eps0))); 
			ax+=C*(particles[i].x-particles[j].x);
			ay+=C*(particles[i].y-particles[j].y);

	}
	particles[i].ux+=ax*dt;
	particles[i].uy+=ay*dt;}
	

}

void* thread_pos(void *arg){
data_t* data=(data_t*)arg;

int LB=data->LB;
int UB=data->UB;
	for(int i=LB;i<=UB;i++){ //For setting acceleration of ith particle 
		particles[i].x+=particles[i].ux*dt;
		particles[i].y+=particles[i].uy*dt;
	}
}


static double get_wall_seconds() {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  double seconds = tv.tv_sec + (double)tv.tv_usec / 1000000;
  return seconds;
}

int main(int argc, char const *argv[]){
	if(argc!=7){
		printf("Incorrect number of arguments\n");
		printf("Supply in order: N, filename, nsteps, dt, graphics, N_threads \n");
	return 0;}
	
	N = atoi(argv[1]);
	const char *filename=argv[2];
	nsteps=atoi(argv[3]);
	dt=atof(argv[4]); //Should be 1E-5
	//const double dt=1E-5;
	const int graphics=atoi(argv[5]);
	int N_threads=atoi(argv[6]);
	G=100.0/N;
	double T=nsteps*dt; //Final time T
	double time;
	eps0=1E-3;

    //Initialize array & threads	
	particles = calloc(sizeof(particle_t)*N,sizeof(particle_t));	//particles = malloc(sizeof(particle_t) *N);
	pthread_t thread[N_threads];
	data_t data[N_threads];
	
	//Reading inputs
	FILE *file;
	file=fopen(filename,"rb");
	fread(particles,N*6*sizeof(double),1,file)!=0;
	fclose(file);
	
	//Initialize plot with Gnuplot
	FILE * gnuplotPipe = popen("gnuplot -persistent","w"); //Create pipe
	if(graphics==1){
		fprintf(gnuplotPipe, "set terminal wxt\n");
		fprintf(gnuplotPipe, "set xrange [0:1]\n");
		fprintf(gnuplotPipe, "set yrange [0:1]\n");
		fprintf(gnuplotPipe, "plot '-' with points linetype 1 pointtype 7 pointsize 1\n");

		for(int i=0;i<N;i++){
			fprintf(gnuplotPipe, "%lf %lf\n", particles[i].x, particles[i].y);
		}
		fprintf(gnuplotPipe, "e\n");
		fflush(gnuplotPipe);
		usleep(10000);
	}

	time = get_wall_seconds(); //start counting time

	//Set lower- and upper bounds of thread args.
	 for( int i = 0; i < N_threads; i++ )
    {
        data[i].LB=(i*N/N_threads+1)*(i!=0);
		data[i].UB=((i+1)* N/N_threads) * (i!=0)+N/N_threads*(i==0);	
    }

	//Time evolution 
	
	for(double t=0;t<=T;t+=dt){ //Evolve time	
			for (int i=0;i<N_threads;i++){
			pthread_create(&thread[i], NULL, thread_func,(void*)&data[i]);
			}
			
			for (int i=0;i<N_threads;++i){
			pthread_join(thread[i], NULL);
			}

			for (int i=0;i<N_threads;i++){
			pthread_create(&thread[i], NULL, thread_pos,(void*)&data[i]);
			}
			
			for (int i=0;i<N_threads;++i){
			pthread_join(thread[i], NULL);
			}
				
	
		//Update plot with Gnuplot
			if(graphics==1){
				fprintf(gnuplotPipe, "plot '-' with points linetype 1 pointtype 7 pointsize 1\n");
				for(int i=0;i<N;i++){
				fprintf(gnuplotPipe, "%lf %lf\n", particles[i].x, particles[i].y);}
				fprintf(gnuplotPipe, "e\n");
				fflush(gnuplotPipe);
				usleep(10000);
			}
	}
	printf("%d %7.3f seconds.\n",N_threads, get_wall_seconds()-time);
	pclose(gnuplotPipe);
	//Save into a file
	FILE* fp = fopen("result.gal","w"); //should be result.gal 
	if(fp == NULL)
    {
        printf("The file was not created.\n");
        exit(EXIT_FAILURE);
    }
	fwrite(particles,(N*6*sizeof(double)),1,fp);
	
	fclose(fp);
}