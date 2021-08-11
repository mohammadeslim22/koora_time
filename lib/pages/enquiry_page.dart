import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/pages/problem_received_page.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:flutter/material.dart';

class EnquiryPage extends StatelessWidget {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _enquiryController = TextEditingController();

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
              Text(
                'استفسار',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 24,
                  fontFamily: 'BeINBlack',
                ),
              ),
              SizedBox(height: 40),
              Image.asset(
                'assets/images/enquiry.png',
                width: double.infinity,
              ),
              SizedBox(height: 24),
              Text(
                'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التى يولدها التطبيق.',
                style: TextStyle(
                  fontFamily: 'DINNextLTW23',
                  fontSize: 14,
                  color: Color(0xFF191919),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'إرسال رسالة',
                style: TextStyle(
                  fontFamily: 'DINNextLTW23',
                  fontSize: 16,
                  color: Color(0xFF191919),
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                child: Form(
                  key: _form,
                  child: TextFormField(
                    controller: _enquiryController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'اكتب رسالتك',
                      contentPadding: const EdgeInsets.all(8),
                      errorStyle: TextStyle(
                        fontFamily: 'DINNextLTArabic',
                      ),
                    ),
                    validator: (value) {
                      if (value.trim().isEmpty) return 'هل لديك استفسار؟';
                      return null;
                    },
                    maxLines: 8,
                    style: TextStyle(
                      fontFamily: 'DINNextLTW23',
                      fontSize: 16,
                      color: Color(0xFF191919),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Button(
                title: 'إرسال',
                onPressed: () async {
                  if (!_form.currentState.validate()) {
                    return;
                  }
                  try {
                    await sl<ApiProvider>()
                        .sendEnquiry(enquiry: _enquiryController.text);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => ProblemReceivedPage(),
                        fullscreenDialog: true,
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
    );
  }
}
