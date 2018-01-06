
class Gank {

  final String author;

  final String url;

  final String desc;

  final String type;

  final List<String> pics;

  Gank(this.author, this.url, this.type, this.desc, this.pics);

  static Gank fromMap(Map map) {
    if(map["who"] == null){
      map["who"] = "";
    }
    if(map["desc"] == null){
      map["desc"] = "";
    }
    if(map["url"] == null){
      map["url"] = "";
    }
    return new Gank(map["who"], map["url"], map['type'], map["desc"], map["pics"]);
  }

}