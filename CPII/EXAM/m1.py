"""
File m1.py for exam 2022-10-28

Name: Csongor Horváth

"""

from ast import Pass
import random
import time
import math


#######       A1: depth
def depth(lst):
    if not isinstance(lst,list):
        return 0
    else:
        if len(lst) == 0:
            return 1
        else:
            return max([depth(e) for e in lst])+1


#######       A2: is_sorted

def is_sorted(lst):
    if len(lst)<=1:
        return True
    try:
        if max(lst[1:])>=lst[0]:
            return is_sorted(lst[1:])
        else:
            return False
    except:
        return False
         


# B1: Time complexity for foo(n)

def foo(n, m=9):
    c = [x for x in range(1, m)]
    def fie(n, c):
        if n == 0:
            return 1
        elif n < 0 or len(c) == 0:
            return 0
        else:
            return fie(n, c[1:]) + fie(n-c[0], c)
    return fie(n, c)

def _foo(n, l, m=9):
    c = [x for x in range(1, m)]
    c=c[l:]
    def fie(n, c):
        if n == 0:
            return 1
        elif n < 0 or len(c) == 0:
            return 0
        else:
            return fie(n, c[1:]) + fie(n-c[0], c)
    return fie(n, c)


def main():
    print('\n\nA1: depth\n')
    print(f'Result      Argument')
    lists = (1, [], [[]], [1, 2, 3], [[1], 2, [[3]]],
             [[1, (1, [2])], [[[[2]]]], 3], ['[[', [']']])
    for lst in lists:
        print(f'{depth(lst):3d} \t     {str(lst):35}')
    
    print('\n\nA2: is_sorted\n')
    print('Result       Argument')
    args = ([], [1, 2], [1, 3, 2], [2, 3, 5, 4], ['a', 'ab', 'c'],
            [1, 'a'], [0, False], [[1, 2, 2], [1, 2, 3]])
    for a in args:
        print(f' {is_sorted(a)} \t      {str(a):35}')

    print('\nB1: Timing foo')

    print(f'Estimation for foo(500): ' +
          f'??? years')
    data=[[] for _ in range(8)]
    for n in range(1,71):
        for l in range(8):
            tstart = time.perf_counter()
            r=_foo(n,l)
            tend = time.perf_counter()
            data[l].append(tend-tstart)
    
    tstart = time.perf_counter()
    foo(1)
    tend = time.perf_counter()
    epsilon=tend-tstart # mesured time to run through the if statments in on call so the extra time per calls
    
    for n in range(71,501):
        data[7].append(data[7][-8])
        for l in range(6,-1,-1):
            data[l].append(data[l+1][-1]+data[l][-(l+1)]+epsilon)
    print(f"Estimated runtime: {data[0][499]}")
        



if __name__ == "__main__":
    main()

'''
Answer to B1
Theory
=================================================
In the analysis use the name f(n) for the function
So in case n-> n+1 the call of the function will be basicly a call of f(n) and a call for n+1 and a shorter list.
If we assume with the sorther list since there the smallest steps is 2 instead of 1 it is very similar to the runtime of the funtion with the shorter list and n.

Note here the m is m-1 compared what is in function

Actually to make a precise estimate we could calculate runtime form the function with n=1...k and the list beeing [l,...,m] for l=1,2,...,m
Here use modified function f(n,l), where the used list is [l,...,m]
Than we could use the runtime estimate f(n,l)=f(n-l,l) + f(n, l+1) if l+1<=m and n-l>0 else f(n,l)=f(n-l,l) ot f(n,l)= 1 + f(n, l+1)

If data is known for some n and all smaller n and all l=1,2,...,m than we can use dinamic programing to calculate all data for bigger n and all m.
Because we get n+1 and all m with the following:
    f(n+1,m)=f(n+1-m, m)
    now for i=1,...m-1: f(n+1,m-i)=f(n+1-m+i,m-i) + f(n+1, m-i+1)
So with this we can calculate f(n,l) for all n and l=1,...,m

Now lets implement this

Estimated result
================================================
Estimated runtime: 1885560.6444006409 - 22 day

Code from the timing of the function
=================================================

    data=[[] for _ in range(8)]
    for n in range(1,71):
        for l in range(8):
            tstart = time.perf_counter()
            r=_foo(n,l)
            tend = time.perf_counter()
            data[l].append(tend-tstart)
    
    tstart = time.perf_counter()
    foo(1)
    tend = time.perf_counter()
    epsilon=tend-tstart # mesured time to run through the if statments in on call so the extra time per calls
    
    for n in range(71,501):
        data[7].append(data[7][-8])
        for l in range(6,-1,-1):
            data[l].append(data[l+1][-1]+data[l][-(l+1)]+epsilon)
    print(f"Estimated runtime: {data[0][499]}")


    #With _foo

    def _foo(n, l, m=9):
        c = [x for x in range(1, m)]
        c=c[l:]
        def fie(n, c):
            if n == 0:
                return 1
            elif n < 0 or len(c) == 0:
                return 0
            else:
                return fie(n, c[1:]) + fie(n-c[0], c)
        return fie(n, c)

'''
