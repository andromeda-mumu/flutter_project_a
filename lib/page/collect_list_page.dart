import 'package:flutter/material.dart';
import 'package:flutter_project_a/constant/Constants.dart';
import 'package:flutter_project_a/event/UnCollectEvent.dart';
import 'package:flutter_project_a/http/Http_util_with_cookie.dart';
import 'package:flutter_project_a/http/api.dart';
import 'package:flutter_project_a/item/collect_item.dart';
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

    Constants.eventBus.on<UnCollectEvent>().listen((event){
      setState(() {
        listData.remove(event.itemData);
      });

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
    return CollectItem(itemData,listData);
  }



}


