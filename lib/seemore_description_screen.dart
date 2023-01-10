import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SeeMoreDescription extends ConsumerWidget {
  final String description;
  const SeeMoreDescription(this.description, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Description"),
        ),
        body: Text(description),
      ),
    );
  }
}
