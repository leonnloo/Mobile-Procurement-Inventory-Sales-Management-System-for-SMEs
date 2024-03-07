import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/customer/edit_customer.dart';
import 'package:prototype/app/notification_screen.dart';

class InfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  InfoAppBar({super.key, required this.currentTitle, required this.currentData});

  final String currentTitle;
  final dynamic currentData;
  var isNoti = false;
  @override
  Widget build(BuildContext context) {
    if (currentTitle == 'Notifications') {
      isNoti = true;
    }
    return AppBar(
      toolbarHeight: 60.0,
      actions: isNoti
          ? []  // Empty list when isNoti is true, indicating no actions
          : [
              IconButton(
                onPressed: () {
                  if (currentTitle == 'Customer Details') {
                    Get.to(() => EditCustomer(customerData: currentData));
                  } else if (currentTitle == 'Supplier Details') {
                    Get.to(() => EditCustomer(customerData: currentData));
                  }
                },
                icon: const Icon(
                  Icons.edit_rounded,
                  size: 30.0,
                ),
              ),
            ],
      backgroundColor: Colors.red[400],
      title: Text(currentTitle),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
