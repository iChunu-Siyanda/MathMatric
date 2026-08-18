import 'dart:io';
import 'package:math_matric/core/network/repositories/internet_checker.dart';

class InternetCheckerImpl implements InternetChecker {

  @override
  Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('firebase.google.com',);

      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
