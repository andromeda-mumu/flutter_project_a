import 'package:flutter/material.dart';
import 'package:flutter_project_a/constant/Constants.dart';
import 'package:flutter_project_a/event/UnCollectEvent.dart';
import 'package:flutter_project_a/http/Http_util_with_cookie.dart';
import 'package:flutter_project_a/http/api.dart';
import 'package:flutter_project_a/page/activity_detail_page.dart';
import 'package:flutter_project_a/page/login_page.dart';
import 'package:flutter_project_a/util/DataUtils.dart';
/**
 * Created by wangjiao on 2019/6/14.
 * description:
 */
class CollectItem extends StatefulWidget {
  var itemData;
  List listData = List();
  CollectItem(var itemData,List listData){
    this.itemData = itemData;
    this.listData = listData;
  }
  @override
  _CollectItemState createState() => new _CollectItemState();
}

class _CollectItemState extends State<CollectItem> {
  @override
  Widget build(BuildContext context) {
    Row row1 = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Text('作者： '),
              Text(widget.itemData['author'],style: TextStyle(color: Theme.of(context).accentColor),)
            ],
          ),
        ),
        Text(widget.itemData['niceDate']),
      ],
    );

    Row title = Row(
      children: <Widget>[
        Expanded(
          child: Text(
            widget.itemData['title'],
            softWrap: true,
            style: TextStyle(fontSize: 16,color: Colors.black),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );

    Row chapterName = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          child: Icon(
            Icons.favorite,color: Colors.red,
          ),
          onTap: (){
            _handerListItemCollect(widget.itemData);
          },
        )
      ],
    );

    Column column = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: row1,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 20, 5),
          child: title,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: chapterName,
        ),
      ],
    );
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: (){
          _itemClick(widget.itemData);
        },
        child: column,
      ),
    );
  }
  void _handerListItemCollect(itemData){
    DataUtils.isLogin().then((isLogin){
      if(!isLogin){
        _login();
      }else{
        _itemUnCollect(itemData);
      }
    });
  }
  _login() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
  }
  void _itemClick(var itemData) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ArticleDetailPage(title: itemData['title'], url: itemData['link']);
    }));
  }
  void _itemUnCollect(var itemData){
    String url;
    url =Api.UNCOLLECT_LIST;
    Map<String,String> map =Map();
    map['originId']=itemData['originId'].toString();
    url =url+itemData['id'].toString()+'/json';
    HttpUtil.post(url, (data){
      Constants.eventBus.fire(UnCollectEvent(itemData));
    },params: map);
  }
}
