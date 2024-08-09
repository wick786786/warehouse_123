import 'package:flutter/material.dart';

class MdmStatus extends StatelessWidget {
  const MdmStatus({super.key, required this.status});
  final String? status;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: status == "true"
          ? const Icon(Icons.lock_open,color:Colors.green,)
          : const Icon(Icons.lock_open,color:Colors.red), // Fixed the icon here
    );
  }
}
