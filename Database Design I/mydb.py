from ctypes import FormatError
import mysql.connector
from numpy import empty
import os
clear = lambda: os.system('cls' if os.name=='nt' else 'clear') #lambda: os.system('cls')

def get_Department(depId):
    clear()
    if depId==0:
        print("Home page:")
        mycursor.execute("SELECT Description, Parentid FROM Department WHERE idDepartment="+str(depId))
        myres = mycursor.fetchall()        
        print(myres[0][0])
    else:
        mycursor.execute("SELECT Title, Description, Link, Parentid  FROM Department WHERE idDepartment = "+str(depId))
        myres = mycursor.fetchall() 
        print("Department of "+myres[0][0]+"\t  \t \t"+myres[0][2])
        print("\n"+myres[0][1])

    mycursor.execute("SELECT Title, ShortDescription, Link, idDepartment  FROM Department WHERE Parentid="+str(depId))
    myresult = mycursor.fetchall() 
    
    r={};p={}
    c=1; d=1
    for e in myresult:
        if c==1:
            print("\n \nSubdepartments:")
        if e[0] != "Home":
            print("("+str(c)+")\t"+"Department of "+e[0]+"\t"+e[2])
            print(e[1]+"\n")
            r[c]=e[3]
            c+=1

    mycursor.execute("SELECT Title, ShortDescription, Link, RetailPrice, Tax, Discount, idProduct  FROM Product WHERE DepartmentId="+str(depId) +" AND "+ "InStore = True")
    myresult = mycursor.fetchall()
    
    if d==1:
        print("\n \nProduct in department:")
    for e in myresult:
        print("("+str(c)+")\t"+e[0]+"\t link:"+str(e[2]))
        print("Current price: "+ str((e[3]+e[4])*(100-e[5])/100))
        print(e[1]+"\n")
        p[c]=e[6]
        c+=1
                    
    print("To go to link press it's reference numbers / To go parent press u / q to quit to main page:")    
    inp = input()
    if inp == "u" or inp =="U":
        get_Department(myres[0][-1])
    elif inp == "q" or inp =="Q":
        pass
    elif int(inp) in r.keys():
        get_Department(r[int(inp)])
    elif int(inp) in p.keys():
        get_Product(p[int(inp)])
    main()

def get_Product(prodid):
    clear()
    mycursor.execute("SELECT Title, Description, Link, RetailPrice, Tax, Discount, idProduct, DepartmentId  FROM Product WHERE idProduct="+str(prodid) +" AND "+ "InStore = True")
    myresult = mycursor.fetchall()
    e=myresult[0]
    print("Product page of: "+e[0]+"\t\t\t"+e[2])
    print("Curren price: "+str((e[3]+e[4])*(100-e[5])/100) ) 
    print(e[1]+"\n")
    print("To go to department page press u / quit to main page")
    inp = input()
    if inp == "u" or inp =="U":
        get_Department(e[-1])
    main()

def change_discount(prodid):
    clear()
    mycursor.execute("SELECT Title, Discount, idProduct FROM Product WHERE idProduct="+str(prodid))
    myresult = mycursor.fetchall() 
    e=myresult[0]
    print("The current discount to the product "+e[0]+" (product id: "+str(e[-1])+") is "+str(e[1])+"%")
    print("To change the discount value press c. Else quit")
    inp=input()
    if inp=="c" or inp =="C":
        print("Give the new discount value (integer between 0 and 100) / q to quit to main page:")
        inp=input()
        if inp == "q" or inp =="Q":
            pass
        else:
            try:
                d=int(inp)
                if d<=100 and d>=0:
                    mycursor.execute("UPDATE Product SET Discount = "+str(d)+" WHERE idProduct="+str(prodid))
                    mydb.commit()
                else:
                    raise FormatError("Not int between 0,100")
            except:
                pass
        main()
    else: main()
    
def main():
    clear()
    print("Welcome to the store of project group 23.\n To search products from home page press h\n To search department by id press s\n To modify discount press m \n To go to product page by product id press p \nPress q to quit")
    inp=input()
    if inp == "h" or inp == "H":
        get_Department(0)
    if inp == "s" or inp=="S":
        clear()
        print("Give a valid department id to go to its page:")
        inp=input()
        try:
            get_Department(int(inp))
        except:
            pass
    if inp == "m" or inp == "M":
        clear()
        print("Give a valid product id to modify it's discount:")
        inp=input()
        try:
            change_discount(int(inp))
        except:
            pass
    if inp == "p" or inp=="P":
        clear()
        print("Give a valid product id to go to its page:")
        inp=input()
        try:
            get_Product(int(inp))
        except:
            pass
    if inp == "q" or inp == "Q":
        return


group_number="23" #FILL IN YOUR GROUP NUMBER
mydb = mysql.connector.connect(
  host= "127.0.0.1", 
  user="ht22_1_group_"+group_number,
  passwd="pwd_"+group_number,
  database="ht22_1_project_group_"+group_number
)
mycursor = mydb.cursor()
main()
mydb.close()