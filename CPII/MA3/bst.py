""" bst.py

Student:Csongor Horváth 
Mail: sifuto2013@gmail.com
Reviewed by: Adam Person
Date reviewed: 2022.10.05
"""


from audioop import avg
from turtle import color
from linked_list import LinkedList

# only for data analysis
import random
import statistics as stat
import math
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np


class BST:

    class Node:
        def __init__(self, key, left=None, right=None):
            self.key = key
            self.left = left
            self.right = right

        def __iter__(self):     # Discussed in the text on generators
            if self.left:
                yield from self.left
            yield self.key
            if self.right:
                yield from self.right

    def __init__(self, root=None):
        self.root = root

    def __iter__(self):         # Dicussed in the text on generators
        if self.root:
            yield from self.root

    def insert(self, key):
        self.root = self._insert(self.root, key)

    def _insert(self, r, key):
        if r is None:
            return self.Node(key)
        elif key < r.key:
            r.left = self._insert(r.left, key)
        elif key > r.key:
            r.right = self._insert(r.right, key)
        else:
            pass  # Already there
        return r

    def print(self):
        self._print(self.root)

    def _print(self, r):
        if r:
            self._print(r.left)
            print(r.key, end=' ')
            self._print(r.right)

    def contains(self, k):
        n = self.root
        while n and n.key != k:
            if k < n.key:
                n = n.left
            else:
                n = n.right
        return n is not None

    def size(self):
        return self._size(self.root)

    def _size(self, r):
        if r is None:
            return 0
        else:
            return 1 + self._size(r.left) + self._size(r.right)

#
#   Methods to be completed
#

    def height(self):                             # Compulsory
        return self._height(self.root)
    
    def _height(self, r):
        if r is None:
            return 0
        else:
            return max(self._height(r.right),self._height(r.left))+1

    def remove(self, key):
        self.root = self._remove(self.root, key)

    def _remove(self, r, k):                      # Compulsory
        if r is None:
            return None
        elif k < r.key:
            r.left = self._remove(r.left,k)#left subtree with k removed
        elif k > r.key:
            r.right =  self._remove(r.right,k) #right subtree with k removed
        else:  # This is the key to be removed
            if r.left is None:     # Easy case
                return r.right
            elif r.right is None:  # Also easy case
                return r.left
            else:  # This is the tricky case.
                l = r.left
                prev=r
                if l.right is None:
                    l.right = r.right
                    return l
                while l.right is not None:
                    prev=l
                    l = l.right
                prev.right = None
                l.left=r.left
                l.right=r.right
                return l
        return r      

    def __str__(self):                            # Compulsory
        if self.root is not None:
            o= "<"
            o += self._str(self.root)
            o+= ">"
            return o
        else:
            return "<>"
    
    def _str(self, r):
        o=""
        if r.left is not None:
            o += self._str(r.left)
            o += ", "
        o += str(r.key)
        if r.right is not None:
            o += ", "
            o += self._str(r.right)
        return o

    def to_list(self):                            # Compulsory
        '''
            Complexity: O(n) since we iterate in evry element exactly once
        '''
        return self._to_list(self.root)

    def _to_list(self, r):
        if self.root is None:
            return []
        l=[]
        if r.left is not None:
            l.extend( self._to_list(r.left))
        l.append(r.key)
        if r.right is not None:
            l.extend(self._to_list(r.right)) 
        return l

    def to_LinkedList(self):                      # Compulsory
        '''
        O(n^2) it is basicly the same implementation as the given in the LinkedList.copy() in the task sheet
        '''
        l = LinkedList()
        for e in self:
            l.insert(e)
        return l

    def ipl(self):                                # Compulsory
        if self.root is None:
            return 0
        return self._ipl(self.root, 1)

    def _ipl(self, r, l):
        s=0
        if r.left is not None:
            s += self._ipl(r.left, l+1)
        s += l
        if r.right is not None:
            s += self._ipl(r.right, l+1)
        return s

def random_tree(n):                               # Useful
    t =BST()
    while t.size() != n:
        t.insert(random.random())
    return t


def main():
    '''
    t = BST()
    for x in [4, 1, 3, 6, 7, 1, 1, 5, 8]:
        t.insert(x)
    t.print()
    print()
    '''
    h=[]
    h_=[]
    idl=[]
    oh=[]
    c=[]
    n_=[]


    for n in range(10,1000,10):
        t=random_tree(n)
        ipl=t.ipl()
        h.append(t.height())
        h_.append(t.height())
        idl.append(ipl)
        oh.append(ipl/math.log(n))
        c.append((ipl-(1.39*n*math.log2(n)))/n)
        n_.append(float(n))
        print(n, ipl, (ipl-(1.39*n*math.log2(n)))/n)

    print(sum(h)/len(h),sum(idl)/len(idl),sum(oh)/len(oh), sum(c)/len(c),stat.stdev(c))
    print(stat.stdev(h_), sum(h_)/len(h_))
    print(c)
    
    n_=np.array(n_)

    fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(10, 5))
    ax1.plot(n_, idl)
    p=1.39*n_*np.log2(n_)
    ax1.plot(n_, p)

    ax2.plot(n_, c)
    ax3.plot(n_, h)
    plt.show()

   

        




if __name__ == "__main__":
    main()




"""
What is the generator good for?
==============================

1. computing size?
    Y
2. computing height?
    N
3. contains?
    Y
4. insert?
    N
5. remove?
    N


From the data below and the generated images we can assume it really is 1.39nlogn on average.
And for h I assume it grows in logaritmic ways from the fact that in filled trees it grows this way and from the data seen on the figure.


Results for ipl of random trees
===============================
n   ipl estimation of c
100 731 -1.924960103786867
110 848 -1.7169990927083663
120 965 -1.558911261229173
130 966 -2.3303220293403193
140 1144 -1.738274822124931
150 1378 -0.8613913131226051
160 1326 -1.8899800518934327
170 1409 -2.010818107113758
180 1634 -1.3358980261204692
190 1619 -2.001046664001069
200 1669 -2.279960103786866
210 1790 -2.1989917457463846
220 1894 -2.206999092708367
230 1917 -2.5704485621170297
240 2179 -1.9114112612291725
250 2291 -1.9084401556803003
260 2794 -0.4049374139557043
270 2527 -1.8675144206413952
280 2595 -2.031846250696362
290 2640 -2.26662535925869
300 2740 -2.30472464645594
310 2812 -2.4328451813957073
320 3577 -0.3893550518934319
330 3473 -1.1049454535592593
340 3199 -2.280229871819641
350 3520 -1.6900405883040783
360 3800 -1.2481202483426916
370 3571 -2.207268878766322
380 4506 -0.05420455873790831
390 4205 -1.1821378540606742
400 4191 -1.5374601037868683
410 4347 -1.4620383139223256
420 4355 -1.743753650508292
430 4416 -1.890220619068883
440 4403 -2.1992718199810932
450 4957 -1.2356003002361264
460 4431 -2.662622475160507
470 4913 -1.8851670663636468
480 5357 -1.2201612612291721
490 5195 -1.8198859188870413
500 5180 -2.1024401556803003
510 5113 -2.4766610811553815
520 5217 -2.508398952417243
530 6137 -1.0000442007174124
540 5825 -1.8297366428636181
550 5960 -1.8172064173290743
560 5718 -2.4789891078392188
570 5990 -2.216425241757864
580 6932 -0.8083494971897239
590 7029 -0.8807945684724935
600 6547 -1.9163913131226067
610 6341 -2.46612298389273
620 6671 -2.1341355039763528
630 6933 -1.921137240796413
640 7283 -1.5777925518934324
650 6956 -2.287032850464521
660 8275 -0.4813090899228965
670 7469 -1.9015828325998883
680 7484 -2.0731710482902304
690 8572 -0.6851406410179877
700 7582 -2.3057548740183638
710 7836 -2.1290088296950835
720 8444 -1.4658980261204684
730 7592 -2.8213361887366575
740 9123 -0.9202418517392953
750 8491 -1.9542046983493735
760 8904 -1.586309821895805
770 8310 -2.5361055512515533
780 8767 -2.1144455463683673
790 8185 -3.0189757981887193
800 9210 -1.8924601037868682
810 8839 -2.5175258768907165
820 9070 -2.393501728556471
830 10761 -0.5137246205018023
840 8981 -2.8111346028892448
850 10028 -1.728886394301309
860 9801 -2.153476433022371
870 10019 -2.0570795571001774
880 9925 -2.317680910890185
890 10713 -1.5816708692513326
900 10504 -1.970044744680571
910 10550 -2.0699080083630257
920 10812 -1.933057257769204
930 10910 -1.9757280036346718
940 11041 -1.9826138748742836
950 10602 -2.5895793474734514
960 13065 -0.16120292789583837
970 12216 -1.1975444695438502
980 11925 -1.6435593882747972
990 11220 -2.4989524204707574

"""
