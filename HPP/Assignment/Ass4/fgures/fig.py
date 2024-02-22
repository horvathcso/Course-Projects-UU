import matplotlib.pyplot as plt
import numpy as np


#data=np.array([58.418, 29.223, 19.496, 14.631, 11.706, 9.785, 8.380, 8.124, 12.086, 11.795, 11.179, 12.048, 12.833, 13.364, 13.977, 14.423])
data=np.array([2.336, 1.183, 0.990, 0.922, 0.725, 0.778, 0.769, 0.725, 0.776, 0.725, 0.780, 0.797, 0.962, 0.833, 0.988, 1.380])
thread=np.arange(1,len(data)+1,1)

thread2=np.arange(1,len(data)+1,1)
data2=[]
for i in thread2:
    data2.append(data[0]/i)
data2=np.array(data2)

plt.plot(thread, data, 'bs', thread2, data2, 'r--')
plt.ylabel("time (s)")
plt.xlabel("Nr of threads")
plt.title("Run time measurements (s)")
plt.legend(["measured time","ideal speedup"])
plt.savefig('openmp100.png', dpi=600)