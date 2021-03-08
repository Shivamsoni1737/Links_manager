import 'link_event.dart';

class DeleteLink extends LinkEvent {
  int linkIndex;

  DeleteLink(int index) {
    linkIndex = index;
  }
}
