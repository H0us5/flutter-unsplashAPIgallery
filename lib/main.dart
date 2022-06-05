import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var urlData;
  void getApiData() async {
    var url = Uri.parse(
        "https://api.unsplash.com/photos/?client_id=ab3411e4ac868c2646c0ed488dfd919ef612b04c264f3374c97fff98ed253dc9");
    final res = await http.get(url);
    setState(() {
      urlData = jsonDecode(res.body);
    });
  }

  @override
  void initState() {
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test App'),
        ),
        body: Center(
            child: urlData == null
                ? CircularProgressIndicator()
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 6,
                        crossAxisCount: 2,
                        crossAxisSpacing: 6),
                    itemBuilder: (context, i) {
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FullImageView(
                                        url: urlData[i]['urls']['full'])));
                          },
                          child: Hero(
                            tag: 'full',
                            child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            urlData[i]['urls']['full'])))),
                          ));
                    })));
  }
}

class FullImageView extends StatelessWidget {
  var url;
  FullImageView({this.url});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "full",
        child: Container(
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)),
        ));
  }
}
