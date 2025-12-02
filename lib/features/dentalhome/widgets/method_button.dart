import 'package:flutter/material.dart';


class MethodButton extends StatelessWidget {
final String label;
final IconData icon;
final bool active;
final VoidCallback onTap;


const MethodButton({super.key, required this.label, required this.icon, required this.active, required this.onTap});


@override
Widget build(BuildContext context) {
return GestureDetector(
onTap: onTap,
child: AnimatedContainer(
duration: const Duration(milliseconds: 300),
padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
decoration: BoxDecoration(
color: active ? Colors.amber.withOpacity(0.12) : Colors.white10,
borderRadius: BorderRadius.circular(12),
border: Border.all(color: active ? Colors.amber : Colors.white12),
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
Icon(icon, color: Colors.white),
const SizedBox(height: 6),
Text(label, style: const TextStyle(color: Colors.white)),
],
),
),
);
}
}