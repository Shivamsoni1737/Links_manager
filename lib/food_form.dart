import 'package:CWCFlutter/bloc/food_bloc.dart';
import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/add_food.dart';
import 'package:CWCFlutter/events/update_food.dart';
import 'package:CWCFlutter/model/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodForm extends StatefulWidget {
  final Food food;
  final int foodIndex;

  FoodForm({this.food, this.foodIndex});

  @override
  State<StatefulWidget> createState() {
    return FoodFormState();
  }
}

class FoodFormState extends State<FoodForm> {
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

  Widget _buildCalories() {
    return TextFormField(
      initialValue: url,
      decoration: InputDecoration(labelText: 'Calories'),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        int calories = int.tryParse(value);

        if (calories == null || calories <= 0) {
          return 'Calories must be greater than 0';
        }

        return null;
      },
      onSaved: (String value) {
        url = value;
      },
    );
  }

  Widget _buildIsVegan() {
    return SwitchListTile(
      title: Text("Vegan?", style: TextStyle(fontSize: 20)),
      value: date,
      onChanged: (bool newValue) => setState(() {
        date = newValue;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.food != null) {
      title = widget.food.name;
      url = widget.food.calories;
      date = widget.food.isVegan;
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
                  _buildCalories(),
                  SizedBox(height: 16),
                  _buildIsVegan(),
                  SizedBox(height: 20),
                  widget.food == null
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

                            Food food = Food(
                              name: title,
                              calories: url,
                              isVegan: date,
                            );

                            DatabaseProvider.db.insert(food).then(
                                  (storedFood) =>
                                      BlocProvider.of<FoodBloc>(context).add(
                                    AddFood(storedFood),
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

                                Food food = Food(
                                  name: title,
                                  calories: url,
                                  isVegan: date,
                                );

                                DatabaseProvider.db.update(widget.food).then(
                                      (storedFood) =>
                                          BlocProvider.of<FoodBloc>(context)
                                              .add(
                                        UpdateFood(widget.foodIndex, food),
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
