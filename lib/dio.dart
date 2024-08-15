import 'package:dio/dio.dart';

final BaseOptions dioOpts = BaseOptions(
  baseUrl: "https://apush.appgao.com",
  validateStatus: (s) => s == 200,
  connectTimeout: Duration(seconds: 10),
);
