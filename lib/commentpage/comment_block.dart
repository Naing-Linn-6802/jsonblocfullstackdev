import 'dart:async';
import 'dart:convert';

import 'package:flatajsonblock/model/comments.dart';
import 'package:flatajsonblock/model/response.dart';
import 'package:flatajsonblock/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CommentBlock {
  StreamController<Response> cmtController = StreamController();

  Stream<Response> cmtStream() => cmtController.stream;

  dispose() {
    cmtController.close();
  }

  getComment(String postId) async {
    Response resp = Response(myState: MyState.loading, data: null);
    cmtController.sink.add(resp);

    await http.get(CMT_LINK + postId).then((res) {
      if (res.statusCode == 200) {
        List<Comment> listdata = []; //null

        List<dynamic> list = json.decode(res.body);

        listdata = list.map((d) {
          return Comment.fromMap(d);
        }).toList();
        resp.myState = MyState.data;
        resp.data = listdata;
        cmtController.sink.add(resp);
      } else {
        resp.myState==MyState.error;
        resp.data="data fecting error";
        cmtController.sink.add(resp);
      }
    }).catchError((e) {
      resp.myState = MyState.error;
      resp.data = "data fetcting error";
      cmtController.sink.add(resp);
    });
  }
}
