import 'package:CWCFlutter/bloc/link_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:CWCFlutter/link_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LinkBloc>(
      create: (context) => LinkBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Links Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LinkList(),
      ),
    );
  }
}
