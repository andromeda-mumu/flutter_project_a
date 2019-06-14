import 'package:flutter/material.dart';
import 'package:flutter_project_a/constant/Constants.dart';
import 'package:flutter_project_a/http/Http_util_with_cookie.dart';
import 'package:flutter_project_a/http/api.dart';
import 'package:flutter_project_a/item/article_item.dart';
import 'package:flutter_project_a/widget/end_line.dart';
/**
 * Created by wangjiao on 2019/6/14.
 * description: 发现页二级页面之tab下面的listview页
 */
class ArticleListPage extends StatefulWidget {
  final String id;
  ArticleListPage(this.id);
  @override
  _ArticleListPageState createState() => new _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  int curPage =0;
  Map<String,String> map =Map();
  List listData = List();
  int listTotalSize =0;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getArticleList();
    _controller.addListener((){
      var maxScroll =_controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if(maxScroll==pixels && listData.length<listTotalSize){
        _getArticleList();
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  void _getArticleList(){
    String url = Api.ARTICLE_LIST;
    url+='$curPage/json';
    map['cid'] = widget.id;
    HttpUtil.get(url, (data){
      if(data!=null){
        Map<String,dynamic> map =data;
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
  @override
  Widget build(BuildContext context) {
    if(listData==null || listData.isEmpty){
      return Center(child: CircularProgressIndicator(),);
    }else{
      Widget listView  =ListView.builder(
          key: PageStorageKey(widget.id),
          itemCount: listData.length,
          itemBuilder:(context,i)=>buildItem(i),
           controller: _controller,
      );
      return RefreshIndicator(child: listView,onRefresh: _pullToRefresh);
    }
  }
  Future<Null> _pullToRefresh()async{
      curPage=0;
      _getArticleList();
      return null;
  }
  Widget buildItem(int i){
    var itemData = listData[i];
    if(i == listData.length-1 && itemData.toString()== Constants.END_LINE_TAG){
      return EndLine();
    }
    return ArticleItem(itemData);
  }

}
