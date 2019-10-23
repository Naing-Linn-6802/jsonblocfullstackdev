import 'dart:async';
import 'dart:convert';

import 'package:flatajsonblock/model/response.dart';
import 'package:flatajsonblock/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PostBlock {
  StreamController<Response> postController = StreamController();

  Stream<Response> postStream() => postController.stream;

  dispose() {

    postController.close();
  }

  getData() async {
    Response resp = Response(myState: MyState.loading, data: null);
    postController.sink.add(resp);

    List<Map<String, dynamic>> listdata = []; //null

    await http.get(POST_LINK).then((res) {
      if (res.statusCode == 200) {
        List<dynamic> list = json.decode(res.body);
        listdata = list.map((l) {
          Map<String, dynamic> map = Map();

          map["userId"] = l["userId"];
          map["id"] = l["id"];
          map["title"] = l["title"];
          map["body"] = l["body"];
          return map;
        }).toList();
        resp.myState = MyState.data;
        resp.data = listdata;
        postController.sink.add(resp);

//        list.forEach((l){
//
//          Map<String,dynamic>map=Map();
//
//          map["userId"]=l["userId"];
//          map["id"]=l["id"];
//          map["title"]=l["title"];
//          map["body"]=l["body"];
//
//          setState(() {
//            listdata.add(map);
//          });
//
//        });

      } else {
        resp.myState = MyState.error;
        resp.data = "data fetcting error";
        postController.sink.add(resp);
      }
    }).catchError((e) {
      resp.myState = MyState.error;
      resp.data = "data fetcting error";
      postController.sink.add(resp);
    });
  }
}
