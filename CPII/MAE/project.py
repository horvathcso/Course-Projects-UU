#TA name: Sven-Erik
# DATE: 2022.10.17.


from turtle import width
import numpy as np
from subprocess import call
import tkinter as tk
from tkinter import END, messagebox
import random
from itertools import combinations

class Ball():
    def __init__(self,x,y,vx,vy,r,col,canvas):
        self.x=x
        self.y=y
        self.vx=vx
        self.vy=vy
        self.r=r
        self.col=col
        self.bal=canvas.create_oval(self.x-self.r, self.y-self.r, self.x+self.r, self.y+self.r,fill=self.col)

    def move(self):
        global t, canvas, infect, balls, gravity
        self.x += t/100*self.vx
        self.y += t/100*self.vy
        if gravity==True:
            self.vy += t/10
        canvas.move(self.bal, t/100*self.vx, t/100*self.vy)
        if infect==True and self.col=='red' and random.randint(1,10000)==1:
            canvas.delete(self.bal)
            balls.remove(self)


    def wall(self,width,height):
        if (self.x-self.r <= 0 and self.vx < 0) or (self.x+self.r>= width and self.vx>0):
            self.vx= -self.vx
        if (self.y-self.r <= 0 and self.vy<0)or (self.y+self.r>= height and self.vy>0):
            self.vy= -self.vy
            if (self.y+self.r>= height ) and gravity ==True:
                self.vy *=0.9
            
    def collide(self,other):
        global infect,canvas
        if ((self.x-other.x)**2+(self.y-other.y)**2 <= (self.r+other.r)**2):
            v_i=np.array([self.vx,self.vy])
            v_j=np.array([other.vx,other.vy])
            s_i=np.array([self.x,self.y])
            s_j=np.array([other.x,other.y])
            if np.dot((s_i-s_j),v_i)-np.dot((s_i-s_j),v_j)<0:
                v2i=v_i+(s_j-s_i)*sum((v_j-v_i)*(s_j-s_i))/sum((s_j-s_i)*(s_j-s_i))
                v2j=v_j+(s_j-s_i)*sum((v_i-v_j)*(s_j-s_i))/sum((s_j-s_i)*(s_j-s_i))
                self.vx=v2i[0]
                self.vy=v2i[1]
                other.vx=v2j[0]
                other.vy=v2j[1]
                if self.col=='red' or other.col=='red' and random.randint(1,100)==1:
                    self.set_col('red')
                    other.set_col('red')
                if  infect==True and self.col =='blue' and other.col=='blue' and random.randint(1,10)==1:
                    balls.append(Ball((self.x+other.x)/2,(self.y+other.y)/2,(self.vx+other.vx)/2,(self.vy+other.vy)/2, random.randint(1,5),'blue',canvas ))
                    

    def is_col(self, other):
        global width, height
        if (self.x-other.x)**2+(self.y-other.y)**2 <= (self.r+other.r)**2:
            return True
        elif self.x-self.r<=0 or self.x+self.r>=width or self.y-self.r<=0 or self.y+self.r>=height:
            return True
        else: return False

    def set_col(self, col):
        self.col= col
        canvas.itemconfig(self.bal,fill=col)


def call():
    global balls, width, height, t, run,  l0
    l0.config(text=f"The current nr of ball: {len(balls)}")
    if run == True:
        for b in balls:
            b.move()
            b.wall(width,height)
        for b1,b2 in combinations(balls,2):
            b1.collide(b2)
    canvas.after(t, call)


def func(bol):
    global balls, e1,e2, canvas, run,t, started, infect
    if bol==True or (started==False):
        nr=int(e1.get())
        t=int(e2.get())
        balls=[]
        canvas.delete("all")
        infection=False
        for _ in range(nr):
            collide = True
            c=1
            while collide != False:
                b1 =Ball(random.randint(50, 450),random.randint(50, 450),random.randint(10, 50),random.randint(10, 50),random.randint(10, 100)/c,"blue",canvas)
                collide=False
                for b2 in balls:
                    if b1.is_col(b2) == True:
                        collide=True
                        canvas.delete(b1.bal)
                c *= 2
            balls.append(b1)
        run=True
        started=True
    if started==True and run==False:
        run=True

def stop():
    global run
    run=False

def infection():
    global infect
    balls[0].set_col('red')
    infect=True

def grav():
    global gravity
    if gravity==False:
        gravity=True
    else:
        gravity=False
        

def help():
    return messagebox.showinfo('Help box','With this program you can simulate balls bouncing to each other and an epidemic between them by pressing the infection button. This start their reproduction processes and a mortal infection spreading among them. You can add an easy modell of gravity to the modell. \n The stats: probability of reproduction is 1/10, probability of infection is 1/10, probability of death is 1/10000 in every t timestep if someone is infected')


root = tk.Tk()
root.title('PythonGuides')
root.geometry('700x600')
root.config(bg='#345')

balls=[]
run=False
started=False
t=10
infect=False
gravity=False

width = 500
height = 500
canvas = tk.Canvas(root, bg='white', width=width, height=height)
canvas.pack()

b0 =tk.Button(root, text="Exit", command = root.destroy)
b1 =tk.Button(root, text="Restart", command = lambda: func(True))
b2 =tk.Button(root, text="Start/Continue", command= lambda: func(False))
b3 =tk.Button(root, text="Stop", command=stop)
b4 = tk.Button(root, text="Start infection", command=infection)
b5 = tk.Button(root, text="Gravity on/off", command=grav)
b6 = tk.Button(root, text="Help", command=help)
b0.place(x=10,y=10)
b1.place(x=10,y=40)
b2.place(x=10,y=70)
b3.place(x=10,y=100)
b4.place(x=10,y=130)
b5.place(x=10, y=160)
b6.place(x=10,y=190)


l0=tk.Label(text= f"The current nr of ball: {len(balls)}")
l0.pack()
l1=tk.Label(text="Nr of ball between 1, 50")
l1.pack()
e1=tk.Entry()
e1.insert(END,"2")
e1.pack()

l2=tk.Label(text="Timesteps ms")
l2.pack()
e2 = tk.Entry()
e2.insert(END,"1")
e2.pack()



call()
root.mainloop()


