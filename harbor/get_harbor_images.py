import json

with open('/home/admin/gitcode/harbor/txt.json') as recordjs:
    content=recordjs.read()

str_json=json.loads(content) 
print(json.dumps(str_json, sort_keys=True, indent=4, separators=(',', ':'), ensure_ascii=False))


if __name__ == '__main__':
   pass
