import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  Map<String, dynamic> map;

  PostWidget(this.map);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text("userId " + map["userId"].toString()),
          Text("Id " + map["id"].toString()),
          Text(
            "title  " + map["title"],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text("body" + map["body"]),
        ],
      ),
    );
  }
}
