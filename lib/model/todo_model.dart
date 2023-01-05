import 'package:flutter/material.dart';


@immutable
class Todo {

  final String id;
  final String title;
  final String description;
  

  const Todo({
    required this.id,
    required this.description,
    required this.title,

  });

  Todo copyWith({String? id, String? description, String? title}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
  
}
