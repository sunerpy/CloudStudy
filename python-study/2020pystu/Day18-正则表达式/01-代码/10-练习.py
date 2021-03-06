import re

# \d+ \.?  \d+

# 判断用户输入的内容是否是数字，如果是数字转换成为数字类型
num = input('请输入一段数字:')
if re.fullmatch(r'\d+(\.\d+)?', num):
    print('是个数字')
    print(float(num))
else:
    print('不是一个数字')

# 以非数字开头，后面有 字母数字_-组成的长度4到14位的字符串
# r'^\D[a-z0-9A-Z_\-]{3,13}'

# r'^([A-Za-z0-9_\-\.])+@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$'

# r'^((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(18[05-9]))\d{8}$'

# 1XXXXX ~ 9XXXXX  1800~2099   01~09 | 10|11|12   01~29除去10 20 |10|20|30|31 734 X
#      420606      20    19           09              2     3                398   8
r'^[1-9]\d{5}(18|19|20|)\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$'

r'^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$'
