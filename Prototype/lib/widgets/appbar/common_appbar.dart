import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key, required this.currentTitle});

  final String currentTitle;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60.0,
      backgroundColor: Colors.red[400],
      title: Text(currentTitle),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
