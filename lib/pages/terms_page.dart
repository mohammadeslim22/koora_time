import 'package:elmalaab/state/app_provider.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TermsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              child,
              if (provider.isLoading)
                Expanded(
                  child: Center(
                      child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  )),
                ),
              if (!provider.isLoading) ...[
                Expanded(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        provider.appSettings.terms ?? '',
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontSize: 16,
                          fontFamily: 'DINNextLTW23',
                          height: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Button(
                    title: 'موافق',
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ],
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            'الشروط والأحكام',
            style: TextStyle(
              color: Color(0xFF85C23F),
              fontSize: 24,
              fontFamily: 'BeINBlack',
            ),
          ),
        ),
      ),
    );
  }
}
