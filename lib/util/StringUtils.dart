import 'package:flutter/material.dart';
import 'package:flutter_project_a/constant/colors.dart';
/**
 * Created by wangjiao on 2019/6/13.
 * description: 不懂
 */
class StringUtils{
  // 保存用户登录信息，data中包含了token等信息
  static TextSpan getTextSpan(String text,String key){
    if(text==null || key ==null){
      return null;
    }
    String splitString1 ="<em class='highlight'>";
    String splitString2="</em>";
    String textOrigin = text.replaceAll(splitString1, '').replaceAll(splitString2, '');
    TextSpan textSpan = new TextSpan(text: key,style: new TextStyle(color: AppColors.colorPrimary));
    List<String> split = textOrigin.split(key);
    List<TextSpan> list = new List();

    for(int i=0;i<split.length;i++){
        list.add(new TextSpan(text: split[i]));
        list.add(textSpan);
    }

    list.removeAt(list.length-1);
    return new TextSpan(children: list);
  }
}