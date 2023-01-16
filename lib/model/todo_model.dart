import 'dart:convert';
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

  factory Todo.fromJson(Map<String, dynamic> jsonData) {
    return Todo(
      id: jsonData['id'],
      title: jsonData['title'],
      description: jsonData['description'],
      pin: false,
     
    );
  }

  static Map<String, dynamic> toMap(Todo todo) => {
        'id': todo.id,
        'title': todo.title,
        'description': todo.description,
        'pin': todo.pin,
        
      };

   static String encode(List<Todo> todos) => json.encode(
        todos
            .map<Map<String, dynamic>>((todos) => Todo.toMap(todos))
            .toList(),
      );

  static List<Todo> decode(String todos) =>
      (json.decode(todos) as List<dynamic>)
          .map<Todo>((item) => Todo.fromJson(item))
          .toList();

}
