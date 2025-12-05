import 'package:flutter/material.dart';

class RoleSelector extends StatelessWidget {
  final String selectedRole;
  final Function(String) onChanged;

  const RoleSelector({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xff1AA5A0), width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildButton("Staff"),
          ),
          Expanded(
            child: _buildButton("Panitia"),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String role) {
    final bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () => onChanged(role),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff1AA5A0) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          role,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xff1AA5A0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
