import 'package:gank_flutter/app/data/repository/cache_repository.dart';
import 'package:gank_flutter/app/data/repository/remote_repository.dart';
import 'package:gank_flutter/app/data/repository/remote_repository_impl.dart';

enum Flavor {
  MOCK,
  PROD
}

class Injector {

  static final Injector _singleton = new Injector._internal();

  static final CacheRepository _cache = new CacheRepositoryImpl();

  static final GankRepository _remote = new GankRepositoryImpl();
  static Flavor _flavor;

  static configureFlavor(Flavor flavor) {
    _flavor = flavor;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  GankRepository get remoteRepository {
    switch (_flavor) {
      case Flavor.MOCK:
        return new GankRepositoryImpl();
        break;
      default:
        return _remote;
    }
  }

  CacheRepository get cacheRepository {
    switch (_flavor) {
      case Flavor.MOCK:
        return new CacheRepositoryImpl();
        break;
      default:
        return _cache;
    }
  }

}