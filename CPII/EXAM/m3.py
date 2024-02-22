"""
File m3.py for exam 2022-10-28

Name: Csongor Horváth

"""

# No other imports are allowed
import math
import random
import time

from requests import ReadTimeout


class LinkedList:
    class Node:
        def __init__(self, data, succ=None):
            self.data = data
            self.succ = succ

    def __init__(self):
        self.first = None

    def __iter__(self):
        current = self.first
        while current:
            yield current.data
            current = current.succ

    def __str__(self):
        return '<' + ', '.join((str(x) for x in self)) + '>'

    def insert(self, data):
        if self.first == None or data < self.first.data:
            self.first = self.Node(data, self.first)
        else:
            prev = self.first
            while prev.succ and (data > prev.succ.data):
                prev = prev.succ
            prev.succ = self.Node(data, prev.succ)


def build_list(n):  # A6: Should be analysed
    llist = LinkedList()
    for x in range(3*n):
        llist.insert(x)
    return llist


class BST:
    class Node:
        def __init__(self, key, left=None, right=None):
            self.key = key
            self.left = left
            self.right = right

        def __iter__(self):
            if self.left:
                yield from self.left
            yield self.key
            if self.right:
                yield from self.right

    def __init__(self, root=None):
        self.root = root

    def __iter__(self):
        if self.root:
            yield from self.root

    def insert(self, key):
        def _insert(key, r):
            if r is None:
                return self.Node(key)
            elif key < r.key:
                r.left = _insert(key, r.left)
            elif key > r.key:
                r.right = _insert(key, r.right)
            else:
                pass  # Already there
            return r
        self.root = _insert(key, self.root)

    def __str__(self):
        return '<' + ', '.join([str(x) for x in self]) + '>'

    def copy(self):

        def _copy(r):  # A5
            if r is None:
                return None
            r_copy = BST.Node(r.key)
            r_copy.left = _copy(r.left)
            r_copy.right = _copy(r.right)

            return r_copy

        return BST(_copy(self.root))


class LevelOrderIterator:  # Task B3
    def __init__(self,bst):
        self.current=bst.root
        self.this=[self.current]
        self.next=[]
    def __iter__(self):
        while len(self.this)>0:
            for e in self.this:
                yield e.key
                if e.left:
                    self.next.append(e.left)
                if e.right:
                    self.next.append(e.right)
            self.this=self.next
            self.next=[]

    


def main():
    # Code for timing the build_list function
    print('\nA5: Time complexity for build list \n Theta(n^2)')

    # Code for trying the copy method in class BST
    bst = BST()
    for x in (5, 3, 2, 4, 8, 10, 6, 1, 7, 9):
        bst.insert(x)
    print('\nA6: copy')
    copy = bst.copy()
    print('original:', bst)
    print('copy    :', copy)

    # To demonstrate it really is a copy
    copy.insert(11)
    bst.insert(12)
    print('Demonstration of being a copy:')
    print('original:', bst)
    print('copy    :', copy)

    # Code for demonstrating the level order iterator
    print('\nB3: LevelOrderIterator')
    bst = BST()
    print('Insertion order: ', end=' ')
    for x in [5, 3, 2, 4, 8, 10, 6, 1, 7, 9]:
        print(x, end=' ')
        bst.insert(x)
    print('\nSymmetric order: ', end=' ')
    for x in bst:
        print(x, end=' ')
    print('\nLevel order    : ', end=' ')

    #exit()  # Remove this line for testing the iterator
    loi = LevelOrderIterator(bst)
    for x in loi:
        print(x, end=' ')
    print()

    
    #Code to messure runtime 
    print("\n Working on time mesurment")
    c=[]
    for n in range(25,2500,25):
        start = time.perf_counter()
        build_list(n)
        end=time.perf_counter()
        rtime=end-start
        c_=rtime/n**2
        c.append(c_)
    print(f"average c is {sum(c)/len(c)}")

    print('\n\nDone')

    

if __name__ == '__main__':
    main()

''' 
Answer to A6
Output from the timing of the build_list function
=================================================
    #Code to messure runtime 
    c=[]
    for n in range(25,2500,25):
        start = time.perf_counter()
        build_list(n)
        end=time.perf_counter()
        rtime=end-start
        c_=rtime/n**2
        c.append(c_)
    print(f"average c is {sum(c)/len(c)}")

Out: average c is 4.664911859237348e-07




Reasoning and motivation
========================
By analyzing the codes we can notice we insert the elements from 0 to 3n-1 in increasing order to the list.
When inserting to the list with m element we will insert to the end of the list, since the new element is bigger than all the previous.
In the implementation of insert it means we will iterate through all of the m elements since we start with the first and iterate till the inserted element is greater than the current.

This means the runtime of the insertion of the m-th element will have theta(m+1) steps.
We do it for m=0 to m=3n-1:
that will result in c*(1+2+..+3n)=c*(0.5*3n(3n+1)) steps
This means that the runtime is theta(n^2) 

So to determinate the runtime we wanted to guess c in the runtime c*n^2.
It won't be too good of a guess, since the runtime can vary much from time to time dependending on the other computer processes.
Note: eg we could also guess from mesuring some data and doing curve fitting on them (fitting a 2nd order curve sinve we know runtime is theta(n^2))

From the above data we can guess the runtime for build_list(1000000), n=10**6 -> our guess is c_avg*n**2,
where c_avg from the runtime datas is approx 4.66*10^-7
So the estimated runtime is 4.66*10^-7*10**12=4.66*10**5 sec which is apprx 5days and 10 hours








'''
