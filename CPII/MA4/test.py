import multiprocessing
import random
import matplotlib.pyplot as plt
import numpy as np
import math
from time import perf_counter as pc
import concurrent.futures as future
from time import sleep as pause

def func(d):
    #pause(0.1)
    r=sum([random.uniform(-1,1)**2 for _ in range(d)])
    return 0 if r>1 else 1

def func_(e):
    d=e[0]
    t=e[1]
    s=0
    for _ in range(t):
        r=sum([random.uniform(-1,1)**2 for _ in range(d)])
        if r<=1:
            s+=1
    return s

def sp_m(n,d,anal=False):
    n_c=sum(map(func,[d for _ in range(n)]))
    if anal== True:
        print(f"Difference from the real value: {math.pi**(d/2)/math.gamma(d/2+1)-(2**d*(n_c/n))}")
    return (2**d*(n_c/n))

def sphere_para(n,d, anal = False):
    with future.ProcessPoolExecutor() as ex:
        n_c=sum(ex.map(func, [d for _ in range(n)]))
    if anal== True:
        print(f"Difference from the real value: {math.pi**(d/2)/math.gamma(d/2+1)-(2**d*(n_c/n))}")
    return (2**d*(n_c/n))

def sphere_tr(n,d, anal = False):
    with future.ThreadPoolExecutor() as ex:
        n_c=sum(ex.map(func, [d for _ in range(n)]))
    if anal== True:
        print(f"Difference from the real value: {math.pi**(d/2)/math.gamma(d/2+1)-(2**d*(n_c/n))}")
    return (2**d*(n_c/n))

def sphere_para_(n,d, anal = False):
    with future.ProcessPoolExecutor() as ex:
        l=[math.floor(n/6) for _ in range(5)]
        l.append(n-sum(l))
        n_c=sum(ex.map(func_, [(d,i) for i in l]))
    if anal== True:
        print(f"Difference from the real value: {math.pi**(d/2)/math.gamma(d/2+1)-(2**d*(n_c/n))}")
    return (2**d*(n_c/n))

if __name__=="__main__":
    print(multiprocessing.cpu_count())
    start=pc()
    print(sphere_para_(1000000, 2,anal=True))
    end=pc()
    print(f"Ellapsed time: {end-start}")

    print()
    start=pc()
    print(sp_m(1000000, 2,anal=True))
    end=pc()
    print(f"Ellapsed time: {end-start}")