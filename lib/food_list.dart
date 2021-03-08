import 'package:CWCFlutter/db/database_provider.dart';
import 'package:CWCFlutter/events/delete_food.dart';
import 'package:CWCFlutter/events/set_foods.dart';
import 'package:CWCFlutter/food_form.dart';
import 'package:CWCFlutter/model/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/food_bloc.dart';

class FoodList extends StatefulWidget {
  const FoodList({Key key}) : super(key: key);

  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getFoods().then(
      (foodList) {
        BlocProvider.of<FoodBloc>(context).add(SetFoods(foodList));
      },
    );
  }

  showFoodDialog(BuildContext context, Food food, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(food.name),
        content: Text("ID ${food.id}"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FoodForm(food: food, foodIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(food.id).then((_) {
              BlocProvider.of<FoodBloc>(context).add(
                DeleteFood(index),
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
        child: BlocConsumer<FoodBloc, List<Food>>(
          builder: (context, foodList) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                // print("foodList: $foodList");

                Food food = foodList[index];
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8),
                    leading: Icon(Icons.circle),
                    title: Text(food.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      "Url: ${food.calories}",
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Text("Date: ${food.isVegan}"),
                    onTap: () => showFoodDialog(context, food, index),
                  ),
                );
              },
              itemCount: foodList.length,
            );
          },
          listener: (BuildContext context, foodList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => FoodForm()),
        ),
      ),
    );
  }
}
