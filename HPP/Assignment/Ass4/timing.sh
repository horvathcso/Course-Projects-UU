#!/bin/bash

file='ellipse_N_05000.gal' 
N=5000
nstep=100
dt=1e-5

make
echo Starting simulations!
echo 
for i in {1..16}
do
echo ./galsim $N $file $nstep $dt 0 $i 
./galsim $N $file $nstep $dt 0 $i
done
echo End of simulations!
