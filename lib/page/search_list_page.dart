import 'package:flutter/material.dart';
import 'package:flutter_project_a/constant/Constants.dart';
import 'package:flutter_project_a/http/Http_util_with_cookie.dart';
import 'package:flutter_project_a/http/api.dart';
import 'package:flutter_project_a/item/article_item.dart';
import 'package:flutter_project_a/widget/end_line.dart';
/**
 * Created by wangjiao on 2019/6/14.
 * description:
 */
class SearchListPage extends StatefulWidget {
  String id;
  SearchListPage(ValueKey<String> key):super(key:key){
    this.id = key.value.toString();
  }
  _SearchListPageState _searchListPageState;
  @override

  _SearchListPageState createState() => new _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  int curPage =0;
  Map<String,String> map =Map();
  List listData = List();
  int listTotalSize = 0;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener((){
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if(maxScroll==pixels && listData.length<listTotalSize){
        _articleQuery();
      }
    });
    _articleQuery();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  void _articleQuery(){
    String url = Api.ARTICLE_QUERY;
    url+="$curPage/json";
    map['k']=widget.id;
    HttpUtil.post(url, (data){
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
              list1.add(Constants.END_LINE_TAG);
          }
          listData = list1;
        });

      }
    },params: map);
  }

  Future<Null> pullToRefresh()async{
    curPage=0;
    _articleQuery();
    return null;
  }
  @override
  Widget build(BuildContext context) {
    if(listData==null || listData.isEmpty){
      return Center(child: CircularProgressIndicator(),);
    }else{
      Widget listView = ListView.builder(
          itemCount: listData.length,
          itemBuilder: (context,i)=>buildItem(i),
          controller: _controller,
      );
      return RefreshIndicator(child: listView,onRefresh: pullToRefresh,);
    }
  }
  Widget buildItem(int i){
     var itemData = listData[i];
     if(i==listData.length-1 && itemData.toString()==Constants.END_LINE_TAG){
       return EndLine();
     }
     return ArticleItem.isFromSearch(itemData, widget.id);
  }
}

