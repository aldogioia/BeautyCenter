import 'package:flutter/cupertino.dart';

class MessageExtractor{
  static String extract(String message){
    final regex = RegExp(r"default message \[(.*?)\]");
    final matches = regex.allMatches(message).toList();

    debugPrint("message: $message");
    debugPrint("matches: $matches");

    return matches[1].group(1) ?? message;
  }
}