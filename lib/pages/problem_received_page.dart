import 'package:elmalaab/widgets/button.dart';
import 'package:flutter/material.dart';

class ProblemReceivedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/support.png',
              width: double.infinity,
            ),
            SizedBox(height: 40),
            Text(
              'تم استلام مشكلتك',
              style: TextStyle(
                fontFamily: 'DINNextLTW23',
                color: Color(0xFF191919),
                fontSize: 20,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'سيتم التواصل معك في أقرب وقت',
              style: TextStyle(
                fontFamily: 'DINNextLTW23',
                color: Color(0xFF191919),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Button(
          title: 'تم',
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
