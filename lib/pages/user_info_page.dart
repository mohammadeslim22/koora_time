import 'dart:io';

import 'package:elmalaab/models/city.dart';
import 'package:elmalaab/models/position.dart';
import 'package:elmalaab/pages/main_navigation_page.dart';
import 'package:elmalaab/state/user_provider.dart';
import 'package:elmalaab/widgets/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserInfoPage extends StatefulWidget {
  final bool firstTime;
  final int id;

  const UserInfoPage({
    Key key,
    this.firstTime = false,
    this.id,
  }) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int _selectedCity;
  int _selectedPosition;
  File _image;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _selectedCity = user.cityId;
      _selectedPosition = user.positionId;
    }
    Provider.of<UserProvider>(context, listen: false).getCitiesAndPositions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            widget.firstTime ? Image.asset('assets/images/logosm.png') : null,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.firstTime)
                  Text(
                    'بيانات المستخدم',
                    style: TextStyle(
                      color: Color(0xFF2B4A66),
                      fontSize: 26,
                      fontFamily: 'DINNextLTW23',
                    ),
                  )
                else
                  Text(
                    'تعديل حسابي',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 24,
                      fontFamily: 'BeINBlack',
                    ),
                  ),
                SizedBox(height: 40),
                Center(
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.grey,
                    backgroundImage: _getProfileImage(),
                  ),
                ),
                SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final pickedFile = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      setState(() {
                        if (pickedFile != null) {
                          _image = File(pickedFile.path);
                        }
                      });
                    },
                    child: Chip(
                      label: Text(
                        widget.firstTime ? 'إضافة  صورة' : 'تغيير الصورة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'الاسم بالكامل',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 16,
                    fontFamily: 'DINNextLTW23',
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontFamily: 'DINNextLTArabic',
                  ),
                  validator: (value) {
                    if (value.trim().isEmpty) return 'الرجاء إدخال الاسم كاملا';
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    _form.currentState.validate();
                  },
                  textInputAction: widget.firstTime
                      ? TextInputAction.done
                      : TextInputAction.next,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(64.0),
                      ),
                    ),
                    hintText: 'مثال: محمد سعود',
                    errorStyle: TextStyle(
                      fontFamily: 'DINNextLTArabic',
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'DINNextLTArabic',
                    ),
                    isDense: true,
                  ),
                ),
                SizedBox(height: 24),
                if (!widget.firstTime) ...[
                  Text(
                    'الإيميل (اختياري)',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 16,
                      fontFamily: 'DINNextLTW23',
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontFamily: 'DINNextLTArabic',
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(64.0),
                        ),
                      ),
                      hintText: 'email@example.com',
                      errorStyle: TextStyle(
                        fontFamily: 'DINNextLTArabic',
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'DINNextLTArabic',
                      ),
                      isDense: true,
                    ),
                  ),
                  SizedBox(height: 24),
                ],
                Text(
                  'المدينة',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 16,
                    fontFamily: 'DINNextLTW23',
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                            value: _selectedCity,
                            hint: Text('اختر المدينة'),
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF191919),
                              fontFamily: 'DINNextLTArabic',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedCity = value;
                              });
                            },
                            items: [
                              for (City city in Provider.of<UserProvider>(
                                      context,
                                      listen: false)
                                  .cities)
                                DropdownMenuItem(
                                  child: Text(city.name),
                                  value: city.id,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'مركز اللاعب',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 16,
                    fontFamily: 'DINNextLTW23',
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                            value: _selectedPosition,
                            hint: Text('اختر المركز'),
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF191919),
                              fontFamily: 'DINNextLTArabic',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _selectedPosition = value;
                              });
                            },
                            items: [
                              for (Position position
                                  in Provider.of<UserProvider>(context,
                                          listen: false)
                                      .positions)
                                DropdownMenuItem(
                                  child: Text(position.name),
                                  value: position.id,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Button(
                  title: 'حفظ',
                  onPressed: () async {
                    if (!_form.currentState.validate()) {
                      return;
                    }
                    if (_selectedCity == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('الرجاء اختيار المدينة')));
                      return;
                    }
                    if (_selectedPosition == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('الرجاء اختيار مركز اللاعب')));
                      return;
                    }
                    try {
                      if (widget.firstTime) {
                        await Provider.of<UserProvider>(context, listen: false)
                            .registerUser(
                          name: _nameController.text,
                          cityId: _selectedCity,
                          positionId: _selectedPosition,
                          profileImage: _image,
                          id: widget.id,
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => MainNavigationPage()),
                          (route) => false,
                        );
                      } else {
                        await Provider.of<UserProvider>(context, listen: false)
                            .updateUser(
                          name: _nameController.text,
                          email: _emailController.text,
                          cityId: _selectedCity,
                          positionId: _selectedPosition,
                          profileImage: _image,
                        );
                        Navigator.of(context).pop();
                      }
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
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (_image != null) {
      if (kIsWeb) return NetworkImage(_image.path);
      return FileImage(_image);
    }
    final userImage =
        Provider.of<UserProvider>(context, listen: false).user?.profileImage;
    if (userImage == null || userImage == '')
      return AssetImage('assets/images/profile.png');
    else
      return NetworkImage(userImage);
  }
}
