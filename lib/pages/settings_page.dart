import 'package:elmalaab/state/user_provider.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsOn;

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).getNotificationStatus();
    _isNotificationsOn =
        Provider.of<UserProvider>(context, listen: false).notificationStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإعدادات',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 24,
                fontFamily: 'BeINBlack',
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                'تفعيل الإشعارات',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF191919),
                  fontFamily: 'DINNextLTArabic',
                ),
              ),
              onTap: () {
                setState(() {
                  _isNotificationsOn = !_isNotificationsOn;
                });
              },
              trailing: CupertinoSwitch(
                value: _isNotificationsOn,
                activeColor: Theme.of(context).primaryColor,
                onChanged: (value) {
                  setState(() {
                    _isNotificationsOn = value;
                  });
                },
              ),
            ),
            Spacer(),
            Button(
              title: 'حفظ',
              onPressed: () async {
                await Provider.of<UserProvider>(context, listen: false)
                    .updateNotificationStatus(_isNotificationsOn);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
