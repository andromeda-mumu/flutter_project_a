import 'package:flutter/material.dart';
import 'package:flutter_project_a/http/Http_util_with_cookie.dart';
import 'package:flutter_project_a/http/api.dart';

import 'SearchPage.dart';
import 'activity_detail_page.dart';
/**
 * Created by wangjiao on 2019/6/14.
 * description:
 */
class HotPage extends StatefulWidget {
  @override
  _HotPageState createState() => new _HotPageState();
}

class _HotPageState extends State<HotPage> {
  List<Widget> hotKeyWidgets = List();
  List<Widget> friendWidgets = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFriend();
    _getHotKey();
  }
  void _getFriend(){
    HttpUtil.get(Api.FRIEND, (data){
      setState(() {
        List datas = data;
        friendWidgets.clear();
        for(var itemData in datas){
          Widget actionChip = ActionChip(
            backgroundColor: Theme.of(context).accentColor,
              label: Text(itemData['name'],style: TextStyle(color: Colors.white),),
              onPressed: (){
                itemData['title']=itemData['name'];
                //这里http开头打不开网页，只能是https才行
                String link = itemData['link'];
                String type = link.split(":")[0];
                String str = link.split(":")[1];
                if("http"==type){
                    link = "https:"+str;
                }
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return ArticleDetailPage(title: itemData['title'],url: link,);
                }));
              }
          );
          friendWidgets.add(actionChip);
        }
      });
    }) ;
  }
  void _getHotKey(){
    HttpUtil.get(Api.HOTKEY, (data){
      setState(() {
        List datas = data;
        hotKeyWidgets.clear();
        for(var value in datas){
          Widget actionChip = ActionChip(
            backgroundColor: Theme.of(context).accentColor,
            label: Text(value['name'],style: TextStyle(color: Colors.white),),
            onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                return SearchPage(value['name']);
              }));
            },
          );
          hotKeyWidgets.add(actionChip);
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('大家都在搜',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 20),),
        ),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: hotKeyWidgets,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text('常用网站',style: TextStyle(color: Theme.of(context).accentColor,fontSize: 20),),
        ),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children:friendWidgets
        )
      ],
    );
  }
}
