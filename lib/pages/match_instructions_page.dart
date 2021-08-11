import 'package:flutter/material.dart';

class MatchInstructionsPage extends StatelessWidget {
  final String instructions;

  const MatchInstructionsPage({
    Key key,
    @required this.instructions,
  }) : super(key: key);

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
                'تعليمات المباراة',
                style: TextStyle(
                  color: Color(0xFF85C23F),
                  fontSize: 24,
                  fontFamily: 'BeINBlack',
                ),
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    instructions ?? '',
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
          ],
        ),
      ),
    );
  }
}
