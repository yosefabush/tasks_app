import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final TextEditingController _taskController = TextEditingController();
  String _filter = 'all'; // all, active, completed

  @override
  void initState() {
    super.initState();
    _taskService.init();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_taskController.text.trim().isEmpty) return;
    
    final task = Task(
      id: const Uuid().v4(),
      title: _taskController.text.trim(),
      createdAt: DateTime.now(),
    );
    
    _taskService.addTask(task);
    _taskController.clear();
  }

  List<Task> _getFilteredTasks(List<Task> tasks) {
    switch (_filter) {
      case 'active':
        return tasks.where((task) => !task.isCompleted).toList();
      case 'completed':
        return tasks.where((task) => task.isCompleted).toList();
      default:
        return tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
        actions: [
          if (isWideScreen) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _filter = 'all';
                  });
                },
                child: Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('All'),
                      if (_filter == 'all')
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.check, size: 18, 
                            color: Theme.of(context).colorScheme.primary),
                        ),
                    ],
                  ),
                  backgroundColor: _filter == 'all'
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // Toggle between 'active' and 'all'
                    _filter = (_filter == 'active') ? 'all' : 'active';
                  });
                },
                child: Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Active'),
                      if (_filter == 'active')
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.check, size: 18, 
                            color: Theme.of(context).colorScheme.primary),
                        ),
                    ],
                  ),
                  backgroundColor: _filter == 'active'
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    // Toggle between 'completed' and 'all'
                    _filter = (_filter == 'completed') ? 'all' : 'completed';
                  });
                },
                child: Chip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Completed'),
                      if (_filter == 'completed')
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.check, size: 18, 
                            color: Theme.of(context).colorScheme.primary),
                        ),
                    ],
                  ),
                  backgroundColor: _filter == 'completed'
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ] else
            Row(
              children: [
                Text(
                  _getFilterText(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      // Toggle if selecting the already active filter
                      if (value == _filter) {
                        _filter = 'all';
                      } else {
                        _filter = value;
                      }
                    });
                  },
                  icon: const Icon(Icons.filter_list),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'all',
                      child: Row(
                        children: [
                          if (_filter == 'all')
                            Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          SizedBox(width: _filter == 'all' ? 8 : 32),
                          const Text('All Tasks'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'active',
                      child: Row(
                        children: [
                          if (_filter == 'active')
                            Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          SizedBox(width: _filter == 'active' ? 8 : 32),
                          const Text('Active Tasks'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'completed',
                      child: Row(
                        children: [
                          if (_filter == 'completed')
                            Icon(
                              Icons.check,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          SizedBox(width: _filter == 'completed' ? 8 : 32),
                          const Text('Completed Tasks'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new task',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.tasksStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final tasks = snapshot.data ?? [];
                final filteredTasks = _getFilteredTasks(tasks);
                
                if (filteredTasks.isEmpty) {
                  return Center(
                    child: Text(
                      'No ${_filter == 'all' ? '' : _filter} tasks found',
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }
                
                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return Dismissible(
                      key: Key(task.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        _taskService.deleteTask(task.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${task.title} deleted'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                _taskService.addTask(task);
                              },
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) {
                            _taskService.toggleTaskCompletion(task.id);
                          },
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted 
                                ? TextDecoration.lineThrough 
                                : null,
                            color: task.isCompleted 
                                ? Colors.grey 
                                : null,
                          ),
                        ),
                        subtitle: task.dueDate != null 
                            ? Text(
                                'Due: ${task.dueDate.toString().split(' ')[0]}',
                                style: TextStyle(
                                  color: task.dueDate!.isBefore(DateTime.now()) && !task.isCompleted
                                      ? Colors.red
                                      : null,
                                ),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (task.priority > 1)
                              Icon(
                                Icons.priority_high,
                                color: task.priority == 3 ? Colors.red : Colors.orange,
                              ),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, size: 16),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDetailScreen(taskId: task.id),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(taskId: task.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    ));
  }
  
  String _getFilterText() {
    switch (_filter) {
      case 'all':
        return 'All';
      case 'active':
        return 'Active';
      case 'completed':
        return 'Completed';
      default:
        return '';
    }
  }
}