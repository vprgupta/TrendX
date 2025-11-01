import 'package:flutter/material.dart';

class FontPreviewScreen extends StatelessWidget {
  const FontPreviewScreen({super.key});

  final List<String> fonts = const [
    'Poppins',
    'Montserrat',
    'Inter',
    'Roboto',
    'Open Sans',
    'Lato',
    'Source Sans Pro',
    'Nunito',
    'Raleway',
    'Ubuntu',
    'Work Sans',
    'Fira Sans',
    'DM Sans',
    'Plus Jakarta Sans',
    'Manrope',
    'Space Grotesk',
    'Outfit',
    'Lexend',
    'Satoshi',
    'SF Pro Display',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Font Preview')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: fonts.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fonts[index],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'TrendX',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    fontFamily: fonts[index],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}