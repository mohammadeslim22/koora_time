import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/pages/terms_page.dart';
import 'package:elmalaab/pages/verification_code_page.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
            child: Column(
              children: [
                Image.asset('assets/images/logomid.png'),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'قم بالتسجيل في كورة تايم وشارك في المباريات',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF2B4A66),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'DINNextLTArabic',
                    ),
                  ),
                ),
                SizedBox(height: 64),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'رقم الجوال',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF191919),
                      fontFamily: 'DINNextLTW23',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Form(
                    key: _form,
                    child: TextFormField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF191919),
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty)
                          return 'الرجاء إدخال رقم الجوال';
                        if (value.trim().length < 9)
                          return 'رقم الجوال مكون من 9 خانات على الأقل ';
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _form.currentState.validate();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(64.0),
                          ),
                        ),
                        isDense: true,
                        errorStyle: TextStyle(
                          fontFamily: 'DINNextLTArabic',
                        ),
                        hintText: '5xxxx xxxx',
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 16),
                            Image.asset('assets/images/saudiarabia.png'),
                            SizedBox(width: 8),
                            Text(
                              '+966',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF191919),
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Button(
                  title: 'تأكيد',
                  onPressed: () async {
                    if (!_form.currentState.validate()) {
                      return;
                    }
                    String _phoneNumber = _phoneNumberController.text;
                    if (_phoneNumber.startsWith('0'))
                      _phoneNumber = _phoneNumber.substring(1);
                    try {
                      final int id = await sl<ApiProvider>().sendLoginPassword(
                        mobile: _phoneNumber,
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VerificationCodePage(
                            id: id,
                            phoneNumber: _phoneNumber,
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.message)));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'عند تسجيلك في',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF191919),
                  fontFamily: 'DINNextLTW23',
                ),
              ),
              Text(' كورة تايم ',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF2B4A66),
                    fontFamily: 'BeINBlack',
                  )),
              Text(
                'هذا يعني أنك موافق على',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF191919),
                  fontFamily: 'DINNextLTW23',
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => TermsPage()));
            },
            child: Text(
              'الشروط والأحكام',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF85C23F),
                fontFamily: 'DINNextLTW23',
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 64),
        ],
      ),
    );
  }
}
