"""
File m2a.py for exam 2022-10-28

Name: Csongor Horváth

"""


# No other imports allowed
from tokenize import TokenError
from MA2tokenizer import TokenizeWrapper
import math
import time
import random


def log(x):
    if x <= 0:
        raise EvaluationError(f'Illegal argument to log: {x}')
    return math.log(x)


FUNCTIONS_1 = {  # Functions with a single argument
    'sin': math.sin,
    'cos': math.cos,
    'exp': math.exp,
    'log': log
}

FUNCTIONS_0 = {  # Functions without argument
    'random': random.random,
    'time' : time.ctime
}


class EvaluationError(Exception):
    def __init__(self, arg):
        self.arg = arg
        super().__init__(self.arg)


class SyntaxError(Exception):
    def __init__(self, arg):
        self.arg = arg
        super().__init__(self.arg)


def statement(wtok, variables):
    result = assignment(wtok, variables)
    while wtok.get_current() == ',':
        wtok.next()
        result = assignment(wtok, variables)
    if wtok.is_at_end() == False:
        raise SyntaxError('Expected comma or end of line')
    return result


def assignment(wtok, variables):
    result = expression(wtok, variables)
    while wtok.get_current() == '=':
        wtok.next()
        if wtok.is_name():
            variables[wtok.get_current()] = result
        else:
            raise SyntaxError("Expected name after '=' ")
        wtok.next()
    return result


def expression(wtok, variables):
    result = term(wtok, variables)
    while wtok.get_current() in ('+', '-'):
        try:
            if wtok.get_current() == '+':
                wtok.next()
                result = result + term(wtok, variables)
            else:
                wtok.next()
                result = result - term(wtok, variables)
        except (ValueError, TypeError) as ee:
            raise EvaluationError(ee)
    return result


def term(wtok, variables):
    result = factor(wtok, variables)
    while wtok.get_current() in ('*', '/'):
        op = wtok.get_current()
        wtok.next()
        if op == '*':
            result = result * factor(wtok, variables)
        else:
            try:
                result = result / factor(wtok, variables)
            except ZeroDivisionError:
                raise EvaluationError("Division by zero")
    return result


def parse(wtok, c, aux=''):  # Just for convenience
    if wtok.get_current() != c:
        raise SyntaxError(f"Expected '{c}'" + aux)
    wtok.next()


def factor(wtok, variables):
    """ See syntax diagram for factor"""
    if wtok.get_current() == '(':
        wtok.next()
        result = assignment(wtok, variables)
        parse(wtok, ')', '')

    elif wtok.get_current() in FUNCTIONS_0:
        func = FUNCTIONS_0[wtok.get_current()]
        wtok.next()
        if wtok.get_current() == '(':
            wtok.next()
            if wtok.get_current() == ')':
                wtok.next()
                result=func()
            else:
                raise SyntaxError("Expected ') '. This function has no arguments .")
        else:
            raise SyntaxError("Expected '( ' after function name .")

    elif wtok.get_current() in FUNCTIONS_1:
        func = FUNCTIONS_1[wtok.get_current()]
        wtok.next()
        if wtok.get_current() == '(':
            result = func(factor(wtok, variables))
        else:
            raise SyntaxError("Missing '(' after function name")


    elif wtok.is_name():
        if wtok.get_current() in variables:
            result = variables[wtok.get_current()]
            wtok.next()
        else:
            raise EvaluationError(
                f"Undefined variable: '{wtok.get_current()}'")

    elif wtok.is_number():
        if '.' in wtok.get_current():
            result = float(wtok.get_current())
        else:
            result = int(wtok.get_current())
        wtok.next()

    elif wtok.get_current() == '-':
        wtok.next()
        result = -factor(wtok, variables)

    else:
        raise SyntaxError(
            "Expected number, word or '('")
    return result


def vars_print(variables):
    for name, value in sorted(variables.items()):
        print(f"   {name:<5} : {value}")


def main():
    """
    Handles:
       the iteration over input lines,
       the commands 'quit' and 'vars' and
       catches raised exceptions.
    Starts with reading the init file
    """

    print("Numerical calculator")
    variables = {"ans": 0.0, "E": math.e, "PI": math.pi}

    init_file = 'm2a_init.txt'
    lines_from_file = ''
    try:
        with open(init_file, 'r') as file:
            lines_from_file = file.readlines()
    except FileNotFoundError:
        pass

    while True:
        if lines_from_file:
            line = lines_from_file.pop(0).strip()
            if len(line) > 0:
                print('\nInit :', line)
        else:
            line = input('\nInput: ')
        if line == '' or line[0] == '#':
            continue
        wtok = TokenizeWrapper(line)
        if wtok.get_current() == 'vars':
            vars_print(variables)
        elif wtok.get_current() == 'quit':
            print('Bye')
            exit()
        else:
            try:
                result = statement(wtok, variables)
                variables['ans'] = result
                print(result)

            except EvaluationError as ee:
                print("*** Evaluation error: ", ee)

            except SyntaxError as se:
                print("*** Syntax error: ", se)
                print(
                    f"*** Error occurred at '{wtok.get_current()}' just after '{wtok.get_previous()}'")

            except TokenError as te:
                print('*** Syntax error: Unbalanced parentheses')


if __name__ == "__main__":
    main()
