import 'package:flutter/material.dart';

@immutable
class Todo {
  final String id;
  final String title;
  final String description;
  final bool pin;
  final bool selected;

  const Todo({
    required this.id,
    required this.description,
    required this.title,
    required this.pin,
    required this.selected,
  });

  Todo copyWith({
    String? id,
    String? description,
    String? title,
    bool? pin,
    bool? selected,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pin: pin ?? this.pin,
      selected: selected ?? this.selected, 
    );
  }
}
