import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogo;
  
  const CustomAppBar({super.key, required this.title, this.showLogo = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: showLogo 
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/logo/appicon.png',
                height: 32,
                width: 32,
              ),
              const SizedBox(width: 8),
              Text(title),
            ],
          )
        : Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}