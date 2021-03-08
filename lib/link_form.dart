import 'package:CWCFlutter/bloc/link_bloc.dart';
import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/add_link.dart';
import 'package:CWCFlutter/events/update_link.dart';
import 'package:CWCFlutter/model/link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LinkForm extends StatefulWidget {
  final Link link;
  final int linkIndex;

  LinkForm({this.link, this.linkIndex});

  @override
  State<StatefulWidget> createState() {
    return LinkFormState();
  }
}

class LinkFormState extends State<LinkForm> {
  String title;
  String url;
  bool date = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget buildTitle() {
    return TextFormField(
      initialValue: title,
      decoration: InputDecoration(labelText: 'Title'),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title is Required';
        }

        return null;
      },
      onSaved: (String value) {
        title = value;
      },
    );
  }

  Widget buildUrl() {
    return TextFormField(
      initialValue: url,
      decoration: InputDecoration(labelText: 'URL'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        int url = int.tryParse(value);

        if (url == null || url <= 0) {
          return 'Url must be greater than 0';
        }

        return null;
      },
      onSaved: (String value) {
        url = value;
      },
    );
  }

  Widget buildImp() {
    return SwitchListTile(
      title: Text("Is Important?", style: TextStyle(fontSize: 20)),
      value: date,
      onChanged: (bool newValue) => setState(() {
        date = newValue;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.link != null) {
      title = widget.link.title;
      url = widget.link.url;
      date = widget.link.isImp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.1),
      appBar: AppBar(title: Text("Create New Card")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildTitle(),
                  buildUrl(),
                  SizedBox(height: 16),
                  buildImp(),
                  SizedBox(height: 20),
                  widget.link == null
                      ? RaisedButton(
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }

                            _formKey.currentState.save();

                            Link link = Link(
                              title: title,
                              url: url,
                              isImp: date,
                            );

                            DatabaseProvider.db.insert(link).then(
                                  (storedLink) =>
                                      BlocProvider.of<LinkBloc>(context).add(
                                    AddLink(storedLink),
                                  ),
                                );

                            Navigator.pop(context);
                          },
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            RaisedButton(
                              child: Text(
                                "Update",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                              onPressed: () {
                                if (!_formKey.currentState.validate()) {
                                  print("form");
                                  return;
                                }

                                _formKey.currentState.save();

                                Link link = Link(
                                  title: title,
                                  url: url,
                                  isImp: date,
                                );

                                DatabaseProvider.db.update(widget.link).then(
                                      (storedLink) =>
                                          BlocProvider.of<LinkBloc>(context)
                                              .add(
                                        UpdateLink(widget.linkIndex, link),
                                      ),
                                    );

                                Navigator.pop(context);
                              },
                            ),
                            RaisedButton(
                              child: Text(
                                "Cancel",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
