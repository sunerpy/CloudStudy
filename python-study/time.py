# # 初始化计数器
# i = 1
# # 定义result，用于接收所有偶数的和
# result = 0
# # 编写循环条件
# while i <= 100:
#     # 将来写代码的位置
#     if i % 2 == 0:
#     # 代表变量i是一个偶数
#         result += i
#     # 更新计数器
#     i += 1
# print(f'1~100之间所有偶数的和：{result}')

# import random

# classRooms=[[],[],[]]
# teachers=[]
# #tmll
# #test merge
# teachers.extend('ABCDEFGH')
# for teacher in teachers:
#     randNum=random.randint(0, 2)
#     classRooms[randNum].append(teacher)
# print(classRooms)

# # 求集合中的交集、并集、差集
# s1 = {'刘备', '关羽', '张飞', '貂蝉'}
# s2 = {'袁绍', '吕布', '曹操', '貂蝉'}

# # 求两个集合中的交集
# print(s1 & s2)

# # 求两个集合中的并集
# print(s1 | s2)

# # 求连个集合中的差集
# print(s1 - s2)
# print(s2 - s1)

# 定义一个函数，拥有name参数，同时函数执行完毕后，拥有一个return返回值
# def greet(name):
#     # 执行一系列相关操作
#     return name + '，您好'

# # 调用函数
# # 见到了张老师，打一声招呼
# print(greet('老张'))  # 老张，您好
# # 见到了李老师，打一声招呼
# print("\033[0;31;40m\t" + greet('老李') + "\033[0m")
# # 见到了王老师，打一声招呼
# print("\033[0;36;40m\t" + greet('老王') + "\033[0m")

# def size(num1, num2):
#     jia = num1 + num2
#     jian = num1 - num2
#     cheng = num1 * num2
#     chu = num1 / num2
#     return jia, jian, cheng, chu


# # 调用size方法
# print(size(20, 5))


# # 1、定义一个menu菜单函数
# def menu():
#     pass

# # 2、定义通讯录增加操作方法
# def add_student():
#     """ 函数的说明文档：add_student方法不需要传递任何参数，其功能就是实现对通讯录的增加操作 """
#     pass

# # 3、定义通讯录删除操作方法
# def del_student():
#     pass

# # 4、定义通讯录修改操作方法
# def modify_student():
#     pass

# # 5、定义通讯录查询操作方法
# def find_student():
#     pass

# help(add_student)

# dict1 = {'name':'小明', 'age':18}
# # 拆包的过程（字典）
# a, b = dict1
# print(a)
# print(b)
# # 获取字典中的数据
# print(dict1[a])
# print(dict1[b])

# def func(*args, **kwargs):
#     print(args)
#     print(kwargs)


# # 定义一个元组（也可以是列表）
# tuple1 = (10, 20, 30)
# # 定义一个字典
# dict1 = {'first': 40, 'second': 50, 'third': 60}
# # 需求：把元组传递给*args参数，字典传递给**kwargs
# # ① 如果想把元组传递给*args，必须在tuple1的前面加一个*号
# # ② 如果想把字典传递给**kwargs，必须在dict1的前面加两个**号
# func(*tuple1, **dict1)

# #fbnq
# def recursive(n):
#     if n==1 or n==2:
#         return 1
#     elif n >=3:
#         fbnqdict={1:1,2:1}
#         for i in range(3,n+1):
#             fbnqdict[i]=fbnqdict[i-1]+fbnqdict[i-2]
#         return fbnqdict[n]
#     else:
#         print(f'Please recheck your input!')
# num=int(input('Please input a number which you want to get:'))
# recursive(num)

# nums = [1, 7, 3, 6, 5, 6]

# namete= 'te'
# class Solution:
#     def pivotIndex(self, nums: List[int]) -> int:
#         sums1 = sum(nums)
#         sums2 = 0
#         for i in range(len(nums)):
#             if sums1 - nums[i] == sums2:
#                 return i
#             sums1 -= nums[i]
#             sums2 += nums[i]
#         return -1
# p1=Solution()

# num_list = [i for i in range(1, 5)]
# final_num = []
# for a in num_list:
#     for b in num_list:
#         for c in num_list:
#             if a != b and b != c and a != c:
#                 final_num.append(a*100+b*10+c)
# final_num.sort()
# print(final_num)

# for m in range(1, 85):
#     for n in range(1, 85):
#         if (n ** 2 - m ** 2) == 168:
#             print(m ** 2 - 100,end='')
# print('')

# num_list=[(m**2-100) for m in range(1, 85) for n in range(1, 85) if (n**2 - m**2) == 168]
# print(num_list)


# # （1）输入某年某月某日，判断这一天是这一年的第几天。
# year = int(input('Please Input the year:'))
# month = int(input('Please Input the month:'))
# day = int(input('Please Input the day:'))
# totalnum = 0
# month_day = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
# if (year % 4 == 0 and year % 100 != 0) or year % 400 == 0:
#     month_day[1]=29
# for i in range(1,month):
#     totalnum += month_day[i-1]
# totalnum += day
# print(f'This is the {totalnum} day.')

# # （2）输入3个整数x、y、z，请把这3个数由小到大输出。
# x = int(input('x:'))
# y = int(input('y:'))
# z = int(input('z:'))
# list_nums = [x, y, z]
# list_nums.sort()
# print(list_nums)

# # （3）输出9×9乘法口诀表。
# for i in range(1,10):
#     for j in range(1,i+1):
#         print(f'{j}*{i}={i*j}',end='\t')
#     print()

# #（1）暂停一秒输出，并格式化当前时间。
# import time
# time.sleep(1)
# print(time.strftime("%Y-%m-%d %H:%M:%S" ,time.localtime(time.time())))


# #（2）古典问题：有一对兔子，从出生后第3个月起每个月都生一对小兔子，小兔子长到第三个月后每个月又生一对小兔子，假如兔子都不死，每个月的兔子总数为多少？
# #1,1,2,3,5,8...
# ###添加装饰器使用缓存???
# def rabbitsum(num):
#     if num ==1 or num ==2:
#         return 1
#     elif num >2:
#         return rabbitsum(num-1)+rabbitsum(num-2)

# print(rabbitsum(30))


# # （3）判断101～200之间有多少个素数，并输出所有素数
# import math
# numlist = []


# def numcheck(num1, num2):
#     count = 0
#     if num2 <= 2:
#         count = num2
#         return count

#     for nums in range(num1, num2):
#         tmp_num = round(math.sqrt(nums)+1)
#         for num in range(2, tmp_num):
#             if nums % num == 0:
#                 break
#         else:
#             numlist.append(nums)
#             count += 1
#     return count


# print(numcheck(101, 200),numlist,sep="\n")


# # （1）输出所有的“水仙花数”，所谓“水仙花数”是指一个3位数，其各位数字立方和等于该数本身。例如：153是一个“水仙花数”，因为153=1^3＋5^3＋3^3。
# def narcissisticnum():
#     narcissisticlist = []
#     for num in range(100, 1000):
#         hunnum = num//100
#         tennum = (num % 100)//10
#         onenum = num % 10
#         tmp_num = hunnum**3+tennum**3+onenum**3
#         if tmp_num == num:
#             narcissisticlist.append(num)
#     print(narcissisticlist)


# narcissisticnum()


# # （2）对于一个正整数分解质因数。例如：输入90，输出90=2*3*3*5。
# def getchildnum(num):
#     childlist = []
#     # step为2,因为所有2的倍数均不是质数?
#     dividenum = 2
#     i = 0
#     while num > 1:
#         if num % dividenum == 0:
#             num //= dividenum
#             childlist.append(dividenum)
#             if num == 1:
#                 break
#         else:
#             i += 1
#             dividenum = 2*i+1

#     print(f'{childlist}')


# originnum = int(input('Plese input a number which can return childnum: '))
# getchildnum(originnum)

# # def reduceNum(n):
# #     print ('{} = '.format(n), end=" ")
# #     if not isinstance(n, int) or n <= 0 :
# #         print ('请输入一个正确的数字 !')
# #         exit(0)
# #     elif n in [1] :
# #         print ('{}'.format(n))
# #     while n not in [1] : # 循环保证递归
# #         for index in range(2, n + 1) :
# #             if n % index == 0:
# #                 n //= index # n 等于 n//index
# #                 if n == 1:
# #                     print (index )
# #                 else : # index 一定是素数
# #                     print ('{} *'.format(index), end=" ")
# #                 break
# # reduceNum(1)

# # （3）输出第10个斐波那契数列。斐波那契数列（Fibonacci sequence），又称黄金分割数列，指的是这样一个数列：0，1，1，2，3，5，8，13，21，34，…。
# def fibonacci(num):
#     if num == 1 or num == 2:
#         return num-1
#     else:
#         return fibonacci(num-2)+fibonacci(num-1)


# print(fibonacci(10))

# # （4）利用条件运算符的嵌套来完成此题：高于90分的学习成绩用A表示，60分到89分之间的学习成绩用B表示，60分以下的学习成绩用C表示。
# def gradesection(grade):
#     if grade < 0 or grade > 100:
#         return False
#     else:
#         if grade >= 90:
#             gradephase = 'A'
#         elif grade >= 60:
#             gradephase = 'B'
#         else:
#             gradephase = 'C'

#     print(f'{gradephase}')


# gradesection(92)

# #（1）输出指定格式的日期，提示：使用datetime模块。
# import time
# print("当前时间戳：",time.time())
# print("获取当前本地时间：",time.localtime())
# print("格式化可读时间模式：",time.asctime())
# print("格式化日期:",time.strftime("%Y-%m-%d %H:%M:%S",time.localtime()))

# import datetime
# # 输出今日日期，格式为 dd/mm/yyyy。更多选项可以查看 strftime() 方法
# print(datetime.date.today().strftime('%d/%m/%Y'))
# print(datetime.datetime.now())

# # 创建日期对象
# miyazakiBirthDate = datetime.date(1941, 1, 5)
# print(miyazakiBirthDate.strftime('%d/%m/%Y'))

# # 日期算术运算
# miyazakiBirthNextDay = miyazakiBirthDate + datetime.timedelta(days=1)
# print(miyazakiBirthNextDay.strftime('%d/%m/%Y'))

# # 日期替换
# miyazakiFirstBirthday = miyazakiBirthDate.replace(
#     year=miyazakiBirthDate.year + 1)
# print(miyazakiFirstBirthday.strftime('%d/%m/%Y'))

# （2）输入一行字符，分别统计出其中英文字母、空格、数字和其他字符的个数。
def chrcount(originstr):
    alphacount = digitcount = spacount = othercount = 0
    for str0 in originstr:
        if str0.isalpha():
            alphacount += 1
        elif str0.isdigit():
            digitcount += 1
        elif str0.isspace():
            spacount += 1
        else:
            othercount += 1
    print(
        f'alpha:{alphacount} \ndigit:{digitcount}\nspace:{spacount}\nother:{othercount} ')


chrcount('originstr123  3@')

# （3）求s=a+aa+aaa+aaaa+aa......a的值，其中a是一个数字。例如2+22+222+2222+22222（此时共有5个数相加），相加的数字个数将由用户通过键盘输入来指定。


def strnumsum(num, count):
    numsum = 0
    for digitnum in range(1, count+1):
        for i in range(0, digitnum):
            numsum += num*10**i
    print(f'{numsum} ')


strnumsum(2, 3)

# （4）一个数如果恰好等于它的因子之和，这个数就称为“完数”。例如6=1＋2＋3。编程找出1000以内的所有完数。


def wholesum(rangenum):
    numlist = []
    for i in range(1, rangenum+1):
        numsum = 0
        for j in range(1, i//2+1):
            if i % j == 0:
                numsum += j
        if numsum == i:
            numlist.append(i)
    print(f'{numlist}')


wholesum(10000)


# （1）将一个列表的数据复制到另一个列表中。
def listcopy(list1):
    list2 = []
    for i in list1:
        list2.append(i)
    print(f'{list2} ')


list1 = [2, 3, 22, 1, 'test']
listcopy(list1)
# （2）一球从100m高度自由落下，每次落地后反跳回原高度的一半，再落下，那么它 在第10次落地时，共经过多少米？第10次反弹多高？


# （3）猴子吃桃问题：猴子第一天摘下若干个桃子，当即吃了一半，还不过瘾，又多 吃了一个；第二天早上又将剩下的桃子吃掉一半，又多吃了一个；以后每天早上都吃了前 一天剩下的一半零一个；到第10天早上想再吃时，见只剩下一个桃子了。求第一天共摘了 多少。

# （4）两个乒乓球队进行比赛，各出3人。甲队为a、b、c三人，乙队为x、y、z三人。 已抽签决定比赛名单。有人向队员打听比赛的名单。a说他不和x比，c说他不和x、z比， 请编程序找出3队赛手的名单。
