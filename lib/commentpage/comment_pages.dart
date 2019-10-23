import 'package:flatajsonblock/commentpage/comment_block.dart';
import 'package:flatajsonblock/model/comments.dart';
import 'package:flatajsonblock/model/response.dart';
import 'package:flatajsonblock/post_widgets/PostWidgets.dart';
import 'package:flatajsonblock/utils/app_constants.dart';
import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  Map<String, dynamic> map; //null
  CommentPage(this.map);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  CommentBlock block;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    block = CommentBlock();
    block.getComment(widget.map["id"].toString());
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
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text("Comment Page"), centerTitle: true),
        body: Column(
          children: <Widget>[
            PostWidget(widget.map),
            Text(
              "Comments",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple),
            ),
            StreamBuilder<Response>(
                stream: block.cmtStream(),
                initialData: Response(myState: MyState.loading, data: null),
                builder:
                    (BuildContext context, AsyncSnapshot<Response> snapshot) {
                  Response resp = snapshot.data;
                  if (resp.myState == MyState.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (resp.myState == MyState.data) {
                    List<Comment> cmts = resp.data;

                    return Expanded(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  cmts[index].name,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                ),
                                Text(
                                  cmts[index].email,
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 15),
                                ),
                                Text(
                                  cmts[index].body,
                                  style: TextStyle(
                                      color: Colors.blue, fontSize: 15),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: cmts.length,
                      ),
                    );
                  }
                })
          ],
        ));
  }
}
