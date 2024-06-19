// library_page.dart
import 'dart:convert';
import 'dart:math';
import 'package:archive/archive.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/library/service/library_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
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
        // Extract the text from the .docx file along with styles
        await _extractTextAndStylesFromDocx(response.bodyBytes);
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

  Future<void> _extractTextAndStylesFromDocx(bytes) async {
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
      // Check for paragraph alignment
      final pPr = paragraph.findAllElements('w:pPr').firstOrNull;
      TextAlign textAlign = TextAlign.left; // Default alignment
      double fontSize = ResponsiveBreakpoints.of(context).isMobile
          ? ContentContants.defaultFontSizeMobile
          : ResponsiveBreakpoints.of(context).isTablet
              ? ContentContants.defaultFontSizeTablet
              : ResponsiveBreakpoints.of(context).isDesktop
                  ? ContentContants.defaultFontSizeDesktop
                  : ContentContants.defaultFontSizeTablet;
      FontWeight fontWeight = FontWeight.normal;
      if (pPr != null) {
        final alignmentElement = pPr.findAllElements('w:jc').firstOrNull;
        if (alignmentElement != null) {
          final alignmentValue = alignmentElement.getAttribute('w:val');
          textAlign = _getTextAlignFromString(alignmentValue);
        }
        final paragraphStyleElement =
            pPr.findAllElements('w:pStyle').firstOrNull;
        if (paragraphStyleElement != null) {
          final paragraphStyleValue =
              paragraphStyleElement.getAttribute('w:val');
          fontSize = _getFontSizeFromParagraphStyle(paragraphStyleValue);
          fontWeight = _getFontWeightFromParagraphStyle(paragraphStyleValue);
        }
      }

      final runs = paragraph.findAllElements('w:r');
      final paragraphSpans = <InlineSpan>[];

      for (var run in runs) {
        final textElement = run.findAllElements('w:t').firstOrNull;
        if (textElement != null) {
          final text = textElement.text;
          // Default style
          TextStyle textStyle = TextStyle(
            color: Colors.black,
            fontSize: fontSize,
            fontWeight: fontWeight,
          );

          // Apply styles from the run properties
          final runProperties = run.findAllElements('w:rPr').firstOrNull;
          if (runProperties != null) {
            textStyle =
                _applyStylesFromProperties(runProperties, textStyle, styles);
          }

          // Create a TextSpan with the text and style
          paragraphSpans.add(TextSpan(text: text, style: textStyle));
        }

        final drawingElements = run.findAllElements('w:drawing');
        for (var drawing in drawingElements) {
          final imageData = drawing.findAllElements('wp:inline').firstOrNull;
          if (imageData != null) {
            final imageDataElement =
                imageData.findAllElements('a:blip').firstOrNull;
            final imageId = imageDataElement?.getAttribute('r:embed');

            if (imageId != null) {
              final imageBytes = _getImageBytesFromId(imageId, document);
              if (imageBytes != null) {
                // Display the image using WidgetSpan
                paragraphSpans.add(
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

      // Wrap the paragraphSpans in a WidgetSpan with alignment
      textSpans.add(
        WidgetSpan(
          child: Align(
            alignment: _getAlignmentFromTextAlign(textAlign),
            child: RichText(
              text: TextSpan(children: paragraphSpans),
              textAlign: textAlign,
            ),
          ),
        ),
      );

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

    // Extract and return image bytes
    final imageData = imageDataElement.findAllElements('pic:cNvPr').firstOrNull;
    final imageRelId = imageData?.getAttribute('name');
    if (imageRelId != null) {
      final zipEntryName = 'word/media/$imageRelId';
      final archiveFile =
          _archive.firstWhere((file) => file.name == zipEntryName);
      return archiveFile.content;
    }

    return null;
  }

  TextStyle _applyStylesFromProperties(
      XmlElement runProperties, TextStyle baseStyle, XmlDocument styles) {
    TextStyle textStyle = baseStyle;

    // Check for bold
    if (runProperties.findAllElements('w:b').isNotEmpty) {
      textStyle = textStyle.copyWith(fontWeight: FontWeight.bold);
    }

    // Check for italic
    if (runProperties.findAllElements('w:i').isNotEmpty) {
      textStyle = textStyle.copyWith(fontStyle: FontStyle.italic);
    }

    // Check for underline
    if (runProperties.findAllElements('w:u').isNotEmpty) {
      textStyle = textStyle.copyWith(decoration: TextDecoration.underline);
    }

    // Apply font size if specified
    final fontSizeElement = runProperties.findAllElements('w:sz').firstOrNull;
    if (fontSizeElement != null) {
      final sizeValue = fontSizeElement.getAttribute('w:val');
      if (sizeValue != null) {
        final fontSize = double.tryParse(sizeValue) ?? 28.0;
        textStyle = textStyle.copyWith(
            fontSize: fontSize / 2); // Convert half-point size to point size
      }
    }

    // Apply color if specified
    final colorElement = runProperties.findAllElements('w:color').firstOrNull;
    if (colorElement != null) {
      final colorValue = colorElement.getAttribute('w:val');
      if (colorValue != null) {
        textStyle = textStyle.copyWith(color: _colorFromHex(colorValue));
      }
    }

    // Handle other properties like fonts, etc. here

    return textStyle;
  }

  // Function to map alignment string to TextAlign
  TextAlign _getTextAlignFromString(String? alignmentValue) {
    switch (alignmentValue) {
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'both':
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }

  double _getFontSizeFromFontSize(double fontSize) {
    return ResponsiveBreakpoints.of(context).isMobile
        ? fontSize /
            (fontSize / (fontSize + ContentContants.defaultFontSizeMobile))
        : ResponsiveBreakpoints.of(context).isTablet
            ? fontSize /
                (fontSize / (fontSize + ContentContants.defaultFontSizeTablet))
            : ResponsiveBreakpoints.of(context).isDesktop
                ? fontSize /
                    (fontSize /
                        (fontSize + ContentContants.defaultFontSizeDesktop))
                : fontSize /
                    (fontSize /
                        (fontSize + ContentContants.defaultFontSizeTablet));
  }

  // Function to map alignment string to TextAlign
  double _getFontSizeFromParagraphStyle(String? paragraphStyleValue) {
    switch (paragraphStyleValue) {
      case 'Title':
        return _getFontSizeFromFontSize(26.0);
      case 'Heading1':
        return _getFontSizeFromFontSize(20.0);
      case 'Subtitle':
        return _getFontSizeFromFontSize(15.0);
      case 'Heading2':
        return _getFontSizeFromFontSize(16.0);
      case 'Heading3':
        return _getFontSizeFromFontSize(14.0);
      case 'Heading4':
        return _getFontSizeFromFontSize(12.0);
      case 'Heading5':
        return _getFontSizeFromFontSize(11.0);
      default:
        return _getFontSizeFromFontSize(16.0);
    }
  }

  FontWeight _getFontWeightFromParagraphStyle(String? paragraphStyleValue) {
    switch (paragraphStyleValue) {
      case 'Title':
        return FontWeight.bold;
      case 'Heading1':
        return FontWeight.bold;
      case 'Subtitle':
        return FontWeight.normal;
      case 'Heading2':
        return FontWeight.bold;
      case 'Heading3':
        return FontWeight.normal;
      case 'Heading4':
        return FontWeight.normal;
      case 'Heading5':
        return FontWeight.normal;
      default:
        return FontWeight.normal;
    }
  }

// Function to map TextAlign to Alignment
  Alignment _getAlignmentFromTextAlign(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.justify:
        return Alignment
            .centerLeft; // No direct equivalent for justify in Alignment
      default:
        return Alignment.centerLeft;
    }
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
                    child: SelectableText.rich(
                      TextSpan(
                        children: styledTextSpans,
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: List.generate(100, (i) {
                        return Builder(builder: (BuildContext context) {
                          return SizedBox(
                            width: double.parse(Random().nextInt(1080).toString()),
                            height:
                                double.parse(Random().nextInt(100).toString()),
                            child: Shimmer.fromColors(
                              baseColor: const Color(0xffe9e8e8),
                              highlightColor: Colors.white,
                              child: Card(
                                color: ColorConstants.whiteBackdround,
                                child: const SizedBox(),
                              ),
                            ),
                          );
                        });
                      }),
                    ),
                  ),
                );
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
