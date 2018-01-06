import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:gank_flutter/app/data/pojo/gank.dart';
import 'package:gank_flutter/app/data/repository/remote_repository.dart';

final String HOST_URL = "https://gank.io/api/random/data/";


class GankRepositoryImpl extends GankRepository {

  var httpClient = createHttpClient();

  @override
  Future<List<Gank>> fetch(String category, int size) async{
    String url = HOST_URL + category + "/" + size.toString();
    print("fetch " + url);
    var response = await httpClient.get(url);
    print('response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      Map data = JSON.decode(response.body);
      if (data != null && data["error"] == false) {
        List<Gank> gankList = data["results"].map((obj) =>
            Gank.fromMap(obj)).toList();
        print("article size ${gankList.length}");
        return gankList;
      }
    }
    throw new FetchDataException("fetch error");
  }
}

class FetchDataException implements Exception {
  String _message;

  FetchDataException(this._message);

  String toString() {
    return "Exception: $_message";
  }
}