import 'dart:io';

import 'package:apush_cmd/fatal.dart';
import 'package:apush_cmd/global.dart';
import 'package:apush_cmd/push.dart';
import 'package:apush_cmd/signin.dart';
import 'package:apush_cmd/signup.dart';
import 'package:apush_cmd/token.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addSeparator("apush-cmd 是 APush 系统的命令行客户端")
    ..addSeparator("\tapush-cmd push: 推送消息\n\tapush-cmd signup: 注册帐号\n\tapush-cmd signin: 登录系统获取令牌\n\tapush-cmd signout: 使系统令牌失效\n\tapush-cmd token: 获取推送令牌。")
    ..addCommand("push")
    ..addCommand("signup")
    ..addCommand("signin")
    // ..addCommand("signout")
    ..addCommand("token")
    // ..addOption('command',
    //     abbr: 'a', defaultsTo: 'push', valueHelp: "动作", help: '动作列表：\npush: 推送消息\nsignup: 注册帐号\nsignin: 登录系统获取令牌\nsignout: 使系统令牌失效\ntoken: 获取推送令牌')
    ..addSeparator("账户认证信息")
    ..addOption('username', abbr: 'u', valueHelp: "用户名", help: '用户名（注册和登录使用）')
    ..addOption('password', abbr: 'p', valueHelp: "密码", help: '密码（注册和登录使用）')
    ..addOption('email', abbr: 'e', valueHelp: "邮箱", help: '邮箱（注册使用）')
    ..addSeparator("使用APP申请令牌并设定有效期")
    ..addOption('app', valueHelp: "app_id", help: 'APP 的标记 (com.example.appname)')
    ..addOption('days', valueHelp: "365", help: '令牌的有效期（天）', defaultsTo: "365")
    ..addSeparator("推送消息")
    ..addFlag("log", help: "是否在服务器记录推送历史", defaultsTo: true)
    ..addOption('title', valueHelp: "标题", help: '消息标题')
    ..addOption('subtitle', valueHelp: "副标题", help: '消息的副标题')
    ..addOption('body', valueHelp: "消息内容", help: '消息的内容')
    ..addOption('badge', valueHelp: "角标", help: 'APP 角标数字', defaultsTo: "1")
    ..addOption('group', valueHelp: "分组名", help: '通知中心消息分组名')
    ..addSeparator("")
    ..addFlag('help', abbr: 'h', negatable: false, help: '显示帮助信息');

  late ArgResults args;
  try {
    args = parser.parse(arguments);
  } on FormatException catch (e) {
    fatal("参数错误：${e.message}");
  } catch (e) {
    fatal("参数错误：$e");
  }

  if (args['help']) {
    print(parser.usage);
    return;
  }
  dir = Directory(Platform.script.toFilePath()).parent;

  switch (args.command?.name) {
    case "signup":
      signup(username: args["username"], password: args["password"], email: args["email"]);
      break;
    case "signin":
      signin(username: args["username"], password: args["password"]);
      break;
    case "token":
      token(appid: args["app"], days: args["days"]);
      break;
    case "push":
      push(args);
      break;
    default:
      print("错误的命令名称：\n\tpush: 推送消息\n\tsignup: 注册帐号\n\tsignin: 登录系统获取令牌\n\tsignout: 使系统令牌失效\n\ttoken: 获取推送令牌。");
      print("也可访问此网址获取使用说明：https://www.appgao.com/");
  }
}
