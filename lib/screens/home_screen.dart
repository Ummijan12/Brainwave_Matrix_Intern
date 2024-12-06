import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_internship/screens/about_screen.dart';
import 'package:todo_internship/screens/settings_screen.dart';
import '../providers/todo_provider.dart';
import '../widgets/animated_fab.dart';
import '../widgets/resuble_navigation_push.dart';
import '../widgets/todo_list_widget.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Master'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Show the Bottom Sheet with options
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25)), // Rounded top corners
                ),
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header title
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            "App Settings",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        // Settings Option
                        ListTile(
                          leading:
                              const Icon(Icons.settings, color: Colors.blue),
                          title: const Text(
                            "Settings",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text("Manage your app settings"),
                          onTap: () {
                            Navigator.pop(context); // Close the bottom sheet
                            navigateWithFadeTransition(
                              context: context,
                              targetPage: const SettingsScreen(),
                            );
                          },
                        ),
                        // About Option
                        ListTile(
                          leading: const Icon(Icons.info_outline,
                              color: Colors.green),
                          title: const Text(
                            "About",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: const Text("Learn more about the app"),
                          onTap: () {
                            Navigator.pop(context); // Close the bottom sheet
                            navigateWithFadeTransition(
                              context: context,
                              targetPage: const AboutScreen(),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: _getBodyWidget(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: AnimatedFAB(
        onAddTask: () {
          navigateWithFadeTransition(
            context: context,
            targetPage: const AddTodoScreen(),
          );
        },
      ),
    );
  }

  Widget _getBodyWidget() {
    final todoProvider = Provider.of<TodoProvider>(context);

    switch (_selectedIndex) {
      case 0:
        return TodoListWidget(todos: todoProvider.incompleteTodos);
      case 1:
        return TodoListWidget(todos: todoProvider.completedTodos);
      default:
        return TodoListWidget(todos: todoProvider.todos);
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Active',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle),
          label: 'Completed',
        ),
      ],
    );
  }
}
