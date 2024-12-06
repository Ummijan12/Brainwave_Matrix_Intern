import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/todo_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final todoProvider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Settings',
        ),
      ),
      body: ListView(
        children: [
          _buildSettingSection(
            context,
            title: 'Appearance',
            children: [
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Switch between light and dark themes'),
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  themeProvider.toggleTheme(value);
                },
              ),
              SwitchListTile(
                title: const Text('Use System Theme'),
                subtitle: const Text('Automatically adjust to system theme'),
                value: themeProvider.useSystemTheme,
                onChanged: (bool value) {
                  themeProvider.setUseSystemTheme(value);
                },
              ),
            ],
          ),
          _buildSettingSection(
            context,
            title: 'Data',
            children: [
              ListTile(
                title: const Text('Clear All Todos'),
                subtitle: const Text('Permanently delete all todos'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () async {
                    final confirmed =
                        await _showDeleteConfirmationDialog(context);
                    if (confirmed) {
                      await todoProvider.deleteAllTodos();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete All Todos'),
            content: const Text(
                'Are you sure you want to delete all todos? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red,),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
