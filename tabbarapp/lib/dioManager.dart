import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:convert';

const String GET = "get";
const String POST = "post";
const String DATA = "data";
const String CODE = "code";

const String HOST = "https://bo.kuangsky.com";
const int CONNECT_TIMEOUT = 10000;
const int RECEIVE_TIMEOUT = 3000;
//final ContentType CONTENT_TYPE = ContentType.json;

class HttpUtil {
//写一个单例
  //在 Dart 里，带下划线开头的变量是私有变量
  static HttpUtil _instance;
  //抓包的ip地址
  String ip = "192.168.101.13:8888";

  Dio dio;
  BaseOptions orgOption;

  static HttpUtil getInstance() {
    if (_instance == null) {
      _instance = HttpUtil();
    }
    return _instance;
  }

  HttpUtil() {
    orgOption = BaseOptions(
        //contentType: CONTENT_TYPE,
        // 请求格式
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        baseUrl: HOST,
        headers: {"v": "1.3.1", "type": "ios"});
    dio = new Dio(orgOption);

    /// 设置这个才可以抓包
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   //错误证书不处理
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   client.findProxy = (uri) {
    //     //proxy all request to localhost:8888
    //     return "PROXY $ip";
    //   };
    // };
  }

  //get请求
  get(String url, Map<String, dynamic> params, Function successCallBack,
      Function errorCallBack) async {
    _requstHttp(url, successCallBack, GET, params, errorCallBack);
  }

  //post请求
  post(String url, params, Function successCallBack,
      Function errorCallBack) async {
    _requstHttp(url, successCallBack, POST, params, errorCallBack);
  }

  _requstHttp(String url, Function successCallBack,
      [String method, Map<String, dynamic> params, Function errorCallBack]) async {
    //String errorMsg = '';
    int code;
    Response response;
    try {
      if (method == GET) {
        if (params != null && params.isNotEmpty) {
          response = await dio.get(url, queryParameters: params);
        } else {
          response = await dio.get(url);
        }
      } else if (method == POST) {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      }

      code = response.statusCode;

      /// 请求的基类数据结构 code 和message
      HttpIOException errorEntity = HttpIOException.fromJson(response.data);

      if (code == 200) {
        String dataStr = json.encode(response.data);
        Map<String, dynamic> dataMap = json.decode(dataStr);
        if (dataMap == null || dataMap[CODE] == 0) {
          _error(errorCallBack, errorEntity);
          print("请求失败，响应码${response.statusCode}");
        } else if (successCallBack != null) {
          print("请求成功，响应码${response.statusCode}");
          successCallBack(dataMap[DATA]);
        }
      } else {
        print("请求失败，响应码${response.statusCode}");
        _error(errorCallBack, errorEntity);
      }
    } on DioError catch (error) {
      //_error(errorCallBack, error.toString());
      HttpIOException errorEntity1 = HttpIOException(404, "网络异常,请检查网络连接");
      _error(errorCallBack, errorEntity1);
    }
  }

  _error(Function errorCallBack, HttpIOException error) {
    // Fluttertoast.showToast(
    //     msg: error.toString(),
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER);
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }
}

class HttpIOException {
  int code;
  String message;

  ///构建
  HttpIOException(this.code, this.message);
  HttpIOException.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }
}
