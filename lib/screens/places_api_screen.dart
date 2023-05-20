import 'package:flutter/material.dart';

class PlacesApiScreen extends StatefulWidget {
  const PlacesApiScreen({super.key});

  @override
  State<PlacesApiScreen> createState() => _PlacesApiScreenState();
}

class _PlacesApiScreenState extends State<PlacesApiScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextFormField(controller: _controller),
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return const Text('Locatino');
                }),
          )
        ],
      ),
    );
  }
}
