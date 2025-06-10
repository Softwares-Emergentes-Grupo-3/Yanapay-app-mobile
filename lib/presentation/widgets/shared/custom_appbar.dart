import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
        bottom: false,
        child: SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                ),
                const Spacer(),
                Icon(Icons.person_2_outlined,
                    color: colors.secondary, size: 30),
              ],
            )));
  }
}
