// library_page.dart
import 'dart:convert';

import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/library/service/library_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  LibraryService libraryService = LibraryService();
  List<dynamic> books = [];
  List<dynamic> _displayBooks = [];

  @override
  void initState() {
    _fetchBooks();
    super.initState();
  }

  _fetchBooks() async {
    final bookResponse = await libraryService.fetchBooks();
    if (bookResponse!['data'].isNotEmpty) {
      for (var element in bookResponse['data']) {
        RegExp editRegExp = new RegExp("edit[0-9]");
        if (element['key'].isNotEmpty &&
            editRegExp.stringMatch(element['key']) == null) {
          books.add(element);
        }
      }
    }
    setState(() {
      _displayBooks = List.from(books);
      libraryService.bookResponse = bookResponse;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/');
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
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          ),
          SliverToBoxAdapter(
            child: _displayBooks.isNotEmpty ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                children: _displayBooks.map((book) {
                  double screenWidth = MediaQuery.of(context).size.width;
                  double cardWidth = (screenWidth /
                          (ResponsiveBreakpoints.of(context).isMobile
                              ? 1
                              : ResponsiveBreakpoints.of(context).isTablet
                                  ? 2
                                  : ResponsiveBreakpoints.of(context).isDesktop
                                      ? 5
                                      : 1)) -
                      8 -
                      2;
                  List labels = jsonDecode(book['labels'] ?? '[]');
                  return SizedBox(
                    width: cardWidth,
                    child: Card(
                      color: ColorConstants.whiteBackdround,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ListTile(
                            leading: book['finished'] == 'true'
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Color(0xff01855d),
                                  )
                                : const Icon(
                                    Icons.history_edu,
                                    color: Color(0xff4758b8),
                                  ),
                            title: Text(
                              book['name'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: 16 / 10,
                            child: book['cover'] != ''
                                ? Image.network(
                                    book['cover'],
                                    fit: BoxFit.cover,
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/book-bookmark-minimalistic-svgrepo-com.svg',
                                    fit: BoxFit.contain,
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              book['description'],
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 8.0,
                              children: labels.map((label) {
                                return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffe0e0e0),
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              onPressed: () {
                                context.go("/sach/${book['key']}");
                              },
                              child: const Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                alignment: WrapAlignment.center,
                                children: [
                                  Icon(
                                    Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "ĐỌC SÁCH",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ) : LinearProgressIndicator(),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
            ),
          ),
        ],
      ),
    );
  }
}
