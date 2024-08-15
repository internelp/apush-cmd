import 'dart:io';
import 'package:apush_cmd/global.dart';
import 'package:dio/dio.dart';
import 'dio.dart';
import 'fatal.dart';

/// 用户注册
signin({
  String? username,
  String? password,
}) async {
  if ((username ?? "").isEmpty) {
    fatal("用户名不可为空，使用 -u username 指定。");
  }
  if ((password ?? "").isEmpty) {
    fatal("密码不可为空，使用 -p password 指定。");
  }

  print("开始登录，获取系统TOKEN...");

  final payload = {
    "username": username,
    "password": password,
  };

  final dio = Dio(dioOpts);

  try {
    final response = await dio.post("/signin", data: payload);
    final path = "${dir.path}/.com.appgao.apush";
    final file = File(path);
    print("登录成功，将TOKEN保存到文件：$path");
    try {
      file.writeAsStringSync(response.data);
      print("成功，现在已经是登录状态。");
      exit(0);
    } catch (e) {
      fatal("保存 TOKEN 失败：$e");
    }
  } on DioException catch (e) {
    print("状态码：${e.response?.statusCode}");
    fatal("登录失败，请检查用户名或密码是否正确：${e.response?.data}");
  } catch (e) {
    fatal("网络错误：$e");
  }
}
