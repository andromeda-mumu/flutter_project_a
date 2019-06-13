import 'package:flutter/material.dart';
import 'package:flutter_project_a/constant/Constants.dart';
import 'package:flutter_project_a/http/Http_util_with_cookie.dart';
import 'package:flutter_project_a/http/api.dart';
import 'package:flutter_project_a/item/article_item.dart';
import 'package:flutter_project_a/widget/end_line.dart';
import 'package:flutter_project_a/widget/slive_view.dart';
/**
 * Created by wangjiao on 2019/6/12.
 * description:
 */
class HomeListPage extends StatefulWidget {
  @override
  _HomeListPageState createState() => new _HomeListPageState();
}

class _HomeListPageState extends State<HomeListPage> {
  List listData = List();
  var bannerData;
  var curPage =0;
  var listTotalSize =0;
  ScrollController _controller = ScrollController();
  TextStyle titleTextStyle = TextStyle(fontSize: 15.0);
  TextStyle subTitleTextStyle = TextStyle(fontSize: 12,color: Colors.blue);
  _HomeListPageState(){
    _controller.addListener((){
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      if(maxScroll==pixels && listData.length<listTotalSize){
        getHomeArticlelist();
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBanner();
    getHomeArticlelist();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
  SlideView _bannerView;
  void getBanner() {
    String bannerUrl = Api.BANNER;

    HttpUtil.get(bannerUrl, (data) {
      if (data != null) {
        setState(() {
          bannerData = data;
          _bannerView = SlideView(bannerData);
        });
      }
    });
  }
  void getHomeArticlelist() {
    String url = Api.ARTICLE_LIST;
    url += "$curPage/json";

    HttpUtil.get(url, (data) {
      if (data != null) {
        Map<String, dynamic> map = data;

        var _listData = map['datas'];

        listTotalSize = map["total"];

        setState(() {
          List list1 = List();
          if (curPage == 0) {
            listData.clear();
          }
          curPage++;

          list1.addAll(listData);
          list1.addAll(_listData);
          if (list1.length >= listTotalSize) {
            list1.add(Constants.END_LINE_TAG);
          }
          listData = list1;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if (listData == null || listData.length==0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      Widget listView = ListView.builder(
        itemCount: listData.length + 1,
        itemBuilder: (context, i) => buildItem(i),
        controller: _controller,
      );

      return RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }
  Future<Null> _pullToRefresh() async {
    curPage = 0;
    getBanner();
    getHomeArticlelist();
    return null;
  }
  Widget buildItem(int i) {
    if (i == 0) {
      return Container(
        height: 180.0,
        child: _bannerView,
      );
    }
    i -= 1;

    var itemData = listData[i];

    if (itemData is String && itemData == Constants.END_LINE_TAG) {
      return EndLine();
    }

    return ArticleItem(itemData);
  }
}

