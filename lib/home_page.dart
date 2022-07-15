import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:geek_marvel/model/mcu_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var marvelApiUrl = "https://mcuapi.herokuapp.com/api/v1/movies";

  List<McuModels> mcuMovieslist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMarvelComics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
        body: mcuMovieslist.isNotEmpty
            ? GridView.builder(
                itemCount: mcuMovieslist.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: mcuMovieslist[index]!.coverUrl!=null
                      ?CachedNetworkImage(
                      imageUrl:
                      mcuMovieslist[index]!.coverUrl.toString(),
                      placeholder:(context,url)=>
                          Image.asset('image/spiderman.png'),
                    )
                    :Image.asset('image/spiderman.png'));


                },
              )
            : Center(
               child:Container(
                width: 50,
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white70),
                ),
              ),
              ));
  }

  void getMarvelComics() {
    debugPrint('=========Function running ==========');
    final uri = Uri.parse(marvelApiUrl);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodeData = jsonDecode(responseBody);
        final List marvelData = decodeData['data'];
        for (var i = 0; i < marvelData.length; i++) {
          final mcuMovie =
              McuModels.fromJson(marvelData[i] as Map<String, dynamic>);
          mcuMovieslist.add(mcuMovie);
        }

        setState(() {});
      } else {}
    }).catchError((err) {
      debugPrint('=========$err==========');
    });
  }
}
