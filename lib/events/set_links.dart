import 'package:CWCFlutter/model/link.dart';

import 'link_event.dart';

class SetLinks extends LinkEvent {
  List<Link> linkList;

  SetLinks(List<Link> links) {
    linkList = links;
  }
}
