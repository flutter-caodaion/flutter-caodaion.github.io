// library_page.dart
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/library/service/library_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart';

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
  String statusMessage = "Đang tải nội dung sách ...";
  String docContent = "";
  List<InlineSpan> styledTextSpans = [];
  List<ArchiveFile> _archive = []; // Initialize _archive as an empty list

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  @override
  void didUpdateWidget(covariant BookPage oldWidget) {
    super.didUpdateWidget(oldWidget);
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
        if (book['fileId'].isNotEmpty) {
          book['path'] =
              "https://docs.google.com/document/d/${book['fileId']}/export?format=docx";
          _downloadAndExtractDoc();
        }
      }
    });
  }

  Future<void> _downloadAndExtractDoc() async {
    try {
      final url = book['path'];

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/google_doc.docx';
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);

        // Extract the text from the .docx file along with styles
        await _extractTextAndStylesFromDocx(file);
        setState(() {
          statusMessage = "Document Loaded";
        });
      } else {
        setState(() {
          statusMessage =
              'Failed to download document. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = 'An error occurred: $e';
      });
    }
  }

  Future<void> _extractTextAndStylesFromDocx(File file) async {
    // Read the .docx file as bytes
    final bytes = file.readAsBytesSync();

    // Decode the bytes to a Zip archive
    final archive = ZipDecoder().decodeBytes(bytes);
    _archive = List.of(archive);

    // Variables to hold extracted content
    String documentXml = '';
    String stylesXml = '';
    Map<String, List<int>> imagesMap = {};

    // Extract the required XML files and images
    for (var file in archive) {
      if (file.name == 'word/document.xml') {
        documentXml = utf8.decode(file.content);
      } else if (file.name == 'word/styles.xml') {
        stylesXml = utf8.decode(file.content);
      } else if (file.name.startsWith('word/media/')) {
        // Extract image bytes
        imagesMap[file.name] = file.content;
      }
    }

    // If the required XML files are found, process them
    if (documentXml.isNotEmpty && stylesXml.isNotEmpty) {
      // Parse the document XML
      final document = XmlDocument.parse(documentXml);

      // Parse the styles XML
      final styles = XmlDocument.parse(stylesXml);

      // Extract text and apply styles
      styledTextSpans = _getTextSpansFromXml(document, styles);
    }
  }

  List<InlineSpan> _getTextSpansFromXml(
      XmlDocument document, XmlDocument styles) {
    final textSpans = <InlineSpan>[];

    // Find all the paragraphs
    final paragraphs = document.findAllElements('w:p');

    for (var paragraph in paragraphs) {
      final runs = paragraph.findAllElements('w:r');
      for (var run in runs) {
        final textElement = run.findElements('w:t').firstOrNull;
        if (textElement != null) {
          final text = textElement.text;

          // Default style
          TextStyle textStyle =
              const TextStyle(color: Colors.black, fontSize: 14.0);

          // Apply styles from the run properties
          final runProperties = run.findElements('w:rPr').firstOrNull;
          if (runProperties != null) {
            textStyle =
                _applyStylesFromProperties(runProperties, textStyle, styles);
          }

          // Create a TextSpan with the text and style
          textSpans.add(TextSpan(text: text, style: textStyle));
        }
        final drawingElements = run.findElements('w:drawing');
        for (var drawing in drawingElements) {
          final imageData = drawing.findElements('wp:inline').firstOrNull;
          if (imageData != null) {
            final imageDataElement =
                imageData.findAllElements('a:blip').firstOrNull;
            final imageId = imageDataElement?.getAttribute('r:embed');

            if (imageId != null) {
              final imageBytes = _getImageBytesFromId(imageId, document);
              if (imageBytes != null) {
                // Display the image using WidgetSpan
                textSpans.add(
                  WidgetSpan(
                    child: Image.memory(
                      Uint8List.fromList(imageBytes),
                      fit: BoxFit.contain, // Adjust fit as per your UI design
                    ),
                  ),
                );
              }
            }
          }
        }
      }
      // Add a new line after each paragraph
      textSpans.add(const TextSpan(text: '\n'));
    }

    return textSpans;
  }

  List<int>? _getImageBytesFromId(String imageId, XmlDocument document) {
    // Find the image data from the document based on imageId
    final imageDataElement =
        document.findAllElements('pic:pic').firstWhere((element) {
      final blipId = element
          .findAllElements('a:blip')
          .firstOrNull
          ?.getAttribute('r:embed');
      return blipId == imageId;
    });

    if (imageDataElement != null) {
      // Extract and return image bytes
      final imageData =
          imageDataElement.findAllElements('pic:cNvPr').firstOrNull;
      final imageRelId = imageData?.getAttribute('name');
      if (imageRelId != null) {
        final zipEntryName = 'word/media/$imageRelId';
        final archiveFile =
            _archive.firstWhere((file) => file.name == zipEntryName);
        if (archiveFile != null) {
          return archiveFile.content;
        }
      }
    }

    return null;
  }

  TextStyle _applyStylesFromProperties(
      XmlElement runProperties, TextStyle baseStyle, XmlDocument styles) {
    TextStyle textStyle = baseStyle;

    // Check for bold
    if (runProperties.findElements('w:b').isNotEmpty) {
      textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
    }

    // Check for italic
    if (runProperties.findElements('w:i').isNotEmpty) {
      textStyle = textStyle.copyWith(fontStyle: FontStyle.italic);
    }

    // Check for underline
    if (runProperties.findElements('w:u').isNotEmpty) {
      textStyle = textStyle.copyWith(decoration: TextDecoration.underline);
    }

    // Apply font size if specified
    final fontSizeElement = runProperties.findElements('w:sz').firstOrNull;
    if (fontSizeElement != null) {
      final sizeValue = fontSizeElement.getAttribute('w:val');
      if (sizeValue != null) {
        final fontSize = double.tryParse(sizeValue) ?? 28.0;
        textStyle = textStyle.copyWith(
            fontSize: fontSize / 2); // Convert half-point size to point size
      }
    }

    // Apply color if specified
    final colorElement = runProperties.findElements('w:color').firstOrNull;
    if (colorElement != null) {
      final colorValue = colorElement.getAttribute('w:val');
      if (colorValue != null) {
        textStyle = textStyle.copyWith(color: _colorFromHex(colorValue));
      }
    }

    // Handle other properties like fonts, etc. here

    return textStyle;
  }

  // Convert hexadecimal color string to Color
  Color _colorFromHex(String hexColor) {
    final buffer = StringBuffer();
    if (hexColor.length == 6 || hexColor.length == 7) buffer.write('ff');
    buffer.write(hexColor.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  void dispose() {
    super.dispose();
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
          return styledTextSpans.isNotEmpty
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      text: TextSpan(children: styledTextSpans),
                    ),
                  ),
                )
              : Center(child: Text(statusMessage));
        } else {
          return const SizedBox();
        }
      }),
    );
  }
}

// Extension method to find the first element or return null
extension XmlElementExtension on Iterable<XmlElement> {
  XmlElement? get firstOrNull => isEmpty ? null : first;
}
