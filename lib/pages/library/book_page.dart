// library_page.dart
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/library/service/library_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';

class BookPage extends StatefulWidget {
  final String slug;

  const BookPage({super.key, required this.slug});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  LibraryService libraryService = LibraryService();
  List books = [];
  var book;
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  _fetchBooks() async {
    final bookResponse = await libraryService.fetchBooks();
    if (bookResponse!['data'].isNotEmpty) {
      books = bookResponse['data'];
      getBook();
    }
  }

  getBook() {
    setState(() {
      var foundBook = books.firstWhere((item) {
        return item['key'] == widget.slug;
      });
      if (foundBook.isNotEmpty) {
        book = foundBook;
      }
    });
  }

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
            Text(book != null ? book['name'] : 'Đọc Sách'),
          ],
        ),
        backgroundColor: ColorConstants.whiteBackdround,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri("https://flutter.dev"),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          print("Started loading: $url");
        },
        onLoadStop: (controller, url) {
          print("Finished loading: $url");
        },
      ),
    );
  }
}
