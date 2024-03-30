import 'package:flutter/material.dart';
import 'package:prototype/widgets/drawer/drawer_header.dart';
import 'package:prototype/widgets/drawer/drawer_list.dart';

Drawer customDrawer(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Drawer(
    child: Container(
      width: size.width * 0.55, // Specify your custom width here
      color: Theme.of(context).colorScheme.onPrimary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderDrawer(),
            drawerList(context),
          ],
        ),
      ),
    ),
  );
}
