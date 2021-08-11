import 'package:elmalaab/pages/enquiry_page.dart';
import 'package:elmalaab/pages/refund_page.dart';
import 'package:elmalaab/state/app_provider.dart';
import 'package:elmalaab/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getHasRefundBefore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'اتصل بنا',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24,
                    fontFamily: 'BeINBlack',
                  ),
                ),
              ],
            ),
            SizedBox(height: 32),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => EnquiryPage()),
                );
              },
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/contactvector.png',
                    width: 96,
                    height: 96,
                  ),
                  SizedBox(width: 24),
                  Text(
                    'استفسار',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 18,
                      fontFamily: 'DINNextLTW23',
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Color(0xFF191919),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            if (!Provider.of<UserProvider>(context).hasRefundBefore)
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => RefundPage()),
                  );
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/aboutvector.png',
                      width: 96,
                      height: 96,
                    ),
                    SizedBox(width: 24),
                    Text(
                      'طلب استعادة مبلغ الحجز',
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 18,
                        fontFamily: 'DINNextLTW23',
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Color(0xFF191919),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final twitterAccount =
                        Provider.of<AppProvider>(context, listen: false)
                                .appSettings
                                ?.twitter ??
                            '';
                    final _url = 'https://twitter.com/$twitterAccount';
                    await canLaunch(_url)
                        ? await launch(_url)
                        : throw 'Could not launch $_url';
                  },
                  child: Image.asset(
                    'assets/images/tw.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                GestureDetector(
                  onTap: () async {
                    final whatsappNumber =
                        Provider.of<AppProvider>(context, listen: false)
                                .appSettings
                                ?.whatsapp ??
                            '';

                    final _url = 'https://wa.me/$whatsappNumber';
                    await canLaunch(_url)
                        ? await launch(_url)
                        : throw 'Could not launch $_url';
                  },
                  child: Image.asset(
                    'assets/images/whats.png',
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
