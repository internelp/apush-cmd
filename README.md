apush-cmd 是 APush 推送系统的命令行客户端。

## 获取

以 Linux x86_64 为例：

1. 访问 Release 获取对应系统和架构的程序：https://github.com/internelp/apush-cmd/releases
2. 下载 `Linux_x86_64_apush-cmd` 后重命名为 `apush-cmd`
3. 在系统中创建一个目录：`mkdir -p /usr/local/apush`
4. 将 `apush-cmd` 上传到 `mkdir -p /usr/local/apush` 目录中
5. 授予可执行权限 `chmod +x /usr/local/apush/apush-cmd`

## 使用说明

使用命令行操作（其他步骤相同），进入程序目录：

```
cd /usr/local/apush/
```

查看帮助信息

```
./apush-cmd --help

# 以下为命令行输出：

apush-cmd 是 APush 系统的命令行客户端

	apush-cmd push: 推送消息
	apush-cmd signup: 注册帐号
	apush-cmd signin: 登录系统获取令牌
	apush-cmd signout: 使系统令牌失效
	apush-cmd token: 获取推送令牌。

账户认证信息
-u, --username=<用户名>    用户名（注册和登录使用）
-p, --password=<密码>     密码（注册和登录使用）
-e, --email=<邮箱>        邮箱（注册使用）

使用APP申请令牌并设定有效期
    --app=<app_id>      APP 的标记 (com.example.appname)
    --days=<365>        令牌的有效期（天）
                        (defaults to "365")

推送消息
    --[no-]log          是否在服务器记录推送历史
                        (defaults to on)
    --title=<标题>        消息标题
    --subtitle=<副标题>    消息的副标题
    --body=<消息内容>       消息的内容
    --badge=<角标>        APP 角标数字
                        (defaults to "1")
    --group=<分组名>       通知中心消息分组名


-h, --help              显示帮助信息
```

## 创建推送帐号

请将 `nasctl` 替换为你的用户名，`mypassword` 替换为你的密码，`myemail@google.com` 替换为你的邮箱。

```
./apush-cmd signup -u nasctl -p mypassword -e myemail@google.com
```

```
开始注册用户...
ok
执行以下命令获取将系统TOKEN保存到本地（密码只在此显示一次，不会被保存）：
apush-cmd signin -u nasctl -p mypassword
```

## 登录帐号

```
./apush-cmd signin -u nasctl -p mypassword
```

```
开始登录，获取系统TOKEN...
登录成功，将TOKEN保存到文件：/usr/local/apush/.com.appgao.apush
成功，现在已经是登录状态。
```

## 获取推送令牌

推送令牌是用来向 APP 发送消息的凭证，输入的参数包括 APP ID（要推送的APP），令牌有效天数。

以下命令为 NASCTL 软件创建推送令牌，有效期 10 年（3650天）。

```
./apush-cmd token --app com.appgao.nasctl --days 3650
```

```
令牌申请成功，有效期 3650 天，将保存到文件：/usr/local/apush/.com.appgao.nasctl
成功，现在已经可以推送。
```

## 手机注册通知

以下步骤在手机中操作：
1. NASCTL——更多——消息通知——登录帐号（使用刚才注册时的信息）
2. 依次打开以下开关
   1. 通知权限
   2. 推送令牌
   3. 注册设备

执行完上述步骤后，APP 会将设备令牌（device token）发送给苹果和 APush 服务器。

在下个步骤中，消息将从你的命令行先发送给 APush 服务器，APush 服务器会根据你的帐号找到你的设备令牌，根据设备令牌将消息发送给苹果 APNs 服务器，APNs 服务器则根据设备令牌将消息转发到你的手机。

## 推送消息

使用下面命令可以推送消息，参数必须包含 `--app` 以确定推送目标 APP， `title` 或 `body` 二者中的一个作为消息内容，其他为可选项。

- badge：APP 图标角标
- group：相同的 group 会进行分组，内容为自定义文本。

**注意：仅当 APP 处于后台时，消息才会出现在通知中心，处于前台时，不会有任何提醒。**

```
./apush-cmd push --app com.appgao.nasctl --title "我是消息标题" --subtitle "我是副标题" --body "这里是消息内容。" --badge 1 --group "add"
```

```
推送成功：Message queued: 3dff797c-7e16-4184-b0be-ccefbe2387fc
```
## 使用 NASCTL 接收 qbitTorrent 消息

qBitTorrent 设置——选项——下载——运行外部程序

- 新增 torrent 时运行外部程序
  - /usr/local/apush/apush-cmd push --app com.appgao.nasctl --title "任务新增：%C files %Z bytes"  --body "%N"
- torrent 完成时运行外部程序
  - /usr/local/apush/apush-cmd push --app com.appgao.nasctl --title "任务完成：%C files %Z bytes"  --body "%N"

## 使用 NASCTL 接收 tranmission 消息
待补充

## 错误解决

1. 在docker 中运行时报错 `./apush-cmd: not found`
```
# ./apush-cmd 
sh: ./apush-cmd: not found
```
解决方法：只读映射 /lib64 目录至容器中。
```
/lib64/:/lib64/:ro
```

