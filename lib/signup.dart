import 'dart:io';
import 'package:dio/dio.dart';
import 'dio.dart';
import 'fatal.dart';

/// 用户注册
signup({
  String? username,
  String? password,
  String? email,
}) async {
  if ((username ?? "").isEmpty) {
    fatal("用户名不可为空，使用 -u username 指定。");
  }
  if ((password ?? "").isEmpty) {
    fatal("密码不可为空，使用 -p password 指定。");
  }
  if ((email ?? "").isEmpty) {
    fatal("邮箱不可为空，使用 -e myname@example.com 指定。");
  }

  print("开始注册用户...");

  final payload = {
    "username": username,
    "password": password,
    "email": email,
  };

  final dio = Dio(dioOpts);

  try {
    final response = await dio.post("/signup", data: payload);
    print(response.data);
    print("执行以下命令获取将系统TOKEN保存到本地（密码只在此显示一次，不会被保存）：");
    print("apush-cmd signin -u $username -p $password");
    exit(0);
  } on DioException catch (e) {
    print("状态码：${e.response?.statusCode}");
    fatal("注册失败：${e.response?.data}");
  } catch (e) {
    fatal("网络错误：$e");
  }
}
