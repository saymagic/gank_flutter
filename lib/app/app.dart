import 'package:flutter/material.dart';
import 'package:gank_flutter/app/data/repository/injector.dart';
import 'package:gank_flutter/app/module/home/home.dart';

class GankApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Injector.configureFlavor(Flavor.PROD);
    return new MaterialApp(
            title: 'Gank',
            theme: new ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
            // counter didn't reset back to zero; the application is not restarted.
                primarySwatch: Colors.indigo,
                ),
            home: new HomePage(),
        );
  }


}