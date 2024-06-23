import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/tnht/model/table_content.model.dart';
import 'package:caodaion/pages/tnht/reading_tnht/widget/font_size_dropdown_menu.widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewTNHTPage extends StatefulWidget {
  final String id;
  final String group;

  const ViewTNHTPage({super.key, required this.id, required this.group});

  @override
  State<ViewTNHTPage> createState() => _ViewTNHTPageState();
}

class _ViewTNHTPageState extends State<ViewTNHTPage> {
  List<Map<String, dynamic>> tableContent =
      TableContentModel.tableContent.toList();
  String _tnhtContent = '';
  late FlutterTts flutterTts;
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    initializeTTS();
    loadMarkdownFile();
  }

  Future<void> initializeTTS() async {
    flutterTts = FlutterTts();

    // Set TTS parameters
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    // Register event listeners
    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isSpeaking = false;
      });
      print("Error: $msg");
    });
    flutterTts.setContinueHandler(() {
      // Setup continueHandler here if needed
      flutterTts.continueHandler = () {
        print("Resumed TTS");
      };
    });
  }

  void _speak(text) async {
    text = text
        .replaceAll("&nbsp;", "")
        .replaceAll("#", "")
        .replaceAll("---", "")
        .replaceAll("**", "");
    await flutterTts.speak(text);
  }

  void _pause() async {
    await flutterTts.pause();
  }

  void _stop() async {
    await flutterTts.stop();
  }

  @override
  void didUpdateWidget(covariant ViewTNHTPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id || widget.group != oldWidget.group) {
      loadMarkdownFile();
    }
  }

  Future<void> loadMarkdownFile() async {
    String path = 'assets/document/TNHT/${widget.group}/${widget.id}.txt';
    final String content = await rootBundle.loadString(path);
    setState(() {
      _tnhtContent = content;
      _loadFontSize();
    });
  }

  Map<String, dynamic> TNHTData() {
    var responseData =
        tableContent.singleWhere((item) => item['key'] == widget.id);
    var foundGroup = tableContent
        .where((item) => item['group'] == responseData['group'])
        .toList();
    var currentIndex =
        foundGroup.indexWhere((item) => item['key'] == widget.id);
    if (currentIndex > 0) {
      responseData['prev'] = foundGroup[currentIndex - 1];
    } else {
      responseData['prev'] = null;
    }
    if (currentIndex < foundGroup.length - 1) {
      responseData['next'] = foundGroup[currentIndex + 1];
    } else {
      responseData['next'] = null;
    }
    return responseData;
  }

  int fontSize = 16;

  void _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fontSize = prefs.getInt(TokenConstants.selectedTNHTFontSize) ?? 16;
    });
  }

  void _updateFontSize(int newSize) {
    setState(() {
      fontSize = newSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = TNHTData();
    return Scaffold(
      appBar: AppBar(
        title: Text(data['name']),
        actions: [
          FontSizeDropdownMenu(
            onFontSizeChanged: _updateFontSize,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Markdown(
              data: _tnhtContent,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(fontSize: fontSize.toDouble()),
              ),
              builders: {
                'p': ClickableParagraphBuilder(),
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: data['prev'] == null
                      ? null
                      : () {
                          context.go('/TNHT/${data['prev']['key']}');
                        },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                      ),
                    ),
                    backgroundColor: ColorConstants.primaryBackground,
                  ),
                  child: Text(
                    data['prev'] == null ? '' : data['prev']['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConstants.primaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: data['next'] == null
                      ? null
                      : () {
                          context.go('/TNHT/${data['next']['key']}');
                        },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                    backgroundColor: ColorConstants.primaryBackground,
                  ),
                  child: Text(
                    data['next'] == null ? '' : data['next']['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConstants.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ClickableParagraphBuilder extends MarkdownElementBuilder {
  @override
  Widget visitText(text, TextStyle? preferredStyle) {
    String fullText = text.text;
    List<InlineSpan> spans = [];
    List<String> sentences = splitSentences(fullText);

    for (String sentence in sentences) {
      spans.add(buildGestureDetector(sentence.trim(), preferredStyle));
    }

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }

  List<String> splitSentences(String text) {
    // Split text into sentences based on period followed by space
    return text.split(RegExp(r'\.\s+'));
  }

  TextSpan buildGestureDetector(String sentence, TextStyle? preferredStyle) {
    return TextSpan(
      text: "$sentence",
      style: preferredStyle,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          print(sentence.trim());
        },
    );
  }
}
