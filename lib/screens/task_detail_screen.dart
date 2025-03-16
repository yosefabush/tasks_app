import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TaskService _taskService = TaskService();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime? _dueDate;
  late String? _category;
  late int _priority;
  late bool _isCompleted;
  
  Task? _task;
  bool _isLoading = true;
  
  final List<String> _categories = [
    'Personal',
    'Work',
    'Shopping',
    'Health',
    'Education',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _loadTask() async {
    await Future.delayed(Duration.zero); // Wait for widget to be initialized
    
    setState(() {
      _isLoading = true;
    });
    
    // Find task by id
    _task = _taskService.tasks.firstWhere(
      (task) => task.id == widget.taskId,
      orElse: () => Task(
        id: '',
        title: '',
        createdAt: DateTime.now(),
      ),
    );
    
    if (_task!.id.isEmpty) {
      Navigator.pop(context);
      return;
    }
    
    _titleController = TextEditingController(text: _task!.title);
    _descriptionController = TextEditingController(text: _task!.description ?? '');
    _dueDate = _task!.dueDate;
    _category = _task!.category;
    _priority = _task!.priority;
    _isCompleted = _task!.isCompleted;
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _selectDueDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    
    if (pickedDate != null) {
      setState(() {
        _dueDate = pickedDate;
      });
    }
  }

  void _saveChanges() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }
    
    final updatedTask = _task!.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty 
          ? _descriptionController.text.trim() 
          : null,
      dueDate: _dueDate,
      category: _category,
      priority: _priority,
      isCompleted: _isCompleted,
    );
    
    _taskService.updateTask(updatedTask);
    Navigator.pop(context);
  }
  
  void _deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _taskService.deleteTask(_task!.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close screen
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTask,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              minLines: 3,
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _selectDueDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      _dueDate != null 
                          ? 'Due: ${_dueDate.toString().split(' ')[0]}'
                          : 'Set Due Date',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _dueDate == null 
                      ? null 
                      : () {
                          setState(() {
                            _dueDate = null;
                          });
                        },
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              value: _category,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('No Category'),
                ),
                ..._categories.map((category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                )).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  _category = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Priority:',
              style: TextStyle(fontSize: 16),
            ),
            Slider(
              value: _priority.toDouble(),
              min: 1,
              max: 3,
              divisions: 2,
              label: _getPriorityLabel(_priority),
              onChanged: (value) {
                setState(() {
                  _priority = value.toInt();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Low'),
                Text('Medium'),
                Text('High'),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Mark as completed'),
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Created: ${_task!.createdAt.toString().split('.')[0]}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
          ),
        ),
      ),
    );
  }
  
  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return '';
    }
  }
}