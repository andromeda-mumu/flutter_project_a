import 'package:flutter/material.dart';
/**
 * Created by wangjiao on 2019/6/13.
 * description:
 */
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'wan_android',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        body: new Center(child: Text('查询'),),
      ),

    );
  }
}
