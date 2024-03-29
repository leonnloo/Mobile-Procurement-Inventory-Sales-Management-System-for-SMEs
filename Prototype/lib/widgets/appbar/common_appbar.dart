import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key, required this.currentTitle});

  final String currentTitle;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.0,
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      centerTitle: true,
      title: Text(currentTitle, style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 25),),
      iconTheme: IconThemeData(
        color: Theme.of(context).colorScheme.surface,
      )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}
