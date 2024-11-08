import 'package:flutter/material.dart';
class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Scaffold(
       //render field of write text
      body: Stack(children: <Widget>[Container(color:Colors.white,
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,),
      Positioned(
        bottom:0,
        child:Container(
          color:Colors.white,height:60,
          width:MediaQuery.of(context).size.width,
          child:Column(children:<Widget> [
            Row(children:<Widget> [
              Container(
                decoration : BoxDecoration(border:Border(top:BorderSide(color:Colors.black26))),
                padding:EdgeInsets.symmetric(horizontal: 5,vertical:5),
                  width: MediaQuery.of(context).size.width-20,
                  child:TextFormField(
                decoration: InputDecoration(
                  hintText: "     Enter your feedback here",
                  filled:true,
                  fillColor: Colors.grey[200],
                  suffixIcon:IconButton(onPressed: (){}, icon: Icon(Icons.send)),
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(
                    borderSide:BorderSide(color:Colors.grey),
                    borderRadius:BorderRadius.circular(30)

                  )
                ),
              )),

            ],)
          ],),),),


        //Note display screen design
         //display name and text
        Positioned(top:30,child:Container(width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height-70,
        child: SingleChildScrollView(child:Column(children: <Widget>[
          //use CirleAvarge to take icon as a picture of user
          ListTile(leading:CircleAvatar(child:Icon(Icons.person),
          ),
          title:Container(margin: EdgeInsets.only(top:15),child:Text("Nejood Mohammed ")),
          subtitle:Container(padding:EdgeInsets.all(10), color:Colors.grey[100],child:Text("the material is very interesting "),),
          ),
          ListTile(leading:CircleAvatar(child:Icon(Icons.person),
          ),
            title:Container(margin: EdgeInsets.only(top:15),child:Text("Nejood Mohammed ")),
            subtitle:Container(padding:EdgeInsets.all(10), color:Colors.grey[100],
              child:Text("the material is very interesting "),),
          )
        ],),
        ),
        ))
        ],),
    ));
  }
}
