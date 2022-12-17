"""
Solutions to module 1
Student: Csongor Horváth 
Mail: sifuto2013@gmail.com
Reviewed by:Nandini
Reviewed date: 2022.09.02.
"""

import random
import time


def power(x, n):         # Optional
    if n<0:
        return 1./power(x,-n)
    elif n == 0:
        return 0
    elif n == 1:
        return x
    else:
        return x*power(x,n-1)


def multiply(m, n):      # Compulsory
    ### It should be modified if n,m could be  negative integers ###
    if m == 0 or n == 0:
        return 0
    if n == 1:             
        return m
    elif m >= n:
        return m + multiply(m,n-1)
    else:
        return multiply(n,m)


def divide(t, n):        # Optional
    pass


def harmonic(n):         # Compulsory
    if n == 1:
        return 1
    else:
        return 1./n+harmonic(n-1)


def digit_sum(x):        # Optional
    pass


def get_binary(x):       # Optional
    pass


def reverse(s):          # Optional
    pass


def largest(a):          # Compulsory
    if len(a)==1:
        return a[0]
    else:
        l1=largest(a[:(len(a)//2)])
        l2=largest(a[(len(a)//2):])
        if l1<l2:
            return l2
        else:
            return l1


def count(x, s):         # Compulsory
    '''
    if type(x) == list:
        
        if len(s) == 0:
            return 0

        elif len(s) == 1:
            if type(s[0]) == list:
                return count(x,s[0]) + int(s[0] == x)   
            else:
                return 0
        elif type(s[-1]) == list:
            return count(x,s[:-1]) + count(x,s[-1]) + int(s[-1] == x)
        else:
            return count(x,s[:-1]) 
        
    else:
    '''
    if len(s) == 0:
        return 0
        '''
    elif len(s) == 1:
        if type(s[0]) == list:
            return count(x,s[0])  
        else:
            return int(s[0] == x) 
        ''' 
    elif type(s[-1]) == list:
        return count(x,s[:-1]) + count(x,s[-1]) + int(s[-1] == x)
    else:
        return count(x,s[:-1]) + int(s[-1] == x)


def zippa(l1, l2):       # Compulsory
    if type(l1) != list or type(l2)!= list:
        raise TypeError()
    if len(l1) == 0:
        return l2
    if len(l2) == 0:
        return l1
    if len(l1) > len(l2):
        l1=l1.copy()
        l1.insert(len(l2),l2[-1])
        return zippa(l1,l2[:-1])
    else:
        l2=l2.copy() 
        l2.insert(len(l1)-1,l1[-1])
        return zippa(l1[:-1],l2)


def bricklek(f, t, h, n): # Compulsory
    if n==0:
        return []
    else:
        lst = bricklek(f, h, t, n-1)
        lst.append(f+"->"+t)
        lst.extend(bricklek(h,t,f,n-1))
        return lst


def main():
    """ Demonstates my implementations """
    # Write your demonstration code here
 
    #ex 17
    for i in range(1,40):
        tstart = time.perf_counter()
        fib(i)
        tstop = time.perf_counter()
        print(f"If the runtime O(1.7^n), than the c constant would be for case size {i} : {(tstop-tstart)/(1.7**i):.10f} seconds")

    print('Bye!')

def fib ( n ) : # the given fibonacci algorithm
    if n == 0 :
        return 0
    elif n == 1 :
        return 1
    else :
        return fib ( n - 1 ) + fib ( n - 2 )
    

if __name__ == "__main__":
    main()
    
####################################################    
    
"""
  Answers to the none-coding tasks
  ================================
  
  
  Exercise 16: Time for bricklek with 50 bricks:
    From example 12 we know the nr of movement what we are looking for. It is t(50)=2^50-1~1.12*10^15 movement.
    If one movement takes one second, than we know that the whole process takes 2^50-1 sec ~ 3.5*10^7year
  
  
  
  Exercise 17: Time for Fibonacci:
    a) See my demponstration code above and my results below.
    Conclusion is the constant c1,c2 is around 0.00000018

    b) estimation n=50: 0.00000018*1.618^50 ~ 5060.5sec ~ 1h 26min
       estimation n=100: 0.00000018*1.618^100 ~ 1.42 × 10^14 second ~ 4.5*10^6 year
  
  
  
  
  Exercise 20: Comparison sorting methods:
    Insertion sort: average runtime O(n^2) -> runtime ~ c*n^2
        n=10^3 - 1sec  =>  c=1/(10^6)
        So n=10^6 => runtime ~ 10^6sec ~ 11.57 day
        and n=10^9 => runtime ~ 10^12sec ~ 31 688.76 years

    Merge sort: average runtime O(n logn) -> runtime ~ c*nlogn
        n=10^3 - 1sec  =>  c=1/(1000ln1000) ~ 0.00014476
        So n=10^6 => runtime ~ 2000sec ~ 33.33min
        And n=10^9 => runtime ~ 3000000sec ~ 34.7day

  
  Exercise 21: Comparison Theta(n) and Theta(n log n)
    For B -> c*10*log10 ~ 1 sec => c~ 0.04343
    Question where is n*logn*0.04343 > n
        log n > 1/0.04343
        => ~ n= 10^10 needs for take longer for alg B than alg A
  
  
  
  
  
  



Ex 17:
If the runtime O(1.618^n), than the c constant would be for case size 1 : 0.0000004944 seconds
If the runtime O(1.618^n), than the c constant would be for case size 2 : 0.0000004584 seconds
If the runtime O(1.618^n), than the c constant would be for case size 3 : 0.0000002125 seconds
If the runtime O(1.618^n), than the c constant would be for case size 4 : 0.0000002772 seconds
If the runtime O(1.618^n), than the c constant would be for case size 5 : 0.0000001804 seconds
If the runtime O(1.618^n), than the c constant would be for case size 6 : 0.0000001784 seconds
If the runtime O(1.618^n), than the c constant would be for case size 7 : 0.0000001722 seconds
If the runtime O(1.618^n), than the c constant would be for case size 8 : 0.0000002150 seconds
If the runtime O(1.618^n), than the c constant would be for case size 9 : 0.0000002158 seconds
If the runtime O(1.618^n), than the c constant would be for case size 10 : 0.0000001700 seconds
If the runtime O(1.618^n), than the c constant would be for case size 11 : 0.0000001699 seconds
If the runtime O(1.618^n), than the c constant would be for case size 12 : 0.0000001681 seconds
If the runtime O(1.618^n), than the c constant would be for case size 13 : 0.0000001592 seconds
If the runtime O(1.618^n), than the c constant would be for case size 14 : 0.0000001563 seconds
If the runtime O(1.618^n), than the c constant would be for case size 15 : 0.0000002425 seconds
If the runtime O(1.618^n), than the c constant would be for case size 16 : 0.0000001558 seconds
If the runtime O(1.618^n), than the c constant would be for case size 17 : 0.0000001871 seconds
If the runtime O(1.618^n), than the c constant would be for case size 18 : 0.0000001593 seconds
If the runtime O(1.618^n), than the c constant would be for case size 19 : 0.0000002102 seconds
If the runtime O(1.618^n), than the c constant would be for case size 20 : 0.0000003607 seconds
If the runtime O(1.618^n), than the c constant would be for case size 21 : 0.0000003923 seconds
If the runtime O(1.618^n), than the c constant would be for case size 22 : 0.0000004133 seconds
If the runtime O(1.618^n), than the c constant would be for case size 23 : 0.0000002759 seconds
If the runtime O(1.618^n), than the c constant would be for case size 24 : 0.0000002462 seconds
If the runtime O(1.618^n), than the c constant would be for case size 25 : 0.0000002688 seconds
If the runtime O(1.618^n), than the c constant would be for case size 26 : 0.0000002428 seconds
If the runtime O(1.618^n), than the c constant would be for case size 27 : 0.0000001764 seconds
If the runtime O(1.618^n), than the c constant would be for case size 28 : 0.0000001596 seconds
If the runtime O(1.618^n), than the c constant would be for case size 29 : 0.0000001770 seconds
If the runtime O(1.618^n), than the c constant would be for case size 30 : 0.0000001716 seconds
If the runtime O(1.618^n), than the c constant would be for case size 31 : 0.0000001758 seconds
If the runtime O(1.618^n), than the c constant would be for case size 32 : 0.0000001620 seconds
If the runtime O(1.618^n), than the c constant would be for case size 33 : 0.0000001740 seconds
If the runtime O(1.618^n), than the c constant would be for case size 34 : 0.0000001826 seconds
If the runtime O(1.618^n), than the c constant would be for case size 35 : 0.0000001655 seconds
If the runtime O(1.618^n), than the c constant would be for case size 36 : 0.0000001803 seconds
If the runtime O(1.618^n), than the c constant would be for case size 37 : 0.0000001902 seconds






If the runtime O(1.5^n), than the c constant would be for case size 1 : 0.0000004000 seconds
If the runtime O(1.5^n), than the c constant would be for case size 2 : 0.0000005333 seconds
If the runtime O(1.5^n), than the c constant would be for case size 3 : 0.0000002963 seconds
If the runtime O(1.5^n), than the c constant would be for case size 4 : 0.0000003160 seconds
If the runtime O(1.5^n), than the c constant would be for case size 5 : 0.0000002502 seconds
If the runtime O(1.5^n), than the c constant would be for case size 6 : 0.0000002546 seconds
If the runtime O(1.5^n), than the c constant would be for case size 7 : 0.0000002809 seconds
If the runtime O(1.5^n), than the c constant would be for case size 8 : 0.0000002965 seconds
If the runtime O(1.5^n), than the c constant would be for case size 9 : 0.0000003824 seconds
If the runtime O(1.5^n), than the c constant would be for case size 10 : 0.0000003434 seconds
If the runtime O(1.5^n), than the c constant would be for case size 11 : 0.0000003688 seconds
If the runtime O(1.5^n), than the c constant would be for case size 12 : 0.0000003938 seconds
If the runtime O(1.5^n), than the c constant would be for case size 13 : 0.0000003936 seconds
If the runtime O(1.5^n), than the c constant would be for case size 14 : 0.0000004237 seconds
If the runtime O(1.5^n), than the c constant would be for case size 15 : 0.0000004636 seconds
If the runtime O(1.5^n), than the c constant would be for case size 16 : 0.0000004930 seconds
If the runtime O(1.5^n), than the c constant would be for case size 17 : 0.0000005303 seconds
If the runtime O(1.5^n), than the c constant would be for case size 18 : 0.0000005722 seconds
If the runtime O(1.5^n), than the c constant would be for case size 19 : 0.0000006164 seconds
If the runtime O(1.5^n), than the c constant would be for case size 20 : 0.0000006751 seconds
If the runtime O(1.5^n), than the c constant would be for case size 21 : 0.0000013377 seconds
If the runtime O(1.5^n), than the c constant would be for case size 22 : 0.0000011496 seconds
If the runtime O(1.5^n), than the c constant would be for case size 23 : 0.0000010387 seconds
If the runtime O(1.5^n), than the c constant would be for case size 24 : 0.0000010647 seconds
If the runtime O(1.5^n), than the c constant would be for case size 25 : 0.0000010452 seconds
If the runtime O(1.5^n), than the c constant would be for case size 26 : 0.0000013658 seconds
If the runtime O(1.5^n), than the c constant would be for case size 27 : 0.0000014998 seconds
If the runtime O(1.5^n), than the c constant would be for case size 28 : 0.0000015156 seconds
If the runtime O(1.5^n), than the c constant would be for case size 29 : 0.0000016011 seconds
If the runtime O(1.5^n), than the c constant would be for case size 30 : 0.0000016455 seconds
If the runtime O(1.5^n), than the c constant would be for case size 31 : 0.0000017851 seconds
If the runtime O(1.5^n), than the c constant would be for case size 32 : 0.0000019734 seconds
If the runtime O(1.5^n), than the c constant would be for case size 33 : 0.0000021544 seconds
If the runtime O(1.5^n), than the c constant would be for case size 34 : 0.0000020781 seconds
If the runtime O(1.5^n), than the c constant would be for case size 35 : 0.0000022649 seconds
If the runtime O(1.5^n), than the c constant would be for case size 36 : 0.0000025597 seconds
If the runtime O(1.5^n), than the c constant would be for case size 37 : 0.0000026807 seconds
If the runtime O(1.5^n), than the c constant would be for case size 38 : 0.0000028388 seconds
If the runtime O(1.5^n), than the c constant would be for case size 39 : 0.0000032130 seconds





If the runtime O(1.7^n), than the c constant would be for case size 1 : 0.0000003529 seconds
If the runtime O(1.7^n), than the c constant would be for case size 2 : 0.0000004152 seconds
If the runtime O(1.7^n), than the c constant would be for case size 3 : 0.0000002035 seconds
If the runtime O(1.7^n), than the c constant would be for case size 4 : 0.0000001916 seconds
If the runtime O(1.7^n), than the c constant would be for case size 5 : 0.0000001479 seconds
If the runtime O(1.7^n), than the c constant would be for case size 6 : 0.0000001326 seconds
If the runtime O(1.7^n), than the c constant would be for case size 7 : 0.0000001243 seconds
If the runtime O(1.7^n), than the c constant would be for case size 8 : 0.0000001175 seconds
If the runtime O(1.7^n), than the c constant would be for case size 9 : 0.0000001273 seconds
If the runtime O(1.7^n), than the c constant would be for case size 10 : 0.0000001047 seconds
If the runtime O(1.7^n), than the c constant would be for case size 11 : 0.0000000995 seconds
If the runtime O(1.7^n), than the c constant would be for case size 12 : 0.0000000923 seconds
If the runtime O(1.7^n), than the c constant would be for case size 13 : 0.0000000774 seconds
If the runtime O(1.7^n), than the c constant would be for case size 14 : 0.0000000733 seconds
If the runtime O(1.7^n), than the c constant would be for case size 15 : 0.0000000979 seconds
If the runtime O(1.7^n), than the c constant would be for case size 16 : 0.0000000665 seconds
If the runtime O(1.7^n), than the c constant would be for case size 17 : 0.0000000650 seconds
If the runtime O(1.7^n), than the c constant would be for case size 18 : 0.0000000601 seconds
If the runtime O(1.7^n), than the c constant would be for case size 19 : 0.0000001086 seconds
If the runtime O(1.7^n), than the c constant would be for case size 20 : 0.0000000764 seconds
If the runtime O(1.7^n), than the c constant would be for case size 21 : 0.0000000623 seconds
If the runtime O(1.7^n), than the c constant would be for case size 22 : 0.0000000610 seconds
If the runtime O(1.7^n), than the c constant would be for case size 23 : 0.0000000555 seconds
If the runtime O(1.7^n), than the c constant would be for case size 24 : 0.0000000617 seconds
If the runtime O(1.7^n), than the c constant would be for case size 25 : 0.0000000691 seconds
If the runtime O(1.7^n), than the c constant would be for case size 26 : 0.0000000559 seconds
If the runtime O(1.7^n), than the c constant would be for case size 27 : 0.0000000489 seconds
If the runtime O(1.7^n), than the c constant would be for case size 28 : 0.0000000403 seconds
If the runtime O(1.7^n), than the c constant would be for case size 29 : 0.0000000381 seconds
If the runtime O(1.7^n), than the c constant would be for case size 30 : 0.0000000448 seconds
If the runtime O(1.7^n), than the c constant would be for case size 31 : 0.0000000351 seconds
If the runtime O(1.7^n), than the c constant would be for case size 32 : 0.0000000366 seconds
If the runtime O(1.7^n), than the c constant would be for case size 33 : 0.0000000331 seconds
If the runtime O(1.7^n), than the c constant would be for case size 34 : 0.0000000296 seconds
If the runtime O(1.7^n), than the c constant would be for case size 35 : 0.0000000276 seconds
If the runtime O(1.7^n), than the c constant would be for case size 36 : 0.0000000273 seconds
If the runtime O(1.7^n), than the c constant would be for case size 37 : 0.0000000265 seconds
If the runtime O(1.7^n), than the c constant would be for case size 38 : 0.0000000259 seconds
If the runtime O(1.7^n), than the c constant would be for case size 39 : 0.0000000245 seconds
"""