import 'package:flutter/material.dart';

class SamplePage extends StatelessWidget {
  const SamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("hello"),
      ),
      body: const Center(child: Text('SAMPLE LALALA')),
      extendBody: false,
    );
  }
}
