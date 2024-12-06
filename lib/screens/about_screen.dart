import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = 'Loading...';
  final List<FeatureHighlight> _features = [
    FeatureHighlight(
      icon: Icons.check_circle,
      title: 'Task Management',
      description:
          'Organize your todos with priority levels and status tracking',
    ),
    FeatureHighlight(
      icon: Icons.storage,
      title: 'Local Storage',
      description: 'Persistent storage with Hive database',
    ),
    FeatureHighlight(
      icon: Icons.animation,
      title: 'Smooth Animations',
      description: 'Engaging UI with Flutter Animate',
    ),
    FeatureHighlight(
      icon: Icons.design_services,
      title: 'Clean Design',
      description: 'Intuitive and modern user interface',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Todo Master'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App Logo and Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(
                      Icons.checklist_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  ).animate().scale(),
                  const SizedBox(height: 16),
                  Text(
                    'Todo Master',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                  ),
                  Text(
                    'Version $_appVersion',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Features Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Features',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 16),
                  ...buildFeatureList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildFeatureList() {
    return _features.map((feature) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(feature.icon, color: Colors.deepPurple),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    feature.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

class FeatureHighlight {
  final IconData icon;
  final String title;
  final String description;

  FeatureHighlight({
    required this.icon,
    required this.title,
    required this.description,
  });
}
