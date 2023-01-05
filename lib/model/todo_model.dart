import 'package:flutter/material.dart';

@immutable
class Todo {
  final String id;
  final String title;
  final String description;
  final bool pin;

  const Todo({
    required this.id,
    required this.description,
    required this.title,
    required this.pin,
  });

  Todo copyWith({
    String? id,
    String? description,
    String? title,
    bool? pin,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pin: pin ?? this.pin,
    );
  }
}
