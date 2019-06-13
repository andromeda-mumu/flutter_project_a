import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
/**
 * Created by wangjiao on 2019/6/13.
 * description:
 */
class DataUtils{
  static const String IS_LOGIN ='isLogin';
  static const String USERNAME ='userName';

// 保存用户登录信息，data中包含了userName
  static Future saveLoginInfo(String username)async{
    print("mmc= isLogin");
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setString(USERNAME, username);
    await sp.setBool(IS_LOGIN, true);
  }
  static Future clearLoginInfo()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    print("mmc= clean");
    return sp.clear();
  }
  static Future<String> getUserName()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(USERNAME);
  }
  static Future<bool> isLogin()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool b = sp.getBool(IS_LOGIN);
    return true == b;
  }

}