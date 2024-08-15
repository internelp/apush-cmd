import 'dart:io';

import 'package:apush_cmd/fatal.dart';
import 'package:args/args.dart';
import 'package:dio/dio.dart';

import 'dio.dart';
import 'global.dart';

/// 推送消息
push(ArgResults args) async {
  final String appid = args["app"] ?? "";
  if (appid.isEmpty) {
    fatal("APPID 不可为空，使用 --app com.example.app 指定。");
  }

  if (args["title"] == null && args["body"] == null) {
    fatal("标题和消息内容不可同时为空。");
  }

  // 验证是否有推送令牌
  final appPath = "${dir.path}/.$appid";
  final appFile = File(appPath);
  if (!appFile.existsSync()) {
    fatal("推送令牌文件不存在：${appFile.path}，请先生成令牌。");
  }
  final token = appFile.readAsStringSync();
  if (token.isEmpty) {
    fatal("推送令牌文件为空：${appFile.path}，请先生成令牌。");
  }

  final dio = Dio(dioOpts);
  dio.options.headers.addAll({"Authorization": "Bearer $token"});

  final payload = {
    "log": args["log"],
    "msg": {
      if (args["title"] != null) "title": args["title"],
      if (args["subtitle"] != null) "subtitle": args["subtitle"],
      if (args["body"] != null) "body": args["body"],
      if (args["badge"] != null) "badge": int.tryParse(args["badge"]) ?? 0,
      if (args["group"] != null) "group": args["group"],
    }
  };

  try {
    final response = await dio.post("/push", data: payload);
    print("推送成功：${response.data}");
  } on DioException catch (e) {
    print("状态码：${e.response?.statusCode}");
    fatal("推送失败：${e.response?.data}");
  } catch (e) {
    fatal("网络错误：$e");
  }
}
