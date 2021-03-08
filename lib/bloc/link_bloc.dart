import 'package:CWCFlutter/events/add_link.dart';
import 'package:CWCFlutter/events/delete_link.dart';
import 'package:CWCFlutter/events/link_event.dart';
import 'package:CWCFlutter/events/set_links.dart';
import 'package:CWCFlutter/events/update_link.dart';
import 'package:CWCFlutter/model/link.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LinkBloc extends Bloc<LinkEvent, List<Link>> {
  @override
  List<Link> get initialState => List<Link>();

  @override
  Stream<List<Link>> mapEventToState(LinkEvent event) async* {
    if (event is SetLinks) {
      yield event.linkList;
    } else if (event is AddLink) {
      List<Link> newState = List.from(state);
      if (event.newLink != null) {
        newState.add(event.newLink);
      }
      yield newState;
    } else if (event is DeleteLink) {
      List<Link> newState = List.from(state);
      newState.removeAt(event.linkIndex);
      yield newState;
    } else if (event is UpdateLink) {
      List<Link> newState = List.from(state);
      newState[event.linkIndex] = event.newLink;
      yield newState;
    }
  }
}
