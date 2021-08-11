import 'package:flutter/material.dart';

class BottomAppBarItem extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String title;
  final bool selected;

  const BottomAppBarItem({
    Key key,
    @required this.onPressed,
    @required this.icon,
    @required this.title,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed ?? () {},
        child: Container(
          color: Color(0xFFFAFAFA),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              Icon(
                icon,
                color: selected
                    ? Theme.of(context).primaryColor
                    : Color(0xFFCCCCCC),
                size: 32,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: selected
                      ? Theme.of(context).primaryColor
                      : Color(0xFFCCCCCC),
                  fontFamily: 'DINNextLTArabic',
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
