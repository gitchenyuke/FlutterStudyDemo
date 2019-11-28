import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'lxhentity.dart';
import 'dioManager.dart';

class RequestData extends StatefulWidget {
  @override
  _LoadingDialog createState() => _LoadingDialog();
}

class _LoadingDialog extends State<RequestData> {
  String contentmm = "未开始请求";
  //抓包的ip地址
  String ip = "192.168.101.13:8888";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("网络请求"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200.0,
              height: 200.0,
              color: Colors.red,
              child: MaterialButton(
                textColor: Colors.white,
                minWidth: 100.0,
                height: 40.0,
                child: Text("开始请求网络"),
                color: Colors.blue,
                onPressed: () {
                  /// 监听
                  setState(() {
                    contentmm = "开始请求...";
                  });
                  //getDio();
                  getHttp();
                  //getFilmList();
                },
              ),
            ),
            Text('$contentmm'),
          ],
        ),
      ),
    );
  }

  /// 原生网络请求
  void getFilmList() async {
    print('------loadData_sys_post--------');

    HttpClient httpClient = new HttpClient();

    /// 设置这个才可以抓包
    httpClient.findProxy = (url) {
      return HttpClient.findProxyFromEnvironment(url, environment: {
        "http_proxy": '$ip',
      });
    };

// queryParameters get请求的查询参数(适用于get请求？？？是吗？？？)
    Uri url = Uri(scheme: "https", host: "bo.kuangsky.com", path: 'api/news');
    HttpClientRequest request = await httpClient.postUrl(url);

// 设置请求头
    // request.headers.set("loginSource", "IOS");
    // request.headers.set("useVersion", "3.1.0");
    // request.headers.set("isEncoded", "1");
    // request.headers.set("bundleId", "com.nongfadai.iospro");
// Content-Type大小写都ok
    // request.headers.set('content-type', 'application/json');
    request.headers.contentType =
        ContentType.parse("application/x-www-form-urlencoded");

    /// 添加请求体
    Map params = {
      'province': '广东省',
      'city': '广州市',
      'pageIndex': '1',
      'pageSize': '2'
    };

    /// 可变请求体
    // Map<String, String> map1 = new Map();
    // map1["pageIndex"] = "1";
    // map1["pageSize"] = "2";

    ///TODO:原生post请求怎么传递参数?
    request.add(utf8.encode(json.encode(params)));

    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode == HttpStatus.ok) {
      print('请求成功');
      print(response.headers);
      print(params);
      print(responseBody);
    } else {
      print("请求失败");
    }
  }

  //封装的网络请求
  void getHttp() {
    FormData params = FormData.from({"pageIndex": "1", "pageSize": "2"});
    HttpUtil.getInstance().post('/api/news', params, (data) {
      // print('请求成功 + ${data}');
      // contentmm = "请求成功: ${data.toString()}";

      /// 监听
      setState(() {
        contentmm = "请求成功: ${data}";
      });
      print(contentmm);
    }, (HttpIOException error) {
      /// 监听
      setState(() {
        contentmm = "请求失败: ${error.message}";
      });
      print(contentmm);
    });
  }

  /// dio第三方请求
  void getDio() async {
    // 或者通过传递一个 `BaseOptions`来创建dio实例
    BaseOptions options = new BaseOptions(
      baseUrl: "https://bo.kuangsky.com",
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: {"v": "1.3.1", "type": "ios"}, //设置请求头
      contentType: ContentType.parse("application/x-www-form-urlencoded"),
    );
    Dio dio = new Dio(options);

    // 配置dio实例
    // dio.options.connectTimeout = 5000; //5s
    // dio.options.receiveTimeout = 3000;
    // dio.options.baseUrl = "http://backoffice.kuangsky.com";

    /// 设置这个才可以抓包
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      //错误证书不处理
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      client.findProxy = (uri) {
        //proxy all request to localhost:8888
        return "PROXY $ip";
      };
    };

    Options option = Options(method: "post");

    Response response = await dio.post('/api/news',
        data: {"pageIndex": "1", "pageSize": "2"}, options: option);

    if (response.statusCode == HttpStatus.ok) {
      debugPrint('请求参数： ${response.request.queryParameters}');
      debugPrint(
          '-------------------请求成功,请求结果如下:-----------------\n \n===请求求url: ${response.request.uri.toString()} \n \n===请求:   \n${response.headers} \n \n===请求结果: \n${response.data}\n');
      debugPrint('-------------------请求成功,请求结果打印完毕----------------');

      /// 监听
      setState(() {
        contentmm = "请求成功: ${response.data.toString()}";
        // NewsEntity news = NewsEntity.fromJson(response.data);
        // print(news.message);
      });
    } else {
      print('请求失败');
    }
  }
}
