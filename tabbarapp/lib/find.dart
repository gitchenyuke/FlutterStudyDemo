import 'package:flutter/material.dart';
import 'lxhentity.dart';
import 'dioManager.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';

void main() {
  runApp(FindPage());
}

class FindPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /// MaterialApp可以修改导航栏主题颜色

    /**
     * Scaffold通常被用作MaterialApp的子Widget，它会填充可用空间，占据整个窗口或设备屏幕。
     * Scaffold提供了大多数应用程序都应该具备的功能，例如顶部的appBar，底部的bottomNavigationBar，隐藏的侧边栏drawer等
     */
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FindPageView(),
    );
  }
}

/// 相当于self.view
class FindPageView extends StatefulWidget {
  FindPageView({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => _SampleAppPageState();
}

class ListViewCell extends StatelessWidget {
  String title;
  String subTitle;
  ListViewCell(this.title, this.subTitle);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: ListViewItem(title, subTitle),
          ),
          Container(
            color: Colors.grey,
            constraints: BoxConstraints.expand(height: 0.5),
          ),
        ],
      ),
    );
  }
}

class ListViewItem extends StatelessWidget {
  String title;
  String subTitle;
  ListViewItem(this.title, this.subTitle);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity, //宽度占满全屏
      color: Colors.green,
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              color: Colors.red,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity, //最大宽度 占满全屏
              height: 100,
              color: Colors.blue,
              child: Column(
                /**
                 * MainAxisAlignment（主轴）和CrossAxisAlignment（交叉轴）
                 * 如果主轴是水平的 则CrossAxisAlignment就是垂直的 反之同理
                 */
                mainAxisAlignment: MainAxisAlignment.center, //控制垂直对齐 (因为主轴是垂直的)
                crossAxisAlignment: CrossAxisAlignment.start, //控制水平对齐
                children: <Widget>[
                  Container(
                    width: 200,
                    color: Colors.yellow,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        maxLines: 1, //最大行数
                        overflow: TextOverflow.ellipsis, ////超出显示省略号
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      subTitle,
                      maxLines: 2, //最大行数
                      overflow: TextOverflow.ellipsis, ////超出显示省略号
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SampleAppPageState extends State<FindPageView> {
  List<NewsListEntity> news = [];
  int page = 1;
  // 控制器
  EasyRefreshController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发现"),
      ),
      body: EasyRefresh.custom(
        //刷新控件
        header: BallPulseHeader(),
        footer: BallPulseFooter(),
        controller: _controller,
        enableControlFinishRefresh: true, //手动控制结束刷新
        enableControlFinishLoad: true, //手动控制结束加载
        firstRefresh: true,
        onRefresh: () async {
          getHttp(1);
        },
        onLoad: () async {
          getHttp(page++);
        },
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                NewsListEntity entity = news[index];
                return ListViewCell(entity.title, entity.summary);
              },
              childCount: news.length,
            ),
          ),
        ],
        // child: ListView.builder(
        //   //列表控件
        //   itemCount: news.length,
        //   itemBuilder: (context, index) {
        //     NewsListEntity entity = news[index];
        //     return ListViewCell(entity.title, entity.summary);
        //   },
        // ),
      ),
      // body: ListView.builder(
      //   itemCount: news.length,
      //   itemBuilder: (context, index) {
      //     NewsListEntity entity = news[index];
      //     return ListViewCell(entity.title, entity.summary);
      //   },
      // ),
      //body: ListView(children: _getListData()),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
  }

  //自定义分区
  Widget get _listViewSection {
    return Container(
      color: Colors.purple,
      height: 15,
    );
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

  /// 不请求网络 手动添加数据
  _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      int number = i + 1;
      if (i == 1) {
        /// 添加分区
        widgets.add(_listViewSection);
      }

      /// 自定义样式 无点击事件
      //widgets.add(ListViewCell("这是标题 $number", "这是副标题 $number"));

      /// 有点击事件
      widgets.add(GestureDetector(
        child: ListViewCell("这是标题 $number", "这是副标题 $number"),
        onTap: () {
          print("点击了 $number");
        },
      ));

      // widgets.add(GestureDetector(
      //   child: Padding(
      //     padding: EdgeInsets.all(15),
      //     child: Text("Row $number"),
      //   ),
      //   onTap: () {
      //     print("点击了 $number");
      //   },
      // ));
    }
    return widgets;
  }
}
