import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Button extends StatefulWidget {
  final String title;
  final FactoryFuncAsync onPressed;
  final Color color;

  const Button({
    Key key,
    @required this.title,
    @required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        child: processing
            ? CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                widget.title ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontFamily: 'DINNextLTArabic',
                  fontWeight: FontWeight.w500,
                ),
              ),
        style: ElevatedButton.styleFrom(
          primary: widget.color ?? Theme.of(context).primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
        onPressed: () async {
          if (processing) return;
          setState(() {
            processing = true;
          });
          if (widget.onPressed != null) {
            try {
              await widget.onPressed();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('خطأ غير معروف. حاول مرة أخرى!')));
            }
          }
          setState(() {
            processing = false;
          });
        },
      ),
    );
  }
}
