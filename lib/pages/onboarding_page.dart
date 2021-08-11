import 'package:elmalaab/data/local_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/pages/login_page.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Image.asset('assets/images/logosm.png'),
                SizedBox(height: 32),
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/onboarding.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مرحبا!',
                            style: TextStyle(
                              color: Color(0xFF2B4A66),
                              fontSize: 24,
                              fontFamily: 'DINNextLTArabic',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'تطبيق خاص بإضافة مباريات كرة القدم وتنظيمها والتسجيل فيها. اختر الملعب والفريق وانضم لممارسة لعبة كرة القدم.',
                            style: TextStyle(
                              color: Color(0xFF2B4A66),
                              fontSize: 18,
                              fontFamily: 'DINNextLTArabic',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Button(
                    title: 'استمرار',
                    onPressed: () async {
                      sl<LocalProvider>().setOnBoardingShown(true);
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => LoginPage()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
