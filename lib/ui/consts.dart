import 'package:flutter/material.dart';

const kTextColor = Color(0xff616161);
const kHintTextColor = Color(0xffc4c4c4);
const kBackgroundColor = Color(0xfff8f8f8);
const kPrimaryColor = Color(0xff7aa997);
const kSecondaryColor = Color(0xffEBF2EF);
const kAccentColor = Color(0xffFE7D57);
const kButtonTextColor = Color(0xffededed);

final kTheme = ThemeData.light().copyWith(
  primaryColor: kPrimaryColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: kBackgroundColor,
  ),
  scaffoldBackgroundColor: kBackgroundColor,
  backgroundColor: kBackgroundColor,
);
