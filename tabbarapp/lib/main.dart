import 'package:flutter/material.dart';
import 'package:tabbarapp/home.dart';
import 'package:tabbarapp/me.dart';
import 'package:tabbarapp/align.dart';
import 'package:tabbarapp/request.dart';
import 'package:tabbarapp/find.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Main(),
      theme: ThemeData(primaryColor: Colors.blue),

      /// 页面跳转路径
      routes: {
        '/reque': (BuildContext context) => RequestData(),
        '/align': (BuildContext context) => AlignWidget(),
      },
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  /// 默认选中第一页
  int _currentIndex = 0;

  /// 选中的icon数组
  var tabSelectedImages;

  /// 未选中的icon数组
  var tabUnselectedImages;

  /// 标题
  var appBarTitles = ['首页', '发现', '我的'];

  /*
   * 根据image路径获取图片
   */
  Image getTabImage(path) {
    return new Image.asset(path, width: 24.0, height: 24.0);
  }

  void initData() {
    /*
     * 初始化选中的icon
     */
    tabSelectedImages = [
      getTabImage('assets/images/home_s.png'),
      getTabImage('assets/images/my_s.png'),
      getTabImage('assets/images/my_s.png')
    ];

    /*
     * 初始化未选中的icon
     */
    tabUnselectedImages = [
      getTabImage('assets/images/home_n.png'),
      getTabImage('assets/images/my_n.png'),
      getTabImage('assets/images/my_n.png')
    ];
  }

  final List<Widget> _children = [HomePage(), FindPage(), MePage()];

  @override
  Widget build(BuildContext context) {
    /// 初始化数据
    initData();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        //选中字体大小
        selectedFontSize: 12.0,
        //未选中字体大小
        unselectedFontSize: 12.0,
        //选中的字体颜色
        selectedItemColor: Colors.orange,
        //未选中的字体颜色
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: tabUnselectedImages[0],
              activeIcon: tabSelectedImages[0],
              title: Text(appBarTitles[0])),
          BottomNavigationBarItem(
              icon: tabUnselectedImages[1],
              activeIcon: tabSelectedImages[1],
              title: Text(appBarTitles[1])),
          BottomNavigationBarItem(
              icon: tabUnselectedImages[2],
              activeIcon: tabSelectedImages[2],
              title: Text(appBarTitles[2])),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
    );
  }

  /// item点击事件
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
