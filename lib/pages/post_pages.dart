import 'dart:convert';

import 'package:flatajsonblock/commentpage/comment_pages.dart';
import 'package:flatajsonblock/model/response.dart';
import 'package:flatajsonblock/pages/post_block.dart';
import 'package:flatajsonblock/post_widgets/PostWidgets.dart';
import 'package:flatajsonblock/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Post_Page extends StatefulWidget {
  @override
  _Post_PageState createState() => _Post_PageState();
}

class _Post_PageState extends State<Post_Page> {
  PostBlock block;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    block = PostBlock();
    block.getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    block.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post Page"),
          centerTitle: true,
        ),
        body: StreamBuilder<Response>(
            initialData: Response(myState: MyState.loading, data: null),
            stream: block.postStream(),
            builder: (context, snapshot) {
              if (snapshot.data.myState == MyState.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.data.myState == MyState.data) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        child: PostWidget(snapshot.data.data[index]),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return CommentPage(snapshot.data.data[index]);
                          }));
                        });
                  },
                  itemCount: snapshot.data.data.length,
                );
              } else if (snapshot.data.myState == MyState.error) {
                //added new
                return Column(
                  children: <Widget>[
                    Text(snapshot.data.data),
                    RaisedButton(
                        child: Text("Try Again"),
                        onPressed: () => block.getData())
                  ],
                );
              }
            }));
  }
}
