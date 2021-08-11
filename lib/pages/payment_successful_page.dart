import 'package:elmalaab/widgets/button.dart';
import 'package:flutter/material.dart';

class PaymentSuccessfulPage extends StatelessWidget {
  final int price;

  const PaymentSuccessfulPage({
    Key key,
    @required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset('assets/images/requestsucceded.png'),
            SizedBox(height: 16),
            Text(
              'تم تأكيد انضمامك',
              style: TextStyle(
                color: Color(0xFF191919),
                fontSize: 20,
                fontFamily: 'DINNextLTW23',
              ),
            ),
            Spacer(),
            Text(
              'سعر الانضمام',
              style: TextStyle(
                color: Color(0xFF191919),
                fontSize: 14,
                fontFamily: 'DINNextLTW23',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 24),
                Text(
                  '$price',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 64,
                    fontFamily: 'DINNextLTW23',
                  ),
                ),
                Text(
                  'ريال',
                  style: TextStyle(
                    color: Color(0xFF85C23F),
                    fontSize: 18,
                    fontFamily: 'DINNextLTW23',
                  ),
                ),
              ],
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Button(
          title: 'استمرار',
          onPressed: () async {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
    );
  }
}
