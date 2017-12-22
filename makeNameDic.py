#!/usr/bin/env python2

# use including_lib an


#f1="/home/zhc268/data/outputs/setQCs/Set_14/def533d6c7086be1ffafe6eb9fc8a7a1/including_libs.txt"
#f2="/home/zhc268/data/outputs/setQCs/Set_14/def533d6c7086be1ffafe6eb9fc8a7a1/sample_table.csv"


#f1="/home/zhc268/data/outputs/setQCs/Set_13/f1202a0987f25537b6cf57a7621d88c6/including_libs.txt"
#f2="/home/zhc268/data/outputs/setQCs/Set_13/f1202a0987f25537b6cf57a7621d88c6/sample_table.csv"

f1="/home/zhc268/data/outputs/setQCs/Set_15/b067ca9ab178a8ba8c034de878d03081/including_libs.txt"
f2="/home/zhc268/data/outputs/setQCs/Set_15/b067ca9ab178a8ba8c034de878d03081/sample_table.csv"

#f1="/home/zhc268/data/outputs/setQCs/Set_17/a35857a37df62337a3d77bced16409b7/including_libs.txt"
#f2="/home/zhc268/data/outputs/setQCs/Set_17/a35857a37df62337a3d77bced16409b7/sample_table.csv"


a={}

with open(f1,"r") as fp:
    for line in fp:
        b=line.strip('\n').split()
        a[b[0]]=b[1]

a2={}
ln=0
with open(f2,"r") as fp:
    for line in fp:
        if (ln >0):
            b=line.strip('\n').split(',')
            print b
            a2[b[2]]=b[-3]
        ln+=1

with open("/home/zhc268/convert.txt","w") as fp:
    for k in a.keys():
        print k,a2[a[k]]
        fp.write("%s\t%s\n" % (k,a2[a[k]]))

