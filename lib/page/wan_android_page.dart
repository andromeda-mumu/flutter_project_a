import 'package:flutter/material.dart';
import 'package:flutter_project_a/constant/colors.dart';

import 'HomeListPage.dart';
import 'MyInfoPage.dart';
import 'SearchPage.dart';
import 'TreePage.dart';
/**
 * Created by wangjiao on 2019/6/12.
 * description: 首页
 */
class WanAndroidApp extends StatefulWidget {
  @override
  _WanAndroidAppState createState() => new _WanAndroidAppState();
}

class _WanAndroidAppState extends State<WanAndroidApp> {
  int _tabIndex =0;
  List<BottomNavigationBarItem> _navigationViews;
  var appBarTitle =['首页', '发现', '我的'];
  var _body;
  void initData(){
    _body = IndexedStack(
      children: <Widget>[HomeListPage(),TreePage(),MyInfoPage()],
      index: _tabIndex,
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigationViews = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        title: Text(appBarTitle[0]),
        backgroundColor: Colors.blue,
      ),
      BottomNavigationBarItem(
      icon: const Icon(Icons.widgets),
      title: Text(appBarTitle[1]),
      backgroundColor: Colors.blue,
    ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person),
        title: Text(appBarTitle[2]),
        backgroundColor: Colors.blue,
      ),
    ];
  }
  final navigatorKey=GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    initData();
    return new MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(primaryColor: AppColors.colorPrimary,accentColor: Colors.blue),
      home: Scaffold(
           appBar: AppBar(
                title: Text(appBarTitle[_tabIndex],style: TextStyle(color: Colors.white),),
                actions: <Widget>[
                    IconButton(
                       icon: Icon(Icons.search),
                       onPressed: (){
                         navigatorKey.currentState.push(MaterialPageRoute(builder: (context){
                           return SearchPage();
                         }));
               },
             )
            ],
        ),
        body: _body,
        bottomNavigationBar: BottomNavigationBar(
            items: _navigationViews.map((BottomNavigationBarItem navigationView)=>navigationView).toList(),
          currentIndex: _tabIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index){
              setState(() {
                _tabIndex = index;
              });
          },
        ),
      ),
    );
  }
}

