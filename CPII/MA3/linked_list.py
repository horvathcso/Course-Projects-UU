""" linked_list.py

Student: Csongor Horváth
Mail: sifuto2013@gmail.com
Reviewed by:  Adam Person
Date reviewed: 2022.10.05
"""


from locale import currency


class LinkedList:

    class Node:
        def __init__(self, data, succ):
            self.data = data
            self.succ = succ

    def __init__(self):
        self.first = None

    def __iter__(self):            # Discussed in the section on iterators and generators
        current = self.first
        while current:
            yield current.data
            current = current.succ

    def __in__(self, x):           # Discussed in the section on operator overloading
        for d in self:
            if d == x:
                return True
            elif x < d:
                return False
        return False

    def insert(self, x):
        if self.first is None or x <= self.first.data:
            self.first = self.Node(x, self.first)
        else:
            f = self.first
            while f.succ and x > f.succ.data:
                f = f.succ
            f.succ = self.Node(x, f.succ)

    def print(self):
        print('(', end='')
        f = self.first
        while f:
            print(f.data, end='')
            f = f.succ
            if f:
                print(', ', end='')
        print(')')

    # To be implemented

    def length(self):             # Optional
        c = 0
        current = self.first
        if current is None:
            return 0
        else:
            while current:
                current = current.succ
                c +=1
            return c

    def mean(self):               # Optional
        pass

    def remove_last(self):        # Optional
        pass

    def remove(self, x):          # Compulsory
        current = self.first
        if self.length() == 1 and current.data ==x:
            self.first = None
        elif current.data == x:
            current = current.succ
            self.first = current
            return True
        else:
            last = self.first
            current = current.succ
            while current:
                if current.data == x:
                    last.succ = current.succ
                    return True
                current = current.succ
                last= last.succ
        return False


    def count(self, x):           # Optional
        pass

    def to_list(self):            # Compulsory
        return self._to_list(self.first)

    def _to_list(self, f):            
        if f is None:
            return []
        else:
            l=self._to_list(f.succ)
            l.insert(0,f.data)
            return l
    

    def remove_all(self, x):      # Compulsory
        current = self.first
        if current is not None and current.data == x:
            self.first=current.succ
            self.remove_all(x)
        else: 
            self._remove_all(x, self.first)
        
    def _remove_all(self, x, f):
        if f is not None:
            g=f.succ
            if g is not None and g.data == x:
                f.succ = g.succ
                self._remove_all(x,f)
            else: self._remove_all(x,g)

    def __str__(self):            # Compulsary
        o = "("
        f = self.first
        while f:
            o += str(f.data)
            f = f.succ
            if f:
                o +=", "
        o += ")"
        return o

    def _copy(self):               # Compulsary
        result = LinkedList()
        for x in self:
            result.insert(x)
        return result
    ''' Complexity for this implementation: 
        O(n^2), since there are n elements and in each elements insertation it is also O(n) which gives O(n^2)
    '''


    def copy(self):               # Compulsary
        res=LinkedList()
        lis = self.to_list() # use generator, ergo use: for x in self
        lis.reverse()
        succ=None
        for x in lis[:-1]:
           succ= res.Node(x,succ)
        res.first=res.Node(lis[-1],succ)
        return res                     # Should be more efficient
    ''' Complexity for this implementation:
        O(n) - crate list is O(n) implementation, revese is also O(n) and iteratin trough is also O(n) so O(3n)=O(n) the complexity
    '''

    def __getitem__(self, ind):   # Compulsory
        current=self.first
        for _ in range(ind):
            current=current.succ
        return current.data


class Person:                     # Compulsory to complete
    def __init__(self, name, pnr):
        self.name = name
        self.pnr = pnr

    def __str__(self):
        return f"{self.name}:{self.pnr}"

    def __lt__(self, other):
        if self.pnr != other.pnr:
            return self.name<other.name
        else: return False
    def __gt__(self, other):
        if self.pnr != other.pnr:
            return self.name>other.name
        else: return False   
    def __le__(self, other):
        if self.pnr != other.pnr:
            return self.name<other.name
        else: return True
    def __ge__(self, other):
        if self.pnr != other.pnr:
            return self.name>other.name
        else: return True   
    def __eq__(self, other):
        if self.pnr == other.pnr:
            return True
        else: return False

    


def main():
    lst = LinkedList()
    p1=Person("Ana",1)
    p2=Person("Ana",1)
    p3=Person("Apa",2)
    p4=Person("Baba",3)
    p4=Person("Bab",3)
    #for x in [1, 1, 1, 2, 3, 3, 2, 1, 9, 7]:
    #    lst.insert(x)
    for x in [p2,p1,p4,p3]:
        lst.insert(x)
    l=lst.copy()
    lst.remove(Person("Ana",1))
    print(lst)
    l.print()
    print(l[3])
    
    # Test code:


if __name__ == '__main__':
    main()
