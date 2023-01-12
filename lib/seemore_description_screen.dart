import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeeMoreDescriptionScreen extends ConsumerWidget {
  final String? description;
  const SeeMoreDescriptionScreen({super.key, this.description});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text("Description Detatils"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black87, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  shape: BoxShape.rectangle,
                  //color: Colors.grey[200],
                  gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.grey, Colors.blueGrey])),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  description ?? "No data",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
            )),
      ),
    );
  }
}
