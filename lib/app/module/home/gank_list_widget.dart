import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gank_flutter/app/data/pojo/gank.dart';
import 'package:gank_flutter/app/data/pojo/photo.dart';
import 'package:gank_flutter/app/module/home/home_contract.dart';
import 'package:gank_flutter/app/module/home/photo_widget.dart';
import 'package:gank_flutter/app/util/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class GankListPage extends StatefulWidget {

  final String category;

  final int size;

  GankListPage(this.category, this.size);

  @override
  GankListState createState() {
    GankListState state = new GankListState(category, size);
    new GankHomePresenterContractImpl(state);
    return state;
  }

}

class GankListState extends State<GankListPage>
    implements GankHomeViewContract {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<
      RefreshIndicatorState>();

  static const int STATE_LOADING = 0;
  static final int STATE_FAILED = 1;
  static final int STATE_SUCCESS = 2;

  int _state;

  List<Gank> _ganks = new List();

  final String _category;

  final int _size;

  GankHomePresenterContract _presenter;

  GankListState(this._category, this._size);

  @override
  void initState() {
    _presenter.loadGanks(_category, _size, null);
  }

  Widget _buildGankWidget(Gank gank) {
    if (gank.type == KEY_WELFARE) {
      var picWidth = MediaQuery
          .of(context)
          .size
          .width * 0.9;
      return new GestureDetector(
          onTap: () => _onTapPicGank(gank),
          child: new Card(
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        margin: const EdgeInsets.all(10.0),
                        child: new Center(
                            child: new Image.network(
                                gank.url + "?imageView2/0/w/" +
                                    picWidth.toString(),
                                fit: BoxFit.cover, width: picWidth),
                            )
                    ),
                    new Text(gank.author)
                  ],),
              ));
    } else {
      return new Card(
          child: new ListTile(
              onTap: () => _onTapArticleGank(gank),
              title: new Text(gank.desc),
              subtitle: new Text(gank.author),
              ),
          );
    }
  }

  Future<Null> _handleRefresh() {
    final Completer<Null> completer = new Completer<Null>();
    _presenter.loadGanks(_category, _size, completer);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    Widget _body = null;
    if (_state == STATE_SUCCESS || _state == STATE_LOADING) {
      _body = new ListView.builder(
          itemCount: _ganks == null ? 0 : _ganks.length,
          itemBuilder: (context, index) => _buildGankWidget(_ganks[index]),
          );
    } else {
      _body = new Center(
          child: new Text("加载失败，请稍后重试")
      );
    }
    return new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        child: _body);
  }


  @override
  bool isMounted() {
    return mounted;
  }

  @override
  void setPresenter(GankHomePresenterContract presenter) {
    this._presenter = presenter;
  }

  @override
  void showNewGanks(List<Gank> ganks) {
    List newGanks = new List();
    newGanks.addAll(ganks);
    newGanks.addAll(_ganks);
    setState(() {
      this._state = STATE_SUCCESS;
      this._ganks = newGanks;
    });
  }

  @override
  void showLoadError() {
    setState(() {
      this._state = STATE_FAILED;
    });
  }

  @override
  void showLoading() {
    setState(() {
      this._state = STATE_LOADING;
    });
  }

  _onTapArticleGank(Gank gank){
    String url = gank.url;
    launch(url);
  }

  _onTapPicGank(Gank gank) {
    Photo photo = new Photo(
        url: gank.url, title: "Recommended by " + gank.author);
    Navigator.push(context, new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return new Scaffold(
              appBar: new AppBar(
                  title: new Text(photo.title)
              ),
              body: new SizedBox.expand(
                  child: new Hero(
                      tag: gank.url,
                      child: new GridPhotoViewer(photo: photo),
                      ),
                  ),
              );
        }
    ));
  }
}