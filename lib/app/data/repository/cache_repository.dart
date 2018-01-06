import 'package:gank_flutter/app/data/pojo/gank.dart';


abstract class CacheRepository {

  List<Gank> get(String category);

  void save(String category, List<Gank> ganks);

}

class CacheRepositoryImpl extends CacheRepository {

  Map<String, List<Gank>> map = new Map();

  @override
  List<Gank> get(String category) {
    List<Gank> ganks = map[category];
    return ganks == null ? new List() : ganks;
  }

  @override
  void save(String category, List<Gank> ganks) {
    List<Gank> originGanks = map[category];
    List<Gank> newGanks = new List<Gank>();
    if (originGanks == null) {
      newGanks.addAll(ganks);
    } else {
      newGanks.addAll(ganks);
      newGanks.addAll(originGanks);
    }
    map[category] = newGanks;
  }
}