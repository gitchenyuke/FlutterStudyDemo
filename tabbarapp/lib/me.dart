import 'package:flutter/material.dart';

class MePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('我的'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("这是我的页面"),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text("点我啊"),
              onPressed: () {
                print("点击了我");
                Navigator.pushNamed(context, '/align');
              },
            ),
          ],
        ),
      ),
    );
  }
}
