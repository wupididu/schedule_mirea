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


const kPairTimeMap = {
  0: {
    'start': TimeOfDay(hour: 9, minute: 0),
    'end': TimeOfDay(hour: 10, minute: 30),
  },
  1: {
    'start': TimeOfDay(hour: 10, minute: 40),
    'end': TimeOfDay(hour: 12, minute: 10),
  },
  2: {
    'start': TimeOfDay(hour: 13, minute: 0),
    'end': TimeOfDay(hour: 14, minute: 30),
  },
  3: {
    'start': TimeOfDay(hour: 14, minute: 40),
    'end': TimeOfDay(hour: 16, minute: 10),
  },
  4: {
    'start': TimeOfDay(hour: 16, minute: 20),
    'end': TimeOfDay(hour: 17, minute: 50),
  },
  5: {
    'start': TimeOfDay(hour: 18, minute: 0),
    'end': TimeOfDay(hour: 19, minute: 30),
  },
};