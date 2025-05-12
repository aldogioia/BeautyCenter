import 'package:flutter/cupertino.dart';

class MessageExtractor{
  static String extract(String message){
    final regex = RegExp(r"default message \[(.*?)\]");
    final matches = regex.allMatches(message).toList();

    debugPrint("message: $message");
    debugPrint("matches: $matches");

    if (matches.length < 2) return message;

    return matches[1].group(0) ?? message;
  }
}