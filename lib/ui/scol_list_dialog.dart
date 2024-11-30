import 'package:flutter/material.dart';

import '../models/scol_list.dart';
import '../util/dbuse.dart';

class ScolListDialog {
  final txtNonClass = TextEditingController();
  final txtNbreEtud = TextEditingController();

  Widget buildDialog(BuildContext context, ScolList list, bool isNew) {
    dbuse helper = dbuse();
    if (!isNew) {
      txtNonClass.text = list.nomClass;
      txtNbreEtud.text = list.nbreEtud.toString();
    }

    return AlertDialog(
      title: Text((isNew) ? 'New Class' : 'Edit Class'),
      content: SingleChildScrollView(
          child: Column(children: <Widget>[
            TextField(
                controller: txtNonClass,
                decoration: InputDecoration(hintText: 'Class Name')),
            TextField(
                controller: txtNbreEtud,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Number of students')),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                list.nomClass = txtNonClass.text;
                list.nbreEtud = int.parse(txtNbreEtud.text);
                helper.insertClass(list);
                Navigator.pop(context);
              },
            ),
          ])),
    );
  }
}
