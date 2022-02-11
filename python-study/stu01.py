# 9*9 
m = 1
n = 1
while n<10 :
    while m <= n :
        print(f'{m}*{n}={m*n}',sep='',end='\t' )
        m += 1
    m = 1
    n += 1
    print()