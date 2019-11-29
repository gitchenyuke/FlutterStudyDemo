import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/bezier_hour_glass_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tabbarapp/find.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_easyrefresh/material_footer.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'lxhentity.dart';
import 'dioManager.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NewsPageView();
  }
}

class NewsPageView extends StatefulWidget {
  NewsPageView({Key key}) : super(key: key);

  @override
  NewsRefreshState createState() => NewsRefreshState();
}

class NewsRefreshState extends State<NewsPageView> {
  List<NewsListEntity> news = [];
  int page = 1;
  // 控制器
  EasyRefreshController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新闻列表"),
      ),
      body: EasyRefresh.custom(
        header: MaterialHeader(),
        footer: MaterialFooter(),
        firstRefresh: true,
        controller: _controller,
        enableControlFinishRefresh: true, //手动控制结束刷新
        enableControlFinishLoad: true, //手动控制结束加载
        
        firstRefreshWidget: Container(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SizedBox(
              height: 200.0,
              width: 300.0,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 50.0,
                      height: 50.0,
                      child: SpinKitHourGlass(
                        color: Theme.of(context).primaryColor,
                        size: 25.0,
                      ),
                    ),
                    Container(
                      child: Text("正在加载..."),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                NewsListEntity entity = news[index];
                return ListViewCell(
                  title: entity.title,
                  subTitle: entity.summary,
                  onPressed: () {
                    print("点击了: $index");
                  },
                );
              },
              childCount: news.length,
            ),
          ),
        ],
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2), () {
            page = 1;
            getHttp(page);
          });
        },
        onLoad: () async {
          await Future.delayed(Duration(seconds: 2), () {
            page = page + 1;
            getHttp(page);
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
  }

  //封装的网络请求
  void getHttp(int page) {
    Map<String, dynamic> params = {"pageIndex": page, "pageSize": 2};
    HttpUtil.getInstance().post('/api/news', params, (data) {
      // 请求成功
      NewsEntity newsEntity = NewsEntity.fromJson(data);

      /// 刷新
      setState(() {
        if (page == 1) {
          news = newsEntity.news;
        } else {
          news.addAll(newsEntity.news);
        }
      });
      // 结束刷新
      _controller.finishRefresh();
      _controller.finishLoad();
    }, (HttpIOException error) {
      // 请求错误
      print(error.message);
      // 结束刷新
      _controller.finishRefresh();
      _controller.finishLoad();
    });
  }
}
