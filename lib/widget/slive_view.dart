import 'package:flutter/material.dart';
/**
 * Created by wangjiao on 2019/6/13.
 * description:
 */
 class SlideView extends StatefulWidget {
  var data;
  SlideView(this.data);
   @override
   _SlideViewState createState() => new _SlideViewState(data);
 }

 class _SlideViewState extends State<SlideView> with SingleTickerProviderStateMixin {
  TabController tabController;
  List data;
  _SlideViewState(this.data);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController= new TabController(length: data==null?0:data.length, vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

   @override
   Widget build(BuildContext context) {
    List<Widget> items=[];
    if(data!=null && data.length>0){
      for(int i=0;i<data.length;i++){
          var item = data[i];
          var imgUrl = item['imagePath'];
          var title=item['title'];
          item['link']=item['url'];
          items.add(new GestureDetector(
            onTap: (){
//              _handOnItemClick(item);
            print("mmc= 点击了banner"+title);
            },
            child: AspectRatio(
                aspectRatio: 2.0/1.0,
                child: new Stack(
                  children: <Widget>[
                    new Image.network(imgUrl,fit: BoxFit.cover,width: 1000.0,),
                    new Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: new Container(
                        width: 1000,
                        color: const Color(0x50000000),
                        padding: const EdgeInsets.all(5),
                        child: new Text(title,style: new TextStyle(color: Colors.white,fontSize: 15),),
                      ),
                    )
                  ],
                ),
            ),
          ));
      }
    }
     return new TabBarView(children: items,controller: tabController,);
   }
   void _handOnItemClick(itemData){

   }
 }
