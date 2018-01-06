import 'dart:async';

import 'package:gank_flutter/app/data/pojo/gank.dart';
import 'package:gank_flutter/app/data/repository/injector.dart';


abstract class GankHomeViewContract {

  void setPresenter(GankHomePresenterContract presenter);

  bool isMounted();

  void showNewGanks(List<Gank> ganks);

  void showLoadError();

  void showLoading();

}

abstract class GankHomePresenterContract {
  void loadGanks(String category, int size, Completer completer);
}

class GankHomePresenterContractImpl extends GankHomePresenterContract {

  GankHomeViewContract _view;

  Injector _injector = new Injector();

  List<Gank> ganks = new List<Gank>();

  GankHomePresenterContractImpl(this._view) {
    _view.setPresenter(this);
  }

  @override
  void loadGanks(String category, int size, Completer completer) {
    List<Gank> cacheGanks = _injector.cacheRepository.get(category);
    if(completer == null && cacheGanks.isNotEmpty){
      _view.showNewGanks(cacheGanks);
      return;
    }
    _view.showLoading();
    new Injector().remoteRepository.fetch(category, size)
        .then((ganks) {
      if (_view.isMounted()) {
        _injector.cacheRepository.save(category, ganks);
        _view.showNewGanks(_injector.cacheRepository.get(category));
      }
    }).catchError((error) {
      print(error);
      _view.showLoadError();
    }).whenComplete(() {
      if(completer != null){
        completer.complete();
      }
    });
  }


}

