import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project_a/constant/Constants.dart';
import 'package:flutter_project_a/event/Login_event.dart';
import 'package:flutter_project_a/http/Http_util_with_cookie.dart';
import 'package:flutter_project_a/http/api.dart';
import 'package:flutter_project_a/util/DataUtils.dart';
/**
 * Created by wangjiao on 2019/6/13.
 * description:
 */
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _nameController = TextEditingController(text: 'canhuah');
  TextEditingController _pwdController = TextEditingController(text: 'a123456');
  GlobalKey<ScaffoldState> scaffoldKey;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
  }
  @override
  Widget build(BuildContext context) {
    Row avatar = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.account_circle,color: Colors.blue,size: 80,),
      ],
    );
    CupertinoButton(child: null,onPressed: null,);
    TextField name = TextField(
      autofocus: true,
      decoration: InputDecoration(labelText: '用户名'),
      controller: _nameController,
    );
    TextField pwd = TextField(
      obscureText: true,
      decoration: InputDecoration(labelText: '密码'),
      controller: _pwdController,
    );
    Row loginAndRegister = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RaisedButton(
          child: Text('登录',style: TextStyle(color: Colors.white),),
          color: Theme.of(context).accentColor,
          disabledColor: Colors.blue,
          textColor: Colors.white,
          onPressed: (){
            _login();
          },
        ),
        RaisedButton(
          child: Text('注册',style: TextStyle(color: Colors.white),),
          color: Theme.of(context).accentColor,
          disabledColor: Colors.blue,
          textColor: Colors.white,
          onPressed: (){
            _register();
          },
        ),
      ],
    );

    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text('登录')),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
        child: ListView(
          children: <Widget>[
            avatar,
            name,
            pwd,
            Padding(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
            ),
            loginAndRegister,
          ],
        ),
      ),
    );
  }
  void _login(){
    String name =_nameController.text;
    String pwd =_pwdController.text;
    if(name.length==0){
      _showMessage('请先输入姓名');
      return;
    }
    if(pwd.length==0){
      _showMessage('请先输入密码');
      return;
    }
    Map<String,String> map =Map();
    map['username']=name;
    map['password']=pwd;

    HttpUtil.post(Api.LOGIN, (data)async{
      DataUtils.saveLoginInfo(name).then((r){
        Constants.eventBus.fire(LoginEvent());
        Navigator.of(context).pop();
      });
    },
      params: map,
      errorCallback: (msg){
        _showMessage(msg);
      });
  }
  void _register(){
    String name = _nameController.text;
    String password = _pwdController.text;
    if (name.length == 0) {
      _showMessage('请先输入姓名');
      return;
    }
    if (password.length == 0) {
      _showMessage('请先输入密码');
      return;
    }
    Map<String, String> map = Map();
    map['username'] = name;
    map['password'] = password;
    map['repassword'] = password;
    HttpUtil.post(Api.REGISTER, (data)async{
      DataUtils.saveLoginInfo(name).then((r){
        Constants.eventBus.fire(LoginEvent());
        Navigator.of(context).pop();
      });
    },
      params: map,
      errorCallback: (msg){
        _showMessage(msg);
      }
    );
  }
  void _showMessage(String msg){
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }
}
