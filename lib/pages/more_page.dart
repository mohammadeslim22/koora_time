import 'dart:io';

import 'package:elmalaab/pages/about_app_page.dart';
import 'package:elmalaab/pages/contact_us_page.dart';
import 'package:elmalaab/pages/login_page.dart';
import 'package:elmalaab/pages/settings_page.dart';
import 'package:elmalaab/pages/terms_page.dart';
import 'package:elmalaab/pages/user_info_page.dart';
import 'package:elmalaab/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40),
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.grey,
                  backgroundImage: () {
                    final profileImage =
                        Provider.of<UserProvider>(context).user?.profileImage;
                    if (profileImage != null && profileImage != '') {
                      return NetworkImage(profileImage);
                    }
                    return AssetImage('assets/images/profile.png');
                  }(),
                ),
              ),
              SizedBox(height: 12),
              Text(
                Provider.of<UserProvider>(context).user?.name ?? '',
                style: TextStyle(
                  color: Color(0xFF2B4A66),
                  fontFamily: 'DINNextLTArabic',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 48),
              ListTile(
                title: Text(
                  'تعديل حسابي',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 18,
                    fontFamily: 'DINNextLTArabic',
                  ),
                ),
                leading: Image.asset('assets/images/editprofileicon.png'),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Color(0xFF191919),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => UserInfoPage()));
                },
              ),
              SizedBox(height: 8),
              ListTile(
                title: Text(
                  'الإعدادات',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 18,
                    fontFamily: 'DINNextLTArabic',
                  ),
                ),
                leading: Image.asset('assets/images/settings.png'),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Color(0xFF191919),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SettingsPage()));
                },
              ),
              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 8),
              ListTile(
                title: Text(
                  'مشاركة التطبيق',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 18,
                    fontFamily: 'DINNextLTArabic',
                  ),
                ),
                leading: Image.asset('assets/images/shareicon.png'),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Color(0xFF191919),
                ),
                onTap: () {
                  if (Platform.isAndroid)
                    Share.share(
                        'جرب تطبيق كورة تايم : https://play.google.com/store/apps/details?id=com.abdullah.koratime');
                  if (Platform.isIOS)
                    Share.share(
                        'جرب تطبيق كورة تايم : https://apps.apple.com/us/app/elmalaab-%D8%A7%D9%84%D9%85%D9%84%D8%B9%D8%A8/id1571317257');
                },
              ),
              SizedBox(height: 8),
              ListTile(
                title: Text(
                  'عن التطبيق',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 18,
                    fontFamily: 'DINNextLTArabic',
                  ),
                ),
                leading: Image.asset('assets/images/aboutus.png'),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Color(0xFF191919),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => AboutAppPage()));
                },
              ),
              SizedBox(height: 8),
              ListTile(
                title: Text(
                  'اتصل بنا',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 18,
                    fontFamily: 'DINNextLTArabic',
                  ),
                ),
                leading: Image.asset('assets/images/contactus.png'),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Color(0xFF191919),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ContactUs()),
                  );
                },
              ),
              SizedBox(height: 8),
              ListTile(
                title: Text(
                  'الشروط والأحكام',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 18,
                    fontFamily: 'DINNextLTArabic',
                  ),
                ),
                leading: Image.asset('assets/images/terms.png'),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Color(0xFF191919),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => TermsPage()));
                },
              ),
              SizedBox(height: 8),
              ListTile(
                title: Text(
                  'تسجيل خروج',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 18,
                    fontFamily: 'DINNextLTArabic',
                  ),
                ),
                leading: Image.asset('assets/images/logouticon.png'),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Color(0xFF191919),
                ),
                onTap: () {
                  Provider.of<UserProvider>(context, listen: false).clearUser();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
