import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/tnht/model/table_content.model.dart';
import 'package:caodaion/pages/tnht/reading_tnht/widget/font_size_dropdown_menu.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    loadMarkdownFile();
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
    List<String> sentences = text.text.split('.');
    return Wrap(
      children: sentences.map((sentence) {
        return GestureDetector(
          onTap: () {
            print(sentence.trim());
          },
          child: Text(
            sentence.isEmpty ? '' : '$sentence.',
            style: preferredStyle,
          ),
        );
      }).toList(),
    );
  }
}
