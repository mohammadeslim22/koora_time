import 'package:elmalaab/models/credit_card.dart';
import 'package:elmalaab/models/user.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalProvider {
  final SharedPreferences sharedPreferences;

  LocalProvider({@required this.sharedPreferences});

  static const String _HAS_ONBOARDING_SHOWN = 'HAS_ONBOARDING_SHOWN';
  static const String _TOKEN = 'TOKEN';
  static const String _NAME = 'NAME';
  static const String _MOBILE = 'MOBILE';
  static const String _EMAIL = 'EMAIL';
  static const String _PROFILE_IMAGE = 'PROFILE_IMAGE';
  static const String _CITY = 'CITY';
  static const String _POSITION = ' POSITION';

  static const String _CARD_HOLDER_NAME = 'CARD_HOLDER_NAME';
  static const String _CARD_NUMBER = 'CARD_NUMBER';
  static const String _CARD_MONTH = 'CARD_MONTH';
  static const String _CARD_YEAR = 'CARD_YEAR';
  static const String _CARD_CVV = 'CARD_CVV';

  Future<void> setOnBoardingShown(bool value) {
    return sharedPreferences.setBool(_HAS_ONBOARDING_SHOWN, value);
  }

  bool getOnBoardingShown() {
    return sharedPreferences.getBool(_HAS_ONBOARDING_SHOWN) ?? false;
  }

  Future<void> clearUser() async {
    await sharedPreferences.remove(_TOKEN);
    await sharedPreferences.remove(_NAME);
    await sharedPreferences.remove(_MOBILE);
    await sharedPreferences.remove(_EMAIL);
    await sharedPreferences.remove(_PROFILE_IMAGE);
    await sharedPreferences.remove(_CITY);
    await sharedPreferences.remove(_POSITION);
  }

  Future<void> setUser(User user) async {
    await sharedPreferences.setString(_TOKEN, user.token);
    await sharedPreferences.setString(_NAME, user.name);
    await sharedPreferences.setString(_MOBILE, user.mobile);
    if (user.cityId != null) await sharedPreferences.setInt(_CITY, user.cityId);
    if (user.positionId != null)
      await sharedPreferences.setInt(_POSITION, user.positionId);
    if (user.email != null)
      await sharedPreferences.setString(_EMAIL, user.email);
    if (user.profileImage != null)
      await sharedPreferences.setString(_PROFILE_IMAGE, user.profileImage);
  }

  User getUser() {
    return User(
      token: sharedPreferences.getString(_TOKEN),
      name: sharedPreferences.getString(_NAME),
      mobile: sharedPreferences.getString(_MOBILE),
      email: sharedPreferences.getString(_EMAIL),
      profileImage: sharedPreferences.getString(_PROFILE_IMAGE),
      cityId: sharedPreferences.getInt(_CITY),
      positionId: sharedPreferences.getInt(_POSITION),
    );
  }

  Future<void> clearCreditCard() async {
    await sharedPreferences.remove(_CARD_HOLDER_NAME);
    await sharedPreferences.remove(_CARD_NUMBER);
    await sharedPreferences.remove(_CARD_MONTH);
    await sharedPreferences.remove(_CARD_YEAR);
    await sharedPreferences.remove(_CARD_CVV);
  }

  Future<void> setCreditCard(CreditCard card) async {
    await sharedPreferences.setString(_CARD_HOLDER_NAME, card.cardHolderName);
    await sharedPreferences.setString(_CARD_NUMBER, card.cardNumber);
    await sharedPreferences.setInt(_CARD_MONTH, card.cardMonth);
    await sharedPreferences.setInt(_CARD_YEAR, card.cardYear);
    await sharedPreferences.setInt(_CARD_CVV, card.cardCvv);
  }

  CreditCard getCreditCard() {
    return CreditCard(
      cardHolderName: sharedPreferences.getString(_CARD_HOLDER_NAME),
      cardNumber: sharedPreferences.getString(_CARD_NUMBER),
      cardMonth: sharedPreferences.getInt(_CARD_MONTH),
      cardYear: sharedPreferences.getInt(_CARD_YEAR),
      cardCvv: sharedPreferences.getInt(_CARD_CVV),
    );
  }
}
