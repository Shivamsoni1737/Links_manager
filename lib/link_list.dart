import 'package:CWCFlutter/bloc/link_bloc.dart';
import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/delete_link.dart';
import 'package:CWCFlutter/events/set_links.dart';
import 'package:CWCFlutter/link_form.dart';
import 'package:CWCFlutter/model/link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LinkList extends StatefulWidget {
  const LinkList({Key key}) : super(key: key);

  @override
  _LinkListState createState() => _LinkListState();
}

class _LinkListState extends State<LinkList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getLinks().then(
      (linkList) {
        BlocProvider.of<LinkBloc>(context).add(SetLinks(linkList));
      },
    );
  }

  showLinkDialog(BuildContext context, Link link, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(link.title),
        content: Text("ID ${link.id}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LinkForm(link: link, linkIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(link.id).then((_) {
              BlocProvider.of<LinkBloc>(context).add(
                DeleteLink(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("Building entire Links list scaffold");
    return Scaffold(
      appBar: AppBar(
        title: Text("Links Manager"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/link_icon.png',
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        color: Colors.grey[200],
        child: BlocConsumer<LinkBloc, List<Link>>(
          builder: (context, linkList) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                print("linkList: $linkList");

                Link link = linkList[index];
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    leading: Icon(Icons.circle),
                    title: Text(link.title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      "Url: ${link.url}",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Text("Date: ${link.isImp}"),
                    onTap: () => showLinkDialog(context, link, index),
                  ),
                );
              },
              itemCount: linkList.length,
            );
          },
          listener: (BuildContext context, linkList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LinkForm()),
        ),
      ),
    );
  }
}
