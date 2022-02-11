[toc]



这是一个用于QQ群的人工智障机器人.
是的,没错,称它为一个"人工智障",是因为它经常做出一些智障行为...



> 此文用到的项目
>
> - [MiraiGo](https://github.com/Mrs4s/MiraiGo)
> - [go-cqhttp](https://github.com/Mrs4s/go-cqhttp)
> - [XZZ](https://github.com/Si-Huan/XZZ)

## 准备工作

### 安装 Python 环境并克隆 XZZ

> 因为机器人的逻辑部分，也就是 XZZ 是 Python 写的，所以需要 Python 环境

在 centos 中，安装 python

```
yum install -y python38.x86_64
```

克隆 XZZ

```
git clone https://github.com/Si-Huan/XZZ.git
```

### 编译或下载 go-cqhttp

#### 编译

克隆仓库

```
git clone https://github.com/Mrs4s/go-cqhttp.git
```

编译

```
cd go-cqhttp && go build
```

> tips: 自备 go 环境

#### 下载

前往 [Releases 页面](https://github.com/Mrs4s/go-cqhttp/releases) 下载自己系统对应的版本

### 安装并启动 Redis 数据库 （可选）

> 可选但推荐，不然可能有一些服务无法使用

在 centos 下

```
sudo pacman -S redis
sudo systemctl enable redis.service --now
```

> tips: 请保持 redis 服务运行在 XZZ 同服务器 6379 端口

## 开始配置

我们假设你现在的目录结果如下

```
.
├── bot
│   └── go-cqhttp
└── xzz
    ├── exmple.json
    ├── main.py
    ├── README.md
    ├── req.txt
    ├── route.py
    ├── sample_config.py
    ├── test.py
    ├── worker
    └── zzcore.py
```

其中 `xzz` 文件夹下是你第一步克隆的 XZZ

其中 `bot` 文件夹下的 `go-cqhttp` 是你在第一步下载或编译的 go-cqhttp 的可执行文件

### 初始化并配置 go-cqhttp

移步至 `bot` 文件夹下启动 `go-cqhttp`

你会看到以下信息，程序会自动退出

```
[2020-08-02 22:25:17] [WARNING]: 尝试加载配置文件 config.json 失败: 文件不存在 
[2020-08-02 22:25:17] [INFO]: 默认配置文件已生成, 请编辑 config.json 后重启程序.
```

现在你的目录结果大概是这样

```
.
├── bot
│   ├── config.json
│   ├── data
│   ├── go-cqhttp
│   └── logs
└── xzz
    ├── exmple.json
    ├── main.py
    ├── README.md
    ├── req.txt
    ├── route.py
    ├── sample_config.py
    ├── test.py
    ├── worker
    └── zzcore.py
```

我们去编辑 `./bot/config.json`

```
{
    "uin": 1010101010,
    "password": "mima",
    "enable_db": true,
    "access_token": "token",
    "relogin": false,
    "relogin_delay": 0,
    "http_config": {
        "enabled": true,
        "host": "127.0.0.1",
        "port": 5700,
        "post_urls": {"127.0.0.1:5580":"XZZ"}
    },
    "ws_config": {
        "enabled": false,
        "host": "0.0.0.0",
        "port": 6700
    },
    "ws_reverse_servers": [{
        "enabled": false,
        "reverse_url": "ws://you_websocket_universal.server",
        "reverse_api_url": "ws://you_websocket_api.server",
        "reverse_event_url": "ws://you_websocket_event.server",
        "reverse_reconnect_interval": 3000
    }],
    "debug": false
}
```

需要编辑的字段如下

| 字段                      | 类型   | 说明                                    |
| :------------------------ | :----- | :-------------------------------------- |
| uin                       | int64  | 登录用 QQ 号                            |
| password                  | string | 登录用密码                              |
| access_token              | string | 用于与 XZZ 交互是身份认证               |
| http_config               | object | HTTP API 配置，可与上面我给出的配置一致 |
| ws_config.enable          | bool   | XZZ 不需要用到 ws， 请设置为 false      |
| ws_reverse_servers.enable | bool   | 同上，设置为 false                      |

一会配置 XZZ 需要用到的字段有 `access_token` 、 `http_config.host` 、 `http_config.port` 、 `http_config.post_urls`

如果 `go-cqhttp` 与 `XZZ` 没有运行在同一台服务器上请将 `http_config.host` 设置为 `0.0.0.0` ，`http_config.post_urls` 设置为 `XZZ` 运行时监听的端口

配置完成之后我们就可以启动 `go-cqhttp` 了，启动的时候第一次登陆 QQ 可能需要验证码，按字符画输入即可，之后将 `go-cqhttp` 切到后台，进行下一步。

> 可以使用如 **screen** 这种工具将 `go-cqhttp` 挂在后台

### 配置 XZZ

移步至 `xzz` 文件夹下

创建虚拟环境

```
python -m venv env
```

激活虚拟环境

```
source ./env/bin/activate
```

安装依赖

```
pip install -r req.txt
```

配置 XZZ

复制一份 `sample_config.py` 到 `config.py`，并编辑

```
ALLWORKERS = ['bbc','bc','bing','echo','mc','music','ping','shi','wolfram','yiyan','help']

APIURL = 'http://127.0.0.1:5700/'

AUTHORIZATION = 'token'

PORT = 5580

BINGKEY = ''

WOLFRAMALPHAAPPID = ''

LOLIKEY = ''
```

以上必须要配置的有

- `APIURL` 为上文 **go-cqhttp** HTTP API 所在的地址，与上文 `http_config.host` 、 `http_config.port` 有关，如果上面这两个和我设置的一样，那么这儿为 `127.0.0.1:5700`
- `AUTHORIZATION` 与上文 `access_token` 相同，这儿为 `token`
- `PORT` **XZZ** 要监听的端口，这儿设置为 `5580` ，请保证上文 `http_config.post_urls` 中的端口与此一致，以便 **go-cqhttp** 可以访问到 **XZZ**

其余参数可选

- `ALLWORKERS` 使用 `/help` 命令时所列出的项目
- `BINGKEY` 如需要使用 `/bing` 命令必须添加，申请地址 （以后加）
- `WOLFRAMALPHAAPPID` 如需要使用 `/wolfram` 命令必须添加，申请地址 （以后加）
- `LOLIKEY` 如需要使用 `/pixiv` 命令必须添加，申请地址 （以后加）

配置完毕之后，启动 XZZ

```
python main.py
```

和上文 对 go-cqhttp 的处理一样，挂在后台就好了

### 测试！

在群聊发生 `/ping` ，bot 是不是回复了 `Pong` 呢？

## 另外

XZZ 功能的开发超级方便，如果有兴趣的话，欢迎来给 XZZ 添加功能 ~

https://github.com/Si-Huan/XZZ