import 'package:CWCFlutter/db/database_provider.dart';

class Link {
  int id;
  String title;
  String url;
  bool isImp;

  Link({this.id, this.title, this.url, this.isImp});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_TITLE: title,
      DatabaseProvider.COLUMN_URL: url,
      DatabaseProvider.COLUMN_IMP: isImp ? 1 : 0
    };

    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }

    return map;
  }

  Link.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    title = map[DatabaseProvider.COLUMN_TITLE];
    url = map[DatabaseProvider.COLUMN_URL];
    isImp = map[DatabaseProvider.COLUMN_IMP] == 1;
  }
}
