import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_internship/widgets/resuble_navigation_push.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../screens/details_screen.dart';
import '../screens/update_todo_screen.dart';

class TodoListWidget extends StatelessWidget {
  final List<TodoModel> todos;

  const TodoListWidget({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checklist_rounded,
              size: 100,
              color: Colors.deepPurple.withOpacity(0.5),
            ).animate().scale(duration: 500.ms),
            const Text(
              'No Todos Yet!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(duration: 500.ms),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItemCard(todo: todo)
            .animate()
            .slideX(begin: 1, duration: 300.ms, curve: Curves.easeOut);
      },
    );
  }
}

class TimeAgo {
  static String format(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} y';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} mo';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} m';
    } else {
      return 'now';
    }
  }
}

class TodoItemCard extends StatelessWidget {
  final TodoModel todo;

  const TodoItemCard({super.key, required this.todo});

  Color _getPriorityColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    switch (todo.priority) {
      case Priority.high:
        return isDarkMode ? Colors.red[300]! : Colors.red;
      case Priority.medium:
        return isDarkMode ? Colors.orange[300]! : Colors.orange;
      default:
        return isDarkMode ? Colors.green[300]! : Colors.green;
    }
  }

  IconData _getPriorityIcon() {
    switch (todo.priority) {
      case Priority.high:
        return Icons.priority_high;
      case Priority.medium:
        return Icons.report;
      default:
        return Icons.low_priority;
    }
  }

  void _showToggleConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    todo.isCompleted
                        ? Icons.restart_alt_rounded
                        : Icons.check_circle_outline,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "Change Task Status",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              Text(
                todo.isCompleted
                    ? "Are you sure you want to mark this task as incomplete? This will move the task back to your active tasks."
                    : "Are you sure you want to mark this task as completed? This will move the task to your completed list.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),

                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<TodoProvider>(context, listen: false)
                            .toggleTodoStatus(todo.id);
                        Navigator.of(context).pop();
                      },

                      child: Text(
                        "Confirm",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Delete Task?",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to delete this task? This action cannot be undone and will permanently remove the task from your list.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<TodoProvider>(context, listen: false)
                            .deleteTodo(todo.id);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: Text(
                        "Delete",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priorityColor = _getPriorityColor(context);

    return InkWell(
      onLongPress: () {
        _showTodoOptionsBottomSheet(context);
      },
      onTap: () {
        navigateWithFadeTransition(
          context: context,
          targetPage: TaskDetailsScreen(todo: todo),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                priorityColor.withOpacity(0.2),
                theme.cardColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: priorityColor, width: 2),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: priorityColor.withOpacity(0.7),
                child: Icon(
                  _getPriorityIcon(),
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            todo.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              decoration: todo.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: todo.isCompleted
                                  ? theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.5)
                                  : theme.textTheme.titleMedium?.color,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          TimeAgo.format(todo.createdAt),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    if (todo.description.isNotEmpty)
                      Text(
                        todo.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.textTheme.bodySmall?.color
                              ?.withOpacity(0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) => _showToggleConfirmationDialog(context),
                    activeColor: priorityColor,
                    checkColor: theme.colorScheme.onPrimary,
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showTodoOptionsBottomSheet(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTodoOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                thickness: 2,
              ),
              // Edit Button
              _buildOptionButton(
                context,
                icon: Icons.edit,
                label: 'Edit Task',
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateTodoScreen(todoToUpdate: todo),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Delete Button
              _buildOptionButton(
                context,
                icon: Icons.delete,
                label: 'Delete Task',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _showDeleteConfirmationDialog(context);
                },
              ),
              const SizedBox(height: 16),

              // Cancel Button
              _buildOptionButton(
                context,
                icon: Icons.cancel,
                label: 'Cancel',
                color: Colors.grey,
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                },
              ),
              const Divider(
                thickness: 2,
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
