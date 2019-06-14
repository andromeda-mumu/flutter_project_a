import 'package:flutter/material.dart';
import 'package:flutter_project_a/constant/Constants.dart';
import 'package:flutter_project_a/http/Http_util_with_cookie.dart';
import 'package:flutter_project_a/http/api.dart';
import 'package:flutter_project_a/util/DataUtils.dart';
import 'package:flutter_project_a/widget/end_line.dart';

import 'activity_detail_page.dart';
import 'login_page.dart';
/**
 * Created by wangjiao on 2019/6/13.
 * description:
 */
class CollectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('喜欢的文章'),),
      body: CollectListPage(),
    );
  }
}

class CollectListPage extends StatefulWidget {
  CollectListPage();
  @override
  _CollectListPageState createState() => new _CollectListPageState();
}

class _CollectListPageState extends State<CollectListPage> {
  int curPage = 0;
  Map<String,String> map =Map();
  List listData = List();
  int listTotalSize = 0;
  ScrollController _controller = ScrollController();

  _CollectListPageState();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCollectList();
    _controller.addListener((){
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels =_controller.position.pixels;
      if(maxScroll == pixels && listData.length<listTotalSize){
        _getCollectList();
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  void _getCollectList()async{
    String url = Api.COLLECT_LIST;
    url += '$curPage/json';
    HttpUtil.get(url, (data){
      if(data!=null){
        Map<String,dynamic> map = data;
        var _listData = map['datas'];
        listTotalSize = map['total'];

        setState(() {
          List list1 = List();
          if(curPage==0){
            listData.clear();
          }
          curPage++;

          list1.addAll(listData);
          list1.addAll(_listData);
          if(list1.length>=listTotalSize){
            list1.add((Constants.END_LINE_TAG));
          }
          listData = list1;
        });
      }
    },params: map);
  }

  Future<Null> _pullToRefresh()async{
    curPage =0;
    _getCollectList();
    return null;
  }
  @override
  Widget build(BuildContext context) {
    if(listData==null || listData.isEmpty){
      return Center(
        child: CircularProgressIndicator(),
      );
    }else{
      Widget listView = ListView.builder(
          itemCount: listData.length,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context,i)=>buildItem(i),
         controller: _controller,
      );
      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }
  //还是建议把Item单独抽出来,可以复用.参考 lib/item/article_item.dart
  Widget buildItem(int i){
    var itemData =listData[i];
    if(i==listData.length-1 && itemData.toString()==Constants.END_LINE_TAG){
      return EndLine();
    }
    Row row1 = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Row(
            children: <Widget>[
              Text('作者： '),
              Text(itemData['author'],style: TextStyle(color: Theme.of(context).accentColor),)
            ],
          ),
        ),
        Text(itemData['niceDate']),
      ],
    );

    Row title = Row(
      children: <Widget>[
        Expanded(
          child: Text(
            itemData['title'],
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
            _handerListItemCollect(itemData);
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
          _itemClick(itemData);
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
      setState(() {
       listData.remove(itemData);
      });
    },params: map);
  }
}


