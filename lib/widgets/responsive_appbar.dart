import 'package:flutter/material.dart';

class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const ResponsiveAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: isMobile ? 20 : 24, // Adjust font size based on screen width
        ),
      ),
      centerTitle: centerTitle,
      leading: leading,
      actions: actions,
      elevation: isMobile ? 4 : 2, // Subtle elevation change for desktop
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
