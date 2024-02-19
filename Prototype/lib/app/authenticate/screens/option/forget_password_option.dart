import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prototype/app/authenticate/screens/forget_password/email/forget_password_mail.dart';

class ForgetPasswordScreen{
  static Future<dynamic> forgetPasswordBottomSheet(context) {
    return showModalBottomSheet(
      context: context, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reset Password', style: Theme.of(context).textTheme.headlineMedium,),
            const SizedBox(height: 30.0),
            const ForgetPassWordBtn(),
          ],
        ),
      )
    );
  }
}


class ForgetPassWordBtn extends StatelessWidget {
  const ForgetPassWordBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
        Get.to(() => ForgetPasswordMailScreen());
      },
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
            const Icon(Icons.mail_outline_rounded, size: 60.0),
            const SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('E-mail', style: Theme.of(context).textTheme.headlineSmall), 
                Text('Reset by mail', style: Theme.of(context).textTheme.bodySmall), 
              ],
            )
          ],
        ),
      ),
    );
  }
}