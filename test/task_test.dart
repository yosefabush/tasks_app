import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Task creation with required fields', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        createdAt: DateTime(2023, 1, 1),
      );
      
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.createdAt, DateTime(2023, 1, 1));
      expect(task.isCompleted, false);
      expect(task.priority, 1);
      expect(task.description, null);
      expect(task.dueDate, null);
      expect(task.category, null);
    });
    
    test('Task creation with all fields', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'This is a test task',
        createdAt: DateTime(2023, 1, 1),
        dueDate: DateTime(2023, 1, 2),
        isCompleted: true,
        category: 'Test',
        priority: 3,
      );
      
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'This is a test task');
      expect(task.createdAt, DateTime(2023, 1, 1));
      expect(task.dueDate, DateTime(2023, 1, 2));
      expect(task.isCompleted, true);
      expect(task.category, 'Test');
      expect(task.priority, 3);
    });
    
    test('Task copyWith method', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        createdAt: DateTime(2023, 1, 1),
      );
      
      final updatedTask = task.copyWith(
        title: 'Updated Task',
        description: 'Updated description',
        isCompleted: true,
      );
      
      expect(updatedTask.id, '1'); // Same as original
      expect(updatedTask.title, 'Updated Task'); // Updated
      expect(updatedTask.description, 'Updated description'); // Added
      expect(updatedTask.createdAt, DateTime(2023, 1, 1)); // Same as original
      expect(updatedTask.isCompleted, true); // Updated
      expect(updatedTask.priority, 1); // Same as original
    });
    
    test('Task toJson and fromJson', () {
      final task = Task(
        id: '1',
        title: 'Test Task',
        description: 'This is a test task',
        createdAt: DateTime(2023, 1, 1),
        dueDate: DateTime(2023, 1, 2),
        isCompleted: true,
        category: 'Test',
        priority: 3,
      );
      
      final json = task.toJson();
      final taskFromJson = Task.fromJson(json);
      
      expect(taskFromJson.id, task.id);
      expect(taskFromJson.title, task.title);
      expect(taskFromJson.description, task.description);
      expect(taskFromJson.createdAt.toString(), task.createdAt.toString());
      expect(taskFromJson.dueDate.toString(), task.dueDate.toString());
      expect(taskFromJson.isCompleted, task.isCompleted);
      expect(taskFromJson.category, task.category);
      expect(taskFromJson.priority, task.priority);
    });
  });
}