import 'package:CWCFlutter/model/link.dart';

import 'link_event.dart';

class AddLink extends LinkEvent {
  Link newLink;

  AddLink(Link link) {
    newLink = link;
  }
}
