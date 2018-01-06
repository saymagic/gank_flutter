import 'package:flutter/material.dart';
import 'package:gank_flutter/app/module/home/gank_list_widget.dart';
import 'package:gank_flutter/app/util/constants.dart';

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() => new HomePageState();

}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TabController _tabController;
  _Page _selectedPage;
  bool _changed;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _pages.length);
    _tabController.addListener(_handleTabSelection);
    _selectedPage = _pages[0];
  }

  void _handleTabSelection() {
    setState(() {
      _selectedPage = _pages[_tabController.index];
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildTabWidget(_Page page) {
    return new GankListPage(page.key, 20);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
            title: const Text("Gank"),
            bottom: new TabBar(
                isScrollable: true,
                controller: _tabController,
                tabs: _pages.map((_Page page) => new Tab(text: page.label,))
                    .toList(),
                ),
            ),
        body: new TabBarView(
            controller: _tabController,
            children: _pages.map(buildTabWidget).toList()),
        );
  }

}


class _Page {

  _Page({this.key, this.label});

  final String key;

  final String label;

}

final List<_Page> _pages = <_Page>[
  new _Page(key: KEY_ANDROID, label: KEY_ANDROID),
  new _Page(key: KEY_IOS, label: KEY_IOS),
  new _Page(key: KEY_WELFARE, label: KEY_WELFARE),
  new _Page(key: KEY_WEB, label: KEY_WEB),
  new _Page(key: KEY_VIDEO, label: KEY_VIDEO),
  new _Page(key: KEY_APP, label: KEY_APP),
  new _Page(key: KEY_EXPAND_RESOURCSES, label: KEY_EXPAND_RESOURCSES),
  new _Page(key: KEY_RECOMMENDED, label: KEY_RECOMMENDED),
  new _Page(key: KEY_ALL, label: "随便看看"),
];