import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height * 0.6;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(30, 26, 30, 10),
          height: _height,
          width: _height * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.black.withOpacity(0.1),
          ),
        ),
        Container(
          height: 12,
          width: _height * 2 * 0.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.black.withOpacity(0.1),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 10,
          width: _height * 2 * 0.2 * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.black.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}
