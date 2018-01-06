import 'dart:async';

import 'package:gank_flutter/app/data/pojo/gank.dart';


abstract class GankRepository{

  Future<List<Gank>> fetch(String category, int size);

}