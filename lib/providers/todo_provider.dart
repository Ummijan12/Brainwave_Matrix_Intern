import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_internship/widgets/toast_utils.dart';
import '../models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  static const String _boxName = 'todoBox';
  late Box<TodoModel> _todoBox;
  List<TodoModel> _todos = [];
  bool _isLoading = false;

  List<TodoModel> get todos => _todos;
  List<TodoModel> get incompleteTodos =>
      _todos.where((todo) => !todo.isCompleted).toList();
  List<TodoModel> get completedTodos =>
      _todos.where((todo) => todo.isCompleted).toList();
  bool get isLoading => _isLoading;

  TodoProvider() {
    Future.delayed(Duration(seconds: 15));
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _setLoading(true);
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDir.path)
      ..registerAdapter(TodoModelAdapter())
      ..registerAdapter(PriorityAdapter());

    // Open the todo box
    _todoBox = await Hive.openBox<TodoModel>(_boxName);

    _todos = _todoBox.values.toList();

    _setLoading(false);
    notifyListeners();
  }

  Future<void> addTodo(TodoModel todo) async {
    _setLoading(true);
    await _todoBox.put(todo.id, todo);
    _todos = _todoBox.values.toList();
    _setLoading(false);
    AppToast.success(message: "Successfully Added!");

    notifyListeners();
  }

  Future<void> updateTodo(TodoModel updatedTodo) async {
    _setLoading(true);
    await _todoBox.put(updatedTodo.id, updatedTodo);
    _todos = _todoBox.values.toList();
    _setLoading(false);
    AppToast.success(message: "Successfully Updated!");
    notifyListeners();
  }

  Future<void> deleteTodo(String id) async {
    _setLoading(true);
    await _todoBox.delete(id);
    _todos = _todoBox.values.toList();
    _setLoading(false);
    AppToast.success(message: "Successfully Deleted!");
    notifyListeners();
  }

  Future<void> toggleTodoStatus(String id) async {
    _setLoading(true);
    final todo = _todoBox.get(id);
    if (todo != null) {
      todo.isCompleted = !todo.isCompleted;
      await todo.save();
      _todos = _todoBox.values.toList();
      _setLoading(false);
      AppToast.success(message: "Successfully");
      notifyListeners();
    }
  }

  Future<void> deleteAllTodos() async {
    _setLoading(true);
    await _todoBox.clear();
    _todos = [];
    _setLoading(false);
    notifyListeners();
    AppToast.success(message: "Successfully Deleted!");
  }

  Future<void> closeBox() async {
    await _todoBox.close();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
