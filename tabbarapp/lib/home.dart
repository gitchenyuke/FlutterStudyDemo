import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("这是首页页面"),
            MaterialButton(
              textColor: Colors.white,
              height: 40.0,
              minWidth: 100.0,
              color: Colors.blue,
              child: Text("跳转网络请求"),
              onPressed: () {
                Navigator.pushNamed(context, '/reque');
              },
            )
          ],
        ),
      ),
    );
  }
}