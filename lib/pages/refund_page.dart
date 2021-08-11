import 'package:elmalaab/state/user_provider.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RefundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'طلب استعادة مبلغ الحجز',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 24,
                fontFamily: 'BeINBlack',
              ),
            ),
            SizedBox(height: 40),
            Image.asset(
              'assets/images/refund.png',
              width: double.infinity,
            ),
            SizedBox(height: 24),
            Text(
              'يمكن رفع الطلب مرة واحدة فقط وسوف يختفي الخيار بعدها',
              style: TextStyle(
                fontFamily: 'DINNextLTW23',
                fontSize: 14,
                color: Color(0xFF191919),
              ),
            ),
            SizedBox(height: 32),
            Button(
              title: 'إجراء الطلب',
              onPressed: () async {
                try {
                  await Provider.of<UserProvider>(context, listen: false)
                      .refundRequest();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('تم استلام الطلب')));
                  Navigator.of(context).pop();
                } catch (e) {}
              },
            ),
          ],
        ),
      ),
    );
  }
}
