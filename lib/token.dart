import 'dart:io';

import 'package:dio/dio.dart';

import 'dio.dart';
import 'fatal.dart';
import 'global.dart';

/// 生成推送token
token({String? appid, String? days}) async {
  if ((appid ?? "").isEmpty) {
    fatal("APPID 不可为空，使用 --app com.example.app 指定。");
  }

  int daysInt = 365;
  try {
    daysInt = int.parse(days ?? "days");
  } catch (e) {
    if (e is FormatException) {
      fatal("令牌有效期输入错误：${e.message}");
    } else {
      fatal("令牌有效期输入错误：$e");
    }
  }

  final dio = Dio(dioOpts);
  final path = "${dir.path}/.com.appgao.apush";
  final file = File(path);
  if (!file.existsSync()) {
    fatal("系统令牌文件不存在：${file.path}，请先登录。");
  }
  final token = file.readAsStringSync();
  if (token.isEmpty) {
    fatal("系统令牌文件为空：${file.path}，请先登录。");
  }
  dio.options.headers.addAll({"Authorization": "Bearer $token"});

  try {
    final response = await dio.get("/token/$appid/$daysInt");
    final appPath = "${dir.path}/.$appid";
    final appFile = File(appPath);
    print("令牌申请成功，有效期 $days 天，将保存到文件：$appPath");
    try {
      appFile.writeAsStringSync(response.data);
      print("成功，现在已经可以推送。");
      exit(0);
    } catch (e) {
      fatal("保存 TOKEN 失败：$e");
    }
  } on DioException catch (e) {
    print("状态码：${e.response?.statusCode}");
    fatal("签发推送令牌失败，请重新登录后尝试。：${e.response?.data}");
  } catch (e) {
    fatal("网络错误：$e");
  }
}
