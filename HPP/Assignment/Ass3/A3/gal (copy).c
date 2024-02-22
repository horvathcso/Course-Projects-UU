#include <stdio.h>
#include <stdlib.h>
#include <math.h>
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

static double get_wall_seconds() {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  double seconds = tv.tv_sec + (double)tv.tv_usec / 1000000;
  return seconds;
}

static inline double pow3(double x){   
	return x*x*x;
	}

static inline double pow2(double x){ 
	return x*x;
	}

int main(int argc, char const *argv[]){
	if(argc!=6){
		printf("Incorrect number of arguments\n");
		printf("Supply in order: N, filename, nsteps, dt, graphics \n");
	return 0;}
	
	const int N = atoi(argv[1]);
	const char *filename=argv[2];
	const int nsteps=atoi(argv[3]);
	const double dt=atof(argv[4]); //Should be 1E-5
	//const double dt=1E-5;
	const int graphics=atoi(argv[5]);
	const double G=100.0/N, T=nsteps*dt; //Final time T
	double time;
	register double rij, denom,C;
	int i;
	int j;
	const double eps0=1E-3;

    //Initialize array for storing data	
	particle_t  particles[N];
	
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
		usleep(1000);
	}

	time = get_wall_seconds(); //start counting time

	//Time evolution 
	for(double t=0;t<=T;t+=dt){ //Evolve time
	
		for(i=0;i<N;i++){ //For setting acceleration of ith particle 
			register double ax=0.0,ay=0.0;
			for(j=0;j<N;j++){ //Interaction by jth particle, j<i
			
			if(j!=i){
			rij=sqrt(pow2((particles[i].x-particles[j].x))+ \
			pow2((particles[i].y-particles[j].y)));
			C=(-G*(particles[j].m))/(pow3((rij+eps0))); 
			ax+=C*(particles[i].x-particles[j].x);
			ay+=C*(particles[i].y-particles[j].y);}
				}
				
			particles[i].ux+=ax*dt;
			particles[i].uy+=ay*dt;}

		for(i=0;i<N;i++){
			particles[i].x+=particles[i].ux*dt;
			particles[i].y+=particles[i].uy*dt;
			}
			
		//Update plot with Gnuplot
			if(graphics==1){
				fprintf(gnuplotPipe, "plot '-' with points linetype 1 pointtype 7 pointsize 1\n");
				for(int i=0;i<N;i++){
				fprintf(gnuplotPipe, "%lf %lf\n", particles[i].x, particles[i].y);
				}
				fprintf(gnuplotPipe, "e\n");
				fprintf(gnuplotPipe, "replot\n");
				fflush(gnuplotPipe);
				usleep(1000);
			}
		
	 }
	printf("galaxy simulation took %7.3f wall seconds.\n", get_wall_seconds()-time);
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
	return 0;
}
