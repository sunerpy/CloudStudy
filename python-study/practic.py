# practic 1
# 练习一 变量的定义和使用
# 1. 定义两个变量分别为美元和汇率
# 2. 通过搜索引擎找到美元兑人民币汇率
# 3. 使用Python计算100美元兑换的人民币数量并用print( )进行输出
# dollar = 100
# exchange = 6.3981
# print("{dol} dollar can exchange {RMB} RMB.".format(dol=dollar, RMB=dollar*exchange))

# # 1. 定义一个字符串Hello Python 并使用print( )输出
# # 2. 定义第二个字符串Let‘s go并使用print( )输出
# # 3. 定义第三个字符串"The Zen of Python" -- by Tim Peters 并使用print( )输出
# string1="Hello Python"
# string2="Let's go"
# string3='"The Zen of Python" -- by Tim Peters'
# print(string1)
# print(string2)
# print(string3)


# 练习二 字符串基本操作

# 1. 定义两个字符串分别为 xyz 、abc
# 2. 对两个字符串进行连接
# 3. 取出xyz字符串的第二个和第三个元素
# 4. 对abc输出10次
# 5. 判断a字符（串）在 xyz 和 abc 两个字符串中是否存在，并进行输出
# str1='xyz'
# str2='abc'
# print(str1[1:2])
# print(str2*10)

# print(str1 if 'a' in str1 else 'a in not in str1')
# print(str1 if 'a' in str2 else 'a in not in str2')


# # # 练习三 列表的基本操作
# # 1. 定义一个含有5个数字的列表
# # 2. 为列表增加一个元素 100
# # 3. 使用remove()删除一个元素后观察列表的变化
# # 4. 使用切片操作分别取出列表的前三个元素，取出列表的最后一个元素.
# testa = [1, 5, 2, 3, 7]
# testa.append(100)
# print(testa)
# testa.remove(3)
# print(testa)
# print(testa[0:3])
# print(testa[-1])

# # 练习四 元组的基本操作
# 1. 定义一个任意元组，对元组使用append() 查看错误信息
# 2. 访问元组中的倒数第二个元素
# 3. 定义一个新的元组，和 1. 的元组连接成一个新的元组
# 4. 计算元组元素个数
testa = (5, 3, 77, 120)
# testa.append(100)
print(testa[-2])
testb = ('x', 'y', 'z', 45)
print(testa+testb)
print(testa)
print(testb)
print(len(testa))
print(testa.__len__())
