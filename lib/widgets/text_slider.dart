import 'package:flutter/material.dart';

class VerticalTextCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const VerticalTextCarousel({super.key, required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _VerticalTextCarouselState createState() => _VerticalTextCarouselState();
}

class _VerticalTextCarouselState extends State<VerticalTextCarousel> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _startScrolling();
  }

  void _startScrolling() {
    Future.delayed(const Duration(seconds: 2), () {
      _scroll();
    });
  }

  void _scroll() {
    setState(() {
      _scrollOffset += 2.0;
    });
    if (_scrollOffset >= _scrollController.position.maxScrollExtent) {
      _scrollOffset = 0.0;
    }
    _scrollController.animateTo(
      _scrollOffset,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(milliseconds: 100), _scroll);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.data.length * 3, // Repeat the list to create continuous scrolling
      itemBuilder: (context, index) {
        final data = widget.data[index % widget.data.length];
        final text = data['text'] ?? 'No Text';
        final style = data['style'] ?? const TextStyle(fontSize: 12);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: style,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
