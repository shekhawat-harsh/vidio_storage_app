import 'package:flutter/material.dart';

String title = '';

String description = '';

class BottolSheet extends StatelessWidget {
  const BottolSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Title'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
          onSaved: (value) {
            title = value!;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Description'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
          onSaved: (value) {
            description = value!;
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();

              Navigator.pop(context);
            }
          },
          child: const Text('upload'),
        ),
      ],
    );
  }
}
