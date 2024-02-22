"""
File m2b.py for exam 2022-10-28

Name: Csongor Horváth

"""


# No other imports allowed
from tokenize import TokenError
from MA2tokenizer import TokenizeWrapper
import math


OPERATORS_2 = ('+', '-')
OPERATORS_3 = ('*', '/', '//', '%', '**')


class Node:
    def __init__(self, oper='', prio=10, left=None, right=None):
        self.oper = oper
        self.prio = prio
        self.left = left
        self.right = right

    def __str__(self):
        result = f'{self.oper}'
        lft = ''
        rgt = ''
        if self.left:
            lft = str(self.left)
            if self.prio > self.left.prio:
                lft = '(' + lft + ')'
        if self.right:
            rgt = str(self.right)
            if self.prio >= self.right.prio:
                rgt = '(' + rgt + ')'
        return lft + result + rgt

    def evaluate(self, variables): # Task B2
        if self.oper in OPERATORS_3:
            if self.oper== '*':
                return self.left.evaluate(variables)*self.right.evaluate(variables)
            elif self.oper == '/':
                d=self.right.evaluate(variables)
                if d != 0:
                    return self.left.evaluate(variables)/d
                else:
                    raise EvaluationError("Division by zero")
            elif self.oper == '//':
                d=self.right.evaluate(variables)
                if d != 0:
                    return self.left.evaluate(variables)//d
                else:
                    raise EvaluationError("Division by zero")
            elif self.oper == '%':
                d=self.right.evaluate(variables)
                if d != 0:
                    return self.left.evaluate(variables)%d
                else:
                    raise EvaluationError("Division by zero")
            elif self.oper == '**':
                return self.left.evaluate(variables)**self.right.evaluate(variables)
        elif self.oper in OPERATORS_2:
            if self.oper == '+':
                return self.left.evaluate(variables)+self.right.evaluate(variables)
            elif self.oper == '-':
                return self.left.evaluate(variables)-self.right.evaluate(variables)
        elif self.oper in variables:
            return variables[self.oper]
        else:
            if type(self.oper) in [int,float]:
                return self.oper
            else:
                raise EvaluationError(f"Undefined: {self.oper}")





class EvaluationError(Exception):
    def __init__(self, arg):
        self.arg = arg
        super().__init__(self.arg)


class SyntaxError(Exception):
    def __init__(self, arg):
        self.arg = arg
        super().__init__(self.arg)


def statement(wtok):
    result = assignment(wtok)
    if wtok.is_at_end() == False:
        raise SyntaxError('Unexpected token! Expected end of line.')
    return result


def assignment(wtok):
    result = expression(wtok)
    while wtok.get_current() == '=':
        wtok.next()
        if wtok.is_name():
            result = Node('=', 1, result, Node(wtok.get_current()))
        else:
            raise SyntaxError("Expected name after '=' ")
        wtok.next()
    return result


def expression(wtok):
    result = term(wtok)
    while wtok.get_current() in OPERATORS_2:
        oper = wtok.get_current()
        wtok.next()
        result = Node(oper, 2, result, term(wtok))
    return result


def term(wtok):
    result = factor(wtok)
    while wtok.get_current() in OPERATORS_3:
        oper = wtok.get_current()
        wtok.next()
        result = Node(oper, 3, result, term(wtok))
    return result


def factor(wtok):
    if wtok.get_current() == '(':
        wtok.next()
        result = assignment(wtok)
        if wtok.get_current() != ')':
            raise SyntaxError("Expected ')'")
        else:
            wtok.next()

    elif wtok.is_name():
        result = Node(wtok.get_current())
        wtok.next()

    elif wtok.is_number():
        value = float(wtok.get_current())
        if value.is_integer():
            value = int(value)
        result = Node(value)
        wtok.next()

    else:
        raise SyntaxError(
            "Expected number, word or '('")
    return result


def main():
    """
    Handles:
       the iteration over input lines, the command 'quit' and 
       catches raised exceptions.
    """

    print("\nA calculator")
    variables = {'pi': math.pi, 'e': math.e, 'ans': 0}
    init_file = 'm2b_init.txt'
    lines_from_file = ''
    try:
        with open(init_file, 'r') as file:
            lines_from_file = file.readlines()
    except FileNotFoundError:
        print('No init file found')

    while True:
        #line = input('\nInput    : ')
        if lines_from_file:
            line = lines_from_file.pop(0).strip()
            print('\nFrom file:', line)
        else:
            line = input('\nInput    : ')
        if line == '' or line[0] == '#':
            continue
        wtok = TokenizeWrapper(line)
        if wtok.get_current() == 'quit':
            print('Bye')
            exit()
        else:
            try:
                parsed = statement(wtok)
                print('Parsed   :', parsed)
                answer = parsed.evaluate(variables)
                variables['ans'] = answer
                print('Evaluated:', answer)

            except EvaluationError as ee:
                print("*** Evaluation error: ", ee)

            except SyntaxError as se:
                print("*** Syntax error: ", se)
                print(
                    f"Error occurred at '{wtok.get_current()}' just after '{wtok.get_previous()}'")

            except TokenError as te:
                print('*** Syntax error: Unbalanced parentheses')


if __name__ == "__main__":
    main()
