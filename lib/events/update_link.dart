import 'package:CWCFlutter/model/link.dart';

import 'link_event.dart';

class UpdateLink extends LinkEvent {
  Link newLink;
  int linkIndex;

  UpdateLink(int index, Link link) {
    newLink = link;
    linkIndex = index;
  }
}
