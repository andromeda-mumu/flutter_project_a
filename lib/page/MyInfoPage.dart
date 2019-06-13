import 'package:flutter/material.dart';
import 'package:flutter_project_a/constant/Constants.dart';
import 'package:flutter_project_a/event/Login_event.dart';
import 'package:flutter_project_a/util/DataUtils.dart';

import 'about_us_page.dart';
import 'collect_list_page.dart';
import 'login_page.dart';
/**
 * Created by wangjiao on 2019/6/12.
 * description:
 */
class MyInfoPage extends StatefulWidget {
  @override
  _MyInfoPageState createState() => new _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  String userName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getName();
    Constants.eventBus.on<LoginEvent>().listen((event){
      _getName();
    });
  }
  void _getName()async{
    DataUtils.getUserName().then((username){
      setState(() {
        userName = username;
        print("mmc= name:"+userName.toString());
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget image = Image.asset('images/ic_launcher_round.png',width: 100,height: 100,);
    Widget raisedButton = RaisedButton(
        child: Text(userName==null?"请登录":userName,style: TextStyle(color: Colors.white),),
        color: Theme.of(context).accentColor,
        onPressed: ()async{
        await DataUtils.isLogin().then((isLogin){
          if(!isLogin){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return LoginPage();
            }));
          }else{
            print("mmc= 已登录");
          }
        });
    });
    Widget listLike = ListTile(
      leading: const Icon(Icons.favorite),
      title: const Text('喜欢的文章'),
     trailing: Icon(Icons.chevron_right,color: Theme.of(context).accentColor),
    onTap: ()async{
        await DataUtils.isLogin().then((isLogin){
          if(isLogin){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return CollectPage();
            }));
        }else{
            print("mmc= 已登录");
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return LoginPage();
            }));
          }
    });
    });

    Widget listAbout = ListTile(
      leading: Icon(Icons.info),
      title: Text('关于我们'),
      trailing: Icon(Icons.chevron_right,color: Theme.of(context).accentColor),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return AboutUsPage();
        }));
      },
    );
    Widget listLogout = ListTile(
        leading: const Icon(Icons.info),
        title: const Text('退出登录'),
        trailing:
        Icon(Icons.chevron_right, color: Theme.of(context).accentColor),
        onTap: () async {
          DataUtils.clearLoginInfo();
          setState(() {
            userName = null;
          });
        });


    return ListView(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      children: <Widget>[
        image,
        raisedButton,
        listLike,
        listAbout,
        listLogout,
      ],
    );
  }
}
