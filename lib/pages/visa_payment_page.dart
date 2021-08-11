import 'dart:async';

import 'package:elmalaab/data/api_provider.dart';
import 'package:elmalaab/data/local_provider.dart';
import 'package:elmalaab/di.dart';
import 'package:elmalaab/models/credit_card.dart';
import 'package:elmalaab/pages/payment_successful_page.dart';
import 'package:elmalaab/state/match_provider.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class VisaPaymentPage extends StatefulWidget {
  final int matchId;
  final int price;

  const VisaPaymentPage({
    Key key,
    @required this.matchId,
    @required this.price,
  }) : super(key: key);

  @override
  _VisaPaymentPageState createState() => _VisaPaymentPageState();
}

class _VisaPaymentPageState extends State<VisaPaymentPage> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final FocusNode _cardNameFocusNode = FocusNode();
  final FocusNode _cardNumberFocusNode = FocusNode();
  final FocusNode _expiryMonthFocusNode = FocusNode();
  final FocusNode _expiryYearFocusNode = FocusNode();
  final FocusNode _cvvFocusNode = FocusNode();

  bool _isSaveVisaSelected = true;

  @override
  void initState() {
    super.initState();
    final card = sl<LocalProvider>().getCreditCard();
    if (card != null) {
      _cardNameController.text = card.cardHolderName ?? '';
      _cardNumberController.text = card.cardNumber ?? '';
      _expiryMonthController.text = card.cardMonth?.toString() ?? '';
      _expiryYearController.text = card.cardYear?.toString() ?? '';
      _cvvController.text = card.cardCvv?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                'دفع فيزا',
                style: TextStyle(
                  color: Color(0xFF85C23F),
                  fontSize: 24,
                  fontFamily: 'BeINBlack',
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _cardNameController,
                      focusNode: _cardNameFocusNode,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF191919),
                        fontFamily: 'DINNextLTArabic',
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty)
                          return 'الرجاء إدخال الاسم على البطاقة';
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _cardNameFocusNode.unfocus();
                        _cardNumberFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(64.0),
                          ),
                        ),
                        isDense: true,
                        hintText: 'اسم صاحب البطاقة',
                        errorStyle: TextStyle(
                          fontFamily: 'DINNextLTArabic',
                        ),
                        hintStyle: TextStyle(
                          fontFamily: 'DINNextLTArabic',
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    TextFormField(
                      textDirection: TextDirection.ltr,
                      controller: _cardNumberController,
                      focusNode: _cardNumberFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 16,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF191919),
                        fontFamily: 'DINNextLTArabic',
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty || value.trim().length < 16)
                          return 'الرجاء إدخال رقم البطاقة';
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _cardNumberFocusNode.unfocus();
                        _expiryMonthFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(64.0),
                          ),
                        ),
                        isDense: true,
                        hintText: 'رقم البطاقة',
                        counterText: '',
                        errorStyle: TextStyle(
                          fontFamily: 'DINNextLTArabic',
                        ),
                        hintStyle: TextStyle(
                          fontFamily: 'DINNextLTArabic',
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Text(
                      'تاريخ الإنتهاء',
                      style: TextStyle(
                        fontFamily: 'DINNextLTArabic',
                        fontSize: 16,
                        color: Color(0xFF707070),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryMonthController,
                            focusNode: _expiryMonthFocusNode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 2,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF191919),
                              fontFamily: 'DINNextLTArabic',
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty)
                                return 'الرجاء إدخال الشهر';
                              if (int.parse(value.trim()) > 12)
                                return 'الرجاء إدخال قيمة صحيحة';
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              _expiryMonthFocusNode.unfocus();
                              _expiryYearFocusNode.requestFocus();
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(64.0),
                                ),
                              ),
                              isDense: true,
                              hintText: 'شهر',
                              counterText: '',
                              errorStyle: TextStyle(
                                fontFamily: 'DINNextLTArabic',
                              ),
                              hintStyle: TextStyle(
                                fontFamily: 'DINNextLTArabic',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _expiryYearController,
                            focusNode: _expiryYearFocusNode,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 4,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF191919),
                              fontFamily: 'DINNextLTArabic',
                            ),
                            validator: (value) {
                              if (value.trim().isEmpty)
                                return 'الرجاء إدخال السنة';
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              _expiryYearFocusNode.unfocus();
                              _cvvFocusNode.requestFocus();
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(64.0),
                                ),
                              ),
                              isDense: true,
                              hintText: 'سنة',
                              counterText: '',
                              errorStyle: TextStyle(
                                fontFamily: 'DINNextLTArabic',
                              ),
                              hintStyle: TextStyle(
                                fontFamily: 'DINNextLTArabic',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    TextFormField(
                      controller: _cvvController,
                      focusNode: _cvvFocusNode,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF191919),
                        fontFamily: 'DINNextLTArabic',
                      ),
                      validator: (value) {
                        if (value.trim().isEmpty) return 'الرجاء إدخال رقم CVV';
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        _cvvFocusNode.unfocus();
                        _form.currentState.validate();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(64.0),
                          ),
                        ),
                        isDense: true,
                        hintText: 'CVV',
                        counterText: '',
                        errorStyle: TextStyle(
                          fontFamily: 'DINNextLTArabic',
                        ),
                        hintStyle: TextStyle(
                          fontFamily: 'DINNextLTArabic',
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: CheckboxListTile(
                        value: _isSaveVisaSelected,
                        contentPadding: const EdgeInsets.all(0),
                        onChanged: (value) {
                          setState(() {
                            _isSaveVisaSelected = value;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                        title: Text(
                          'حفظ بيانات الفيزا للتسهيل وعدم كتابتها لاحقاً',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF191919),
                            fontFamily: 'DINNextLTArabic',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    Button(
                      title: 'دفع',
                      onPressed: () async {
                        if (!_form.currentState.validate()) {
                          return;
                        }
                        if (_isSaveVisaSelected) {
                          sl<LocalProvider>().setCreditCard(
                            CreditCard(
                              cardHolderName: _cardNameController.text,
                              cardNumber: _cardNumberController.text,
                              cardMonth: int.parse(_expiryMonthController.text),
                              cardYear: int.parse(_expiryYearController.text),
                              cardCvv: int.parse(_cvvController.text),
                            ),
                          );
                        }
                        try {
                    //       String paymentUrl = await sl<ApiProvider>().payAndRegister(
                    //   //      _cardNameController.text,
                    //    //     _cardNumberController.text,
                    //  //       int.parse(_expiryMonthController.text),
                    //  //       int.parse(_expiryYearController.text),
                    // //        int.parse(_cvvController.text),
                    //         widget.matchId
                    //       );
                    //       String url = paymentUrl.replaceAll("/", "").replaceAll('"', '');
                    //       print("paymentUrl = " + url);
                    //       inform(url);

                        
                        //  Provider.of<MatchProvider>(context, listen: false)
                      //        .getMyComingMatches();
                      //    Navigator.of(context).pushReplacement(
                      //      MaterialPageRoute(
                      //          builder: (_) =>
                      //              PaymentSuccessfulPage(price: widget.price),
                      //          fullscreenDialog: true),
                     //     );
                        } catch (e) {
                          print("paymentUrl =  Err -------");
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(e.message)));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  inform(String url) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => YourWebView(url)));
  }

}


class YourWebView extends StatelessWidget {
  String url;
  bool isFinshed = false;
  YourWebView(this.url);

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('اكمال عملية الدفع..'),
          leading: new IconButton(
              icon: new Icon(Icons.close),
              onPressed: () {
              
              if(isFinshed) {
                      Provider.of<MatchProvider>(context, listen: false)
                              .getMyComingMatches();
                        Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                Navigator.pop(context);
              }
               
              }),
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },

            onPageFinished: (String url) {
              //https://justdemo.almusand.com/tap/check?tap_id=chg_TS051620211200c9KQ1406099  4508750015741019
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              
              if (url.contains("tap/check?tap_id")) {
                    
                     isFinshed = true;
              }
              print('Page finished loading: $url');
            },
            
          
          );
        }));
  }
}