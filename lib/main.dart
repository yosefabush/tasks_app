import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'screens/home_screen.dart';
import 'models/task.dart';
import 'services/task_service.dart';
import 'widgets/responsive_container.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TasksApp());
}

class TasksApp extends StatelessWidget {
  const TasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: kIsWeb 
          ? const ResponsiveContainer(child: HomeScreen()) 
          : const HomeScreen(),
    );
  }
}