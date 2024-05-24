import 'package:flutter/material.dart';

class ChatClass{
  ChatClass({
    required this.Users,
    required this.Messages,
    required this.Avatar,
    required this.Name,
    required this.LastMessage,
  });
  final int Users;
  final int Messages;
  final Image Avatar;
  final String Name;
  final String LastMessage;
}