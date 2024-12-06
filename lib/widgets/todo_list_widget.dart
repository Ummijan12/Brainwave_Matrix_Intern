import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_internship/widgets/resuble_navigation_push.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../screens/details_screen.dart';

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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.help_outline,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              "Change Task Status",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        content: Text(
          todo.isCompleted
              ? "Are you sure you want to mark this task as incomplete?"
              : "Are you sure you want to mark this task as completed?",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Provider.of<TodoProvider>(context, listen: false)
                  .toggleTodoStatus(todo.id);
              Navigator.of(context).pop();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            Text(
              "Delete Task?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to delete this task? This action cannot be undone.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Provider.of<TodoProvider>(context, listen: false)
                  .deleteTodo(todo.id);
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priorityColor = _getPriorityColor(context);

    return InkWell(
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
                                  ? theme.textTheme.bodyMedium?.color?.withOpacity(0.5)
                                  : theme.textTheme.titleMedium?.color,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          TimeAgo.format(todo.createdAt),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    if (todo.description.isNotEmpty)
                      Text(
                        todo.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
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
                    icon: const Icon(Icons.delete),
                    color: theme.colorScheme.error,
                    onPressed: () => _showDeleteConfirmationDialog(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}