// library_page.dart
import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookPage extends StatefulWidget {
  final String slug;

  const BookPage({super.key, required this.slug});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/sach');
          },
        ),
        title: Row(
          children: [
            Icon(
              Icons.map,
              color: ColorConstants.libraryColor,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text("Thư viện"),
          ],
        ),
        backgroundColor: ColorConstants.whiteBackdround,
      ),
      body: const Center(
        child: Text('Library Page'),
      ),
    );
  }
}
