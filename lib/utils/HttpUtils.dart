import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:async';

/*
 * 封装 restful 请求
 *
 * GET、POST、DELETE、PATCH
 * 主要作用为统一处理相关事务：
 *  - 统一处理请求前缀；
 *  - 统一打印请求信息；
 *  - 统一打印响应信息；
 *  - 统一打印报错信息；
 */

class HttpUtils {
  /// global dio object
  static Dio dio;

  /// default options
  static const String API_PREFIX = 'http://192.168.0.108:8080';
  static const String URL = '/graphql';
  static const int CONNECT_TIMEOUT = 100000;
  static const int RECEIVE_TIMEOUT = 30000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  static Future<dynamic> uploadFile(String url, {data, callback}) async {
    var result;
    data = data ?? {};
    callback= callback?? {};

    var dio = createInstance();

    try {
      Response response = await dio.request(url,
          data: data,
          options: new Options(method: 'POST'),
          onSendProgress: callback);
      result = response.data;
    } on DioError catch (e) {
      print('请求出错：' + e.toString());
      throw e;
    }

    return result;
  }

  // 基于dio封装的http请求
  static Future<dynamic> request(String url, {data, method}) async {
    data = data ?? {};
    method = method ?? 'GET';

    Dio dio = createInstance();

    /// 打印请求相关信息：请求地址、请求方式、请求参数
    // print('请求地址：【' + dio.options.baseUrl + url + '】');
    // print('请求参数：' + data.toString());

    var result;

    try {
      Response response = await dio.request(url,
          data: data,
          options: new Options(method: method), onSendProgress: (a, b) {
        print(a);
        print(b);
      });
      result = response.data;

      // /// 打印响应相关信息
      // print('响应数据成功！');
    } on DioError catch (e) {
      /// 打印请求失败相关信息
      print('请求出错：' + e.toString());
    }

    return result;
  }

  /// 创建 dio 实例对象
  static Dio createInstance() {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions option = new BaseOptions(
          baseUrl: API_PREFIX,
          connectTimeout: CONNECT_TIMEOUT,
          receiveTimeout: RECEIVE_TIMEOUT,
          headers: {'Content-Type': 'application/json'},
          contentType: ContentType.json,
          responseType: ResponseType.plain);
      dio = new Dio(option);
    }

    return dio;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }
}
