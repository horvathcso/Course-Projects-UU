""" 
File m4.py for exam 2022-10-28


Name: Csongor Horváth


"""
import random
import math
import json
import concurrent.futures as future
import time
# A7


def birthdays(n_people):
    '''Modify this method'''
    days = [random.randint(1,365) for _ in range(n_people)]
    return 1 if len(days) != len(list(set(days))) else 0

# A8


def birthdays_theoretical(n_people):
    '''Use this method if you have not solved A7'''
    return 1 if random.random() < 1-math.factorial(365)/math.factorial(365-n_people)/(365**n_people) else 0


def func(e):
    people=e[0]
    s = sum(map(birthdays, [people for _ in range(e[1])]))
    return (people,s/e[1])

def print_birthday_statistics(n_peoples, n_samples, n_processes):
    with future.ProcessPoolExecutor(n_processes) as exe:
        s = exe.map(func, [(people,n_samples) for people in n_peoples])
    exe.shutdown()
    for e in s:
        print(f"{e[0]}: {e[1]}")
    



# B4


def get_name(index):
    '''
    Example code how to extract a field (here 'name') for a person with index 'index' from customers.json file (index is 0,...,111 for the different people).
    '''
    with open('customers.json') as f:
        data = json.load(f)
        return data[index]['name']

def read_data(e):
    filename = e[0]
    index=e[1]
    with open('customers.json') as f:
        data = json.load(f)
        return (data[index]['favoriteFruit'],data[index]['gender'])

def print_favoriteFruits_per_gender(jsonfile, n, n_processes):
    with future.ProcessPoolExecutor(n_processes) as ex:
        r = ex.map(read_data, [(jsonfile, i) for i in range(n)])
    fruits_M={}
    fruits_W={}
    for e in r:
        if e[1] == 'male':
            if e[0] in fruits_M.keys():
                fruits_M[e[0]] += 1 
            else:
                fruits_M[e[0]] = 1
        else:
            if e[0] in fruits_W.keys():
                fruits_W[e[0]] += 1 
            else:
                fruits_W[e[0]] = 1
    print('\n-------\n female: \n -------')
    for k,e in fruits_W.items():
        print(f'{k}: {e}')
    print('-------\n male: \n -------')
    for k,e in fruits_M.items():
        print(f'{k}: {e}')
    print('-------')


    


if __name__ == '__main__':
    print('\n-------\nA7:\n-------')
    print(birthdays(5))   # most probably 0
    print(birthdays(23))  # about 50/50 0 or 1
    print(birthdays(100))  # most probably 1

    print('\n-------\nA8:\n-------')
    print_birthday_statistics(range(15, 30), 10000, 4)

    print('\n-------\nB4:\n-------')
    print_favoriteFruits_per_gender('customers.json', 112, 5)
