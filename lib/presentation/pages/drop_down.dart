import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  final Function(Locale) onLanguageChange;

  LanguageDropdown({required this.onLanguageChange});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(
        'Select Language',
        style: Theme.of(context).textTheme.bodySmall, // Use theme styling
      ),
      onChanged: (String? newValue) {
        if (newValue == 'English') {
          onLanguageChange(Locale('en', 'US'));
        } else if (newValue == 'Spanish') {
          onLanguageChange(Locale('es', 'ES'));
        }
      },
      items: <String>['English', 'Spanish']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall, // Use theme styling
          ),
        );
      }).toList(),
      underline: Container(
        height: 2,
        color: Theme.of(context).colorScheme.primary, // Match theme color
      ),
      icon: Icon(
        Icons.language,
        color: Theme.of(context).colorScheme.primary, // Match theme color
      ),
    );
  }
}
