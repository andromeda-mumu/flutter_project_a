import 'package:flutter/material.dart';
import 'package:flutter_project_a/http/Http_util_with_cookie.dart';
import 'package:flutter_project_a/http/api.dart';

import 'articles_page.dart';
/**
 * Created by wangjiao on 2019/6/12.
 * description:
 */
class TreePage extends StatefulWidget {
  @override
  _TreePageState createState() => new _TreePageState();
}

class _TreePageState extends State<TreePage> {
  var listData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTree();
  }
  _getTree()async{
    HttpUtil.get(Api.TREE, (data){
      setState(() {
        listData = data;
      });
    }) ;
  }
  @override
  Widget build(BuildContext context) {
    if(listData==null ){
      return Center(child: CircularProgressIndicator(),);
    }else{
      Widget listView = ListView.builder(itemBuilder: (context,i)=>buildItem(i),itemCount: listData.length,);
      return listView;
    }
  }
  Widget buildItem(i){
    var itemData = listData[i];
    Text name = Text(
      itemData['name'],
      softWrap: true,
      style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
      textAlign: TextAlign.left,
    );

    List list = itemData['children'];
    String strContent ='';
    for(var value in list){
      strContent += '${value['name']}   ';
    }

    Text content = Text(
      strContent,
      softWrap: true,
      style: TextStyle(color: Colors.black),
      textAlign: TextAlign.left,
    );

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: (){
          print("mmc= 点击"+itemData['name']);
          _handOnItemClick(itemData);
        },
        child: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: name,
                    ),
                    content,
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _handOnItemClick(itemData){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return ArticlesPage(itemData);
    }));
  }

}
