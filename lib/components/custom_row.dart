import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final void Function() onPressed;

  const CustomRow({
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Text(text),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey.shade700,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
