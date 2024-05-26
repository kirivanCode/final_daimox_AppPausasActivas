import 'package:flutter/material.dart';
import 'package:deimoxapp/models/exercise.dart';

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onTap;

  const ExerciseTile({super.key, required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exercise.name),
      subtitle: Text(exercise.description),
      onTap: onTap,
    );
  }
}
