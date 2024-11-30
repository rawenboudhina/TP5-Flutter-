

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ui/scol_list_dialog.dart';
import 'ui/students_screen.dart';
import 'util/dbuse.dart';

import 'models/scol_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dbuse helper = dbuse();
    helper.testDb();

    return MaterialApp(
      title: 'Class List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ShList(),
    );
  }
}

class ShList extends StatefulWidget {
  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  List<ScolList> scolList = [];
  dbuse helper = dbuse();

  @override
  Widget build(BuildContext context) {
    showData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Classes List'),
      ),
      body: ListView.builder(
        itemCount: scolList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(scolList[index]
                .codClass
                .toString()), // Using codClass as unique key
            onDismissed: (direction) {
              String strName = scolList[index].nomClass;
              helper.deleteClass(
                  scolList[index]); // Delete the class from the database
              setState(() {
                scolList.removeAt(index); // Remove the class from the list
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$strName deleted")));
            },
            child: ListTile(
              title: Text(scolList[index].nomClass),
              leading: CircleAvatar(
                child: Text(scolList[index].codClass.toString()),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentsScreen(scolList[index]),
                  ),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ScolListDialog()
                        .buildDialog(context, scolList[index], false),
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                ScolListDialog().buildDialog(context, ScolList(0, '', 0), true),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future showData() async {
    await helper.openDb();
    scolList = await helper.getClasses();
    setState(() {});
  }
}