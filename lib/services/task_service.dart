import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskService {
  static const String _storageKey = 'tasks';
  final _tasksStreamController = StreamController<List<Task>>.broadcast();
  List<Task> _tasks = [];

  // Singleton pattern
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  Stream<List<Task>> get tasksStream => _tasksStreamController.stream;
  List<Task> get tasks => List.unmodifiable(_tasks);

  Future<void> init() async {
    await _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (kIsWeb) {
        // Web implementation
        final tasksJsonString = prefs.getString(_storageKey);
        if (tasksJsonString != null && tasksJsonString.isNotEmpty) {
          final List<dynamic> decodedList = json.decode(tasksJsonString);
          _tasks = decodedList
              .map((task) => Task.fromJson(task))
              .toList();
        }
      } else {
        // Mobile implementation
        final tasksJson = prefs.getStringList(_storageKey);
        if (tasksJson != null) {
          _tasks = tasksJson
              .map((taskJson) => Task.fromJson(json.decode(taskJson)))
              .toList();
        }
      }
      
      _tasksStreamController.add(_tasks);
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (kIsWeb) {
        // Web implementation
        final List<Map<String, dynamic>> jsonList = 
            _tasks.map((task) => task.toJson()).toList();
        await prefs.setString(_storageKey, json.encode(jsonList));
      } else {
        // Mobile implementation
        final tasksJson = _tasks
            .map((task) => json.encode(task.toJson()))
            .toList();
        await prefs.setStringList(_storageKey, tasksJson);
      }
      
      _tasksStreamController.add(_tasks);
    } catch (e) {
      print('Error saving tasks: $e');
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveTasks();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      _tasks[index] = task;
      await _saveTasks();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveTasks();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index >= 0) {
      final task = _tasks[index];
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      await _saveTasks();
    }
  }

  List<Task> getTasksByCategory(String category) {
    return _tasks.where((task) => task.category == category).toList();
  }

  List<Task> getTasksByPriority(int priority) {
    return _tasks.where((task) => task.priority == priority).toList();
  }

  dispose() {
    _tasksStreamController.close();
  }
}