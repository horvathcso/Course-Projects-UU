"""
Solutions to module 2 - A calculator
Student: Csongor Horváth
Mail: sifuto2013@gmail.com
Reviewed by: MArtin Knebel
Reviewed date: 2022.09.19
"""

"""
Note:
The program is only working for a very tiny set of operations.
You have to add and/or modify code in ALL functions as well as add some new functions.
Use the syntax charts when you write the functions!
However, the class SyntaxError is complete as well as handling in main
of SyntaxError and TokenError.
"""

from ast import arg
import math
from msilib.schema import Error
from statistics import mean
from tkinter import W
from tokenize import TokenError  
from MA2tokenizer import TokenizeWrapper

class SyntaxError(Exception):
    def __init__(self, arg):
        self.arg = arg
        super().__init__(self.arg)

class EvaluationError(Exception):
    def __init__(self, arg):
        self.arg = arg
        super().__init__(self.arg)


def statement(wtok, variables):
    """ See syntax chart for statement"""
    result = assignment(wtok, variables)
    if not wtok.is_at_end():
        raise SyntaxError("Wrong syntax. There is extra text in the end of the statement")
    return result


def assignment(wtok, variables):
    """ See syntax chart for assignment"""
    result = expression(wtok, variables)
    while wtok.get_current() == "=":
        wtok.next()
        if wtok.is_name():
            variables[wtok.get_current()]=result
            wtok.next()
        else:
            raise SyntaxError("Expected name")
    return result


def expression(wtok, variables):
    """ See syntax chart for expression"""
    result = term(wtok, variables)
    while wtok.get_current() == '+' or wtok.get_current() == '-':
        wtok.next()
        if wtok.get_previous() == '+':
            result = result + term(wtok, variables)
        else: 
            result = result - term(wtok, variables)
    return result


def term(wtok, variables):
    """ See syntax chart for term"""
    result = factor(wtok, variables)
    while wtok.get_current() == '*' or wtok.get_current() == '/' or wtok.get_current() == '%': 
        wtok.next()
        if wtok.get_previous() == '*':
            result = result * factor(wtok, variables)
        elif wtok.get_previous() == '/':
            div = factor(wtok, variables)
            if div == 0:
                raise EvaluationError("Division by Zero")
            result = result / div
        else:
            mod = factor(wtok,variables)
            if mod ==0:
                raise EvaluationError("Modulo by zero")
            result = result % mod
    return result


def arglist(wtok, variables):
    args=[]
    got_args=False
    wtok.next()
    element= assignment(wtok, variables)
    args.append(element)
    while wtok.get_current() == ',':
        #got_args=True
        wtok.next()
        element= assignment(wtok, variables)
        args.append(element)
    if wtok.get_current() == ')': #and got_args:
        wtok.next()
        return args
    else:
        raise SyntaxError(f"Wrong form of arguments in the multivariable function.")


def factor(wtok, variables):
    """ See syntax chart for factor"""
    if wtok.get_current() == '(':
        wtok.next()
        result = assignment(wtok, variables)
        if wtok.get_current() != ')':
            raise SyntaxError("Expected ')'")
        else:
            wtok.next()

    elif wtok.get_current() in function_1:
        func = wtok.get_current()
        wtok.next()
        if wtok.get_current() == '(':
            arg = factor(wtok, variables)
            result = function_1[func](arg)
        else:
            raise SyntaxError("Expected '(' after a function") 

    elif wtok.get_current() in function_n:
        func = wtok.get_current()
        wtok.next()
        if wtok.get_current() == '(':
            args = arglist(wtok, variables)
            result = function_n[func](*args)
        else:
            raise SyntaxError("Expected '(' after a function")  

    elif wtok.is_name():
        if wtok.get_current() in variables:
            result = variables[wtok.get_current()]
            wtok.next()
        else:
            raise EvaluationError("Name not defined")

    elif wtok.is_number():
        result = float(wtok.get_current())
        wtok.next()
          

    elif wtok.get_current() == '-':
        wtok.next()
        result = -factor(wtok, variables)
        
    else:
        raise SyntaxError(
            "Expected number or '('")   
    return result


def fib(n):
    if n<0:
        raise EvaluationError("fib must have positive argument")
    if n%1 == 0:
        n=int(n)
        fibs = [0, 1]
        for i in range(1, n):
            fibs.append(fibs[-1] + fibs[-2])
        return fibs[n]
    else:
        raise EvaluationError("Expected integer in the argument of fib")

def fac(n):
        if n%1 == 0:
            return math.factorial(int(n))
        else:
            raise EvaluationError("factorial with float")

def log(n):
    if n <= 0:
        raise EvaluationError("Log should have a positive argument")
    return math.log(n)

def sqrt(n):
    if n <= 0:
        raise EvaluationError("Sqrt should have a positive argument")
    return math.sqrt(n)

def cat(n):
    '''
        Gives the n th catalan number if n>=0 integer
    '''
    if n<0:
        raise EvaluationError("cat must have positive argument")
    if n%1 == 0:
        n=int(n)
        return comb((2*n),n)-comb(2*n,n+1)

def pow(*args):
    if len(args) != 2:
        raise SyntaxError("Function pow expects 2 arguments. Less or more were given.")
    else:
        return math.pow(args[0],args[1])

def comb(*args):
    if len(args) != 2:
        raise SyntaxError("Function comb expects 2 arguments. Less or more were given.")
    elif args[0]%1 != 0 or args[1]%1 != 0:
        raise EvaluationError("comb must have integers as arguments")
    else:
        return math.comb(int(args[0]),int(args[1]))    

def sum(*args):
    if len(args)==1:
        return args[0]
    else: return sum(*args[:-1]) +args[-1]

def max_(*args):
    if len(args)==1:
            return args[0]
    else: 
        try:
            return max(*args)
        except Exception as e:
            raise EvaluationError(e)

def min_(*args):
    if len(args)==1:
            return args[0]
    else: 
        try:
            return min(*args)
        except Exception as e:
            raise EvaluationError(e)

def mean(*args):
    nr=0; S=0
    for e in args:
        S += e; nr += 1
    return S/nr

function_1={"fib": fib, "sin": math.sin, "cos": math.cos, "exp":math.exp, "log":log, "fac":fac, "sqrt":sqrt, "cat":cat}
function_n={"max":max_, "min":min_, "sum":sum, "mean":mean, "pow":pow, "comb":comb}

def main():
    """
    Handles:
       the iteration over input lines,
       commands like 'quit' and 'vars' and
       raised exceptions.
    Starts with reading the init file
    """
    print("Numerical calculator")
    variables = {"ans": 0.0, "E": math.e, "PI": math.pi}
    function_1={"fib": fib}
    function_n={"max":max}
    # Note: The unit test file initiate variables in this way. If your implementation 
    # requires another initiation you have to update the test file accordingly.
    init_file = 'MA2init.txt'
    lines_from_file = ''
    try:
        with open(init_file, 'r') as file:
            lines_from_file = file.readlines()
    except FileNotFoundError:
        pass

    print(lines_from_file)

    while True:
        if lines_from_file:
            line = lines_from_file.pop(0).strip()
            print('init  :', line)
        else:
            line = input('\nInput : ')
        if line == '' or line[0]=='#':
            continue
        wtok = TokenizeWrapper(line)

        if wtok.get_current() == 'quit':
            print('Bye')
            exit()
        else:
            try:
                result = statement(wtok, variables)
                variables['ans'] = result
                print('Result:', result)

            except SyntaxError as se:
                print("*** Syntax error: ", se)
                print(f"Error occurred at '{wtok.get_current()}' just after '{wtok.get_previous()}'")

            except TokenError as te:
                print('*** Syntax error: Unbalanced parentheses')

            except EvaluationError as ee:
                print("*** EvaulationError error: ", ee)
                print(f"Error occurred at '{wtok.get_current()}' just after '{wtok.get_previous()}'")

 


if __name__ == "__main__":
    main()
