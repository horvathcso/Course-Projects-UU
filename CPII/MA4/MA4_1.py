import random
import matplotlib.pyplot as plt
import numpy as np
import math
from time import perf_counter as pc
import concurrent.futures as future




def pi_mc(n=100, plot=False):

    n_c=0
    for _ in range(n):
        x=random.uniform(-1,1)
        y=random.uniform(-1,1)
        if x*x+y*y <= 1:
            plt.plot(x,y,'ro')
            n_c += 1
        else: plt.plot(x,y,'bo')
    if plot == True:
        plt.title(f"The MC method with n={n} dot for pi. The value is {4*n_c/n}")
        plt.show()
    return 4*n_c/n


def sphere(n,d, anal = False):
    chord=2*(np.random.rand(n,d)-0.5)
    dis = list(map(lambda e: np.sqrt(sum(map(lambda i: i**2, e))),chord))
    n_c=len([None for i in range(n) if dis[i]<=1])
    if anal== True:
        print(f"Difference from the real value: {math.pi**(d/2)/math.gamma(d/2+1)-(2**d*(n_c/n))}")
    return (2**d*(n_c/n))

def sphere_n(n,d, anal = False):
    dis=filter(lambda e: e<=1,[sum([random.uniform(-1,1)**2 for _ in range(d)]) for _ in range(n)])
    n_c=len(list(dis))
    if anal== True:
        print(f"Difference from the real value: {math.pi**(d/2)/math.gamma(d/2+1)-(2**d*(n_c/n))}")
    return (2**d*(n_c/n))

def sp_m(n,d,anal=False):
    n_c=sum(map(func(d),[d for _ in range(n)]))
    if anal== True:
        print(f"Difference from the real value: {math.pi**(d/2)/math.gamma(d/2+1)-(2**d*(n_c/n))}")
    return (2**d*(n_c/n))

def func(d):
    r=sum([random.uniform(-1,1)**2 for _ in range(d)])
    return 0 if r>1 else 1

def sphere_para(n,d, anal = False):
    with future.ProcessPoolExecutor() as ex:
        n_c=sum(ex.map(func, [d for _ in range(n)]))
    if anal== True:
        print(f"Difference from the real value: {math.pi**(d/2)/math.gamma(d/2+1)-(2**d*(n_c/n))}")
    return (2**d*(n_c/n))



#MA 4.3 Paralel
if __name__ == "__main__":
    #Demonstration codes for the exercises by parts    
    #MA 4.1
    print(pi_mc(n=400, plot= True))

    #MA 4.2
    start=pc()
    print(sphere_n(100000, 2,anal=True))
    end=pc()
    print(f"Ellapsed time: {end-start}")

    start=pc()
    print(sphere_n(100000, 11,anal=True))
    end=pc()
    print(f"Ellapsed time: {end-start}")

    print()
    start=pc()
    print(sp_m(100000, 2,anal=True))
    end=pc()
    print(f"Ellapsed time: {end-start}")


    #MA 4.3 Multiprocessing
    print()
    start=pc()
    print(sphere_para(100000, 2,anal=True))
    end=pc()
    print(f"Ellapsed time: {end-start}")

    start=pc()
    print(sphere_para(100000, 11,anal=True))
    end=pc()
    print(f"Ellapsed time: {end-start}")
    