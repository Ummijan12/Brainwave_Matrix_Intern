import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TodoModel todo;

  const TaskDetailsScreen({super.key, required this.todo});

  Color _getPriorityColor() {
    switch (todo.priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  String _getPriorityText() {
    switch (todo.priority) {
      case Priority.high:
        return "High Priority";
      case Priority.medium:
        return "Medium Priority";
      default:
        return "Low Priority";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.3),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.3),
              child: Icon(
                todo.isCompleted ? Icons.clear : Icons.check,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              _showToggleConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Header with Gradient
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getPriorityColor(),
                    _getPriorityColor().withOpacity(0.7),
                    _getPriorityColor().withOpacity(0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      todo.title,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getPriorityText(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Task Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description Section
                  _buildSectionHeader(context, "Description", Icons.description),
                  const SizedBox(height: 12),
                  Text(
                    todo.description.isNotEmpty
                        ? todo.description
                        : "No description provided.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  // Status Section
                  _buildSectionHeader(context,"Status", Icons.check_circle_outline),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        todo.isCompleted ? Icons.check_circle : Icons.pending,
                        color: todo.isCompleted ? Colors.green : Colors.orange,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        todo.isCompleted ? "Completed" : "Pending",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: todo.isCompleted ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showToggleConfirmationDialog(context);
        },
        backgroundColor: todo.isCompleted ? Colors.orange : Colors.green,
        icon: Icon(
          todo.isCompleted ? Icons.undo : Icons.check,
          color: Colors.white,
        ),
        label: Text(
          todo.isCompleted ? "Mark Incomplete" : "Mark Complete",
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
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

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _getPriorityColor(), size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: _getPriorityColor(),
          ),
        ),
      ],
    );
  }
}
