import 'package:meta/meta.dart';

class CreditCard {
  final String cardHolderName;
  final String cardNumber;
  final int cardMonth;
  final int cardYear;
  final int cardCvv;

  CreditCard({
    @required this.cardHolderName,
    @required this.cardNumber,
    @required this.cardMonth,
    @required this.cardYear,
    @required this.cardCvv,
  });
}
