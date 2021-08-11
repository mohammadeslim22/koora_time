import 'package:elmalaab/state/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'عن التطبيق',
                style: TextStyle(
                  color: Color(0xFF85C23F),
                  fontSize: 24,
                  fontFamily: 'BeINBlack',
                ),
              ),
            ),
            Consumer<AppProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading)
                  return Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    )),
                  );
                return Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        provider.appSettings?.aboutApp ?? '',
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 16,
                          fontFamily: 'DINNextLTW23',
                          height: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
