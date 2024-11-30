import 'package:flutter/material.dart';

import '../models/list_etudiants.dart';
import '../models/scol_list.dart';
import '../util/dbuse.dart';
import 'list_student_dialog.dart';

class StudentsScreen extends StatefulWidget {
  final ScolList scolList;
  StudentsScreen(this.scolList);

  @override
  _StudentsScreenState createState() => _StudentsScreenState(this.scolList);
}

class _StudentsScreenState extends State<StudentsScreen> {
  final ScolList scolList;
  final dbuse helper = dbuse();
  List<ListEtudiants> students = [];

  _StudentsScreenState(this.scolList);

  @override
  Widget build(BuildContext context) {
    showData(this.scolList.codClass);

    return Scaffold(
      appBar: AppBar(
        title: Text(scolList.nomClass),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(students[index]
                .id
                .toString()), // Using student ID as unique key
            onDismissed: (direction) {
              String strName = students[index].nom;
              helper.deleteStudent(
                  students[index]); // Delete the student from the database
              setState(() {
                students.removeAt(index); // Remove the student from the list
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$strName deleted")));
            },
            child: ListTile(
              title: Text(students[index].nom),
              subtitle: Text(
                  'Prenom: ${students[index].prenom} - Date Nais: ${students[index].datNais}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => ListStudentDialog()
                        .buildAlert(context, students[index], false),
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
            builder: (BuildContext context) => ListStudentDialog().buildAlert(
                context, ListEtudiants(0, scolList.codClass, '', '', ''), true),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future showData(int idList) async {
    await helper.openDb();
    students = await helper.getEtudiants(idList);
    setState(() {});
  }
}
