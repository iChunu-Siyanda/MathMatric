import 'package:flutter_test/flutter_test.dart';
import 'package:math_matric/core/network/repositories/internet_checker.dart';


class FakeInternetChecker implements InternetChecker {
  bool hasInternetResult = true;

  @override
  Future<bool> hasInternet() async {
    return hasInternetResult;
  }
}