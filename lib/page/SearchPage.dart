import 'package:flutter/material.dart';
import 'package:flutter_project_a/page/search_list_page.dart';

import 'hot_page.dart';
/**
 * Created by wangjiao on 2019/6/13.
 * description:
 */
class SearchPage extends StatefulWidget {
  String searchStr;
  SearchPage(this.searchStr);
  @override
  _SearchPageState createState() => new _SearchPageState(searchStr);
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  SearchListPage _searchListPage;
  String searchStr;
  _SearchPageState(this.searchStr);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController(text: searchStr);
    changeContent();
  }
  void changeContent(){
    setState(() {
      _searchListPage= SearchListPage(ValueKey(_searchController.text));
    });
  }
  @override
  Widget build(BuildContext context) {
    TextField searchField = TextField(
      autofocus: true,
      textInputAction: TextInputAction.search,
      onSubmitted: (String){
        changeContent();
      },
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '搜索关键字',
        hintStyle: TextStyle(color: Colors.white),
      ),
      controller: _searchController,
    );

    return Scaffold(
     appBar: AppBar(
         title: searchField,
         actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
                changeContent();
              },
            ),
           IconButton(
             icon: Icon(Icons.close),
             onPressed: (){
               setState(() {
                 _searchController.clear();
               });
             },
           )
           ],),
      body: (_searchController.text==null || _searchController.text.isEmpty)?Center(child: HotPage()):_searchListPage,
    );
  }
}
