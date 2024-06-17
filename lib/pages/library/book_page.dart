// library_page.dart
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/library/service/library_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  late WebViewController webController; // Use nullable type if null is possible

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
        if (book['googleDocId'].isNotEmpty) {
          book['path'] =
              "https://docs.google.com/document/d/e/${book['googleDocId']}/pub?embedded=true";
          webController = WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {
                  // Update loading bar.
                },
                onPageStarted: (String url) {
                  print(url);
                },
                onPageFinished: (String url) {
                  print(url);
                },
                onHttpError: (HttpResponseError error) {},
              ),
            )
            ..loadRequest(Uri.parse(book['path']));
        }
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
        title: Wrap(
          children: [
            Icon(
              Icons.library_books_rounded,
              color: ColorConstants.libraryColor,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              book != null ? book['name'] : 'Đọc Sách',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        backgroundColor: ColorConstants.whiteBackdround,
      ),
      body: Builder(builder: (context) {
        if (book != null) {
          return WebViewWidget(controller: webController);
        } else {
          return SizedBox();
        }
      }),
    );
  }
}
