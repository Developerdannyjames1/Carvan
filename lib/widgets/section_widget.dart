import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final Map<String, String> fields;
  final List<String> statusOptions;
  final Function(String, String) onFieldChanged;

  const SectionWidget({
    required this.title,
    required this.fields,
    required this.statusOptions,
    required this.onFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...fields.entries.map(
              (field) => _buildFieldRow(field.key, field.value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldRow(String fieldName, String currentValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(fieldName)),
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<String>(
              value: currentValue.isEmpty ? null : currentValue,
              items:
                  statusOptions.map((option) {
                    return DropdownMenuItem(value: option, child: Text(option));
                  }).toList(),
              onChanged: (value) => onFieldChanged(fieldName, value ?? ''),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
