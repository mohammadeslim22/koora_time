import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/pages/main_navigation_page.dart';
import 'package:elmalaab/pages/user_info_page.dart';
import 'package:elmalaab/state/sms_code_timer.dart';
import 'package:elmalaab/state/user_provider.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:elmalaab/widgets/verification_code_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerificationCodePage extends StatefulWidget {
  final String phoneNumber;
  final int id;

  const VerificationCodePage({
    Key key,
    @required this.phoneNumber,
    @required this.id,
  }) : super(key: key);

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  String code = '';
  bool isSendingAgain = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SmsCodeTimer>(context, listen: false).startCodeTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'كود التفعيل',
                style: TextStyle(
                  color: Color(0xFF2B4A66),
                  fontSize: 26,
                  fontFamily: 'DINNextLTW23',
                ),
              ),
              SizedBox(height: 8),
              Text(
                'تم إرسال كود التفعيل على رقمك',
                style: TextStyle(
                  color: Color(0xFF2B4A66),
                  fontSize: 18,
                  fontFamily: 'DINNextLTW23',
                ),
              ),
              Text(
                '+966 ${widget.phoneNumber ?? ''}',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Color(0xFF85C23F),
                  fontSize: 16,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                'ادخل كود التفعيل المكون من 6 أرقام',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: Color(0xFF2B4A66),
                ),
              ),
              SizedBox(height: 28),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Center(
                  child: VerificationCode(
                    onEditing: (s) {
                      if (s)
                        setState(() {
                          code = '';
                        });
                    },
                    autofocus: true,
                    length: 6,
                    onCompleted: (verificationCode) {
                      setState(() {
                        code = verificationCode;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
              Button(
                title: 'تأكيد',
                onPressed: () async {
                  if (code.isEmpty || code.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('أدخل كود التفعيل')));
                    return;
                  }
                  try {
                    final user = await sl<ApiProvider>()
                        .verifyLoginPassword(id: widget.id, password: code);
                    
                    if (user == null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => UserInfoPage(firstTime: true,  id: widget.id)));
                    } else {
                      await Provider.of<UserProvider>(context, listen: false)
                          .setUser(user);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => MainNavigationPage()),
                          (route) => false);
                    }
                  } catch (e) {
                    print("-----------");
                    print(e);
                    print("-----------");
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.message)));
                  }
                },
              ),
              SizedBox(height: 40),
              Divider(color: Color(0xFF2B4A66)),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لم تتلق كود التفعيل؟',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: Color(0xFF2B4A66),
                    ),
                  ),
                  SizedBox(width: 16),
                  Consumer<SmsCodeTimer>(
                      builder: (context, smsCodeTimer, child) {
                    return Text(
                      '00:${smsCodeTimer.time.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontFamily: 'DINNextLTArabic',
                        fontSize: 14,
                        color: Color(0xFF2B4A66),
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: 16),
              Consumer<SmsCodeTimer>(builder: (context, smsCodeTimer, _) {
                return Center(
                  child: isSendingAgain
                      ? CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        )
                      : OutlinedButton(
                          onPressed: smsCodeTimer.isDone()
                              ? () async {
                                  if (isSendingAgain) return;
                                  setState(() {
                                    isSendingAgain = true;
                                  });
                                  try {
                                    await sl<ApiProvider>().sendLoginPassword(
                                        mobile: widget.phoneNumber);
                                  } catch (e) {}
                                  setState(() {
                                    isSendingAgain = false;
                                  });
                                  smsCodeTimer.startCodeTimer();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('تم إرسال الكود مرة أخرى')));
                                }
                              : null,
                          child: Text('إرسال مرة أخرى'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Color(0xFF2B4A66),
                              width: 0.5,
                            ),
                            primary: Color(0xFF2B4A66),
                            textStyle: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                            ),
                          ),
                        ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
