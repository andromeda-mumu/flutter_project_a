import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
/**
 * Created by wangjiao on 2019/6/13.
 * description:
 */
class ArticleDetailPage extends StatefulWidget {
  final String title;
  final String url;
  ArticleDetailPage({Key key,this.title,this.url}):super(key:key);
  @override
  _ArticleDetailPageState createState() => new _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterWebViewPlugin.onDestroy.listen((_){
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: widget.url,
    appBar: AppBar(title: Text(widget.title),),
    withZoom: false,
      withLocalStorage: true,
      withJavascript: true,
    );
  }
}
