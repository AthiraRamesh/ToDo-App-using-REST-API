import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/services/todo_service.dart';
import 'package:todo_api/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(hintText: 'Description'),
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: 8,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: isEdit ? UpdateData : submitData,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(isEdit ? 'Update' : 'Submit'),
                ))
          ],
        ),
      ),
    );
  }

  Future<void> UpdateData() async {
    // get the data from form
    // get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print("You can't call updated without todo data");
      return;
    }
    final id = todo['_id'];

    // submit updated data to the server

    final isSuccess = await TodoService.UpdateTodo(id, body);

    // show success or fail message based on status

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      print("Creation Success");
      showSuccessMessage(context, message: "Updation Success");
    } else {
      print('Creation Failed');
      showErrorMessage(context, message: "Updation Failed");
    }
  }

  Future<void> submitData() async {
    // submit data to the server
    final isSuccess = await TodoService.addTodo(body);

    // show success or fail message based on status

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      print("Creation Success");
      showSuccessMessage(context, message: "Creation Success");
    } else {
      showErrorMessage(context, message: " Creation failed");
    }
  }

  Map get body {
// get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {"title": title, "description": description, "is_completed": false};
  }
}
