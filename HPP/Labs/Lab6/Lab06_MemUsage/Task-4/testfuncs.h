
void transform_std (float * dest, 
		    const float * src, 
		    const float * params, 
		    int n,
		    int np);

void transform_opt (float * __restrict dest, 
		    const float * __restrict src, 
		    const float * __restrict params, 
		    int n,
		    int np);

