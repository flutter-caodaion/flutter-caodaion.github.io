import 'dart:developer';

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
  String? _selectedContent;
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

    flutterTts.setPauseHandler(() {
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
      setState(() {
        isSpeaking = true;
      });
    });
  }

  void _speak() async {
    final text = (_selectedContent ?? _tnhtContent)
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
    setState(() {
      _selectedContent = null;
    });
  }

  @override
  void didUpdateWidget(covariant ViewTNHTPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id || widget.group != oldWidget.group) {
      initializeTTS();
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
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = TNHTData();
    return Scaffold(
      appBar: AppBar(
        title: Text(data['name']),
        actions: [
          Tooltip(
            message: _selectedContent != null ? "Đọc đoạn đã chọn" : "Đọc cả",
            child: IconButton(
              onPressed: isSpeaking ? null : _speak,
              icon: const Icon(Icons.play_arrow_rounded),
            ),
          ),
          Tooltip(
            message: "Tạm dùng",
            child: IconButton(
              onPressed: isSpeaking ? _pause : null,
              icon: const Icon(Icons.pause_circle_outline_rounded),
            ),
          ),
          Tooltip(
            message: "Kết thúc",
            child: IconButton(
              onPressed: _stop,
              icon: const Icon(Icons.stop_circle_rounded),
            ),
          ),
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
                p: TextStyle(fontSize: fontSize.toDouble() ?? 16),
              ),
              onTapLink: (text, href, title) {
                // Handle taps on links if needed
              },
              onSelectionChanged: (text, selection, cause) {
                if (!selection.baseOffset.isNaN) {
                  var speekValue = text!
                      .substring(selection.baseOffset, selection.extentOffset);
                  setState(() {
                    _selectedContent = speekValue;
                  });
                }
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
                          context.go(
                              '/tnht/${data['prev']['group']}/${data['prev']['key']}');
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
                          context.go(
                              '/tnht/${data['next']['group']}/${data['next']['key']}');
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
