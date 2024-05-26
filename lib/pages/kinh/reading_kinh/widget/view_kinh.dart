
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/kinh/model/kinh.model.dart';
import 'package:caodaion/pages/kinh/reading_kinh/widget/font_size_dropdown_menu.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewKinhPage extends StatefulWidget {
  final String id;

  const ViewKinhPage({super.key, required this.id});

  @override
  State<ViewKinhPage> createState() => _ViewKinhPageState();
}

class _ViewKinhPageState extends State<ViewKinhPage> {
  List<Map<String, dynamic>> kinhList = KinhModel.kinhList.toList();
  String _markdownContent = '';

  @override
  void initState() {
    super.initState();
    loadMarkdownFile();
  }

  @override
  void didUpdateWidget(covariant ViewKinhPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id) {
      loadMarkdownFile();
    }
  }

  loadMarkdownFile() async {
    String path = 'assets/document/kinh/${widget.id}.txt';
    final String content = await rootBundle.loadString(path);
    setState(() {
      _markdownContent = content;
      _loadFontSize();
    });
  }

  kinhData() {
    var responseData = kinhList.singleWhere((item) => item['key'] == widget.id);
    var foundGroup = kinhList
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
      fontSize = prefs.getInt(TokenConstants.selectedFontSize) ?? 16;
    });
  }

  void _updateFontSize(int newSize) {
    setState(() {
      fontSize = newSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = kinhData();
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
            child: _markdownContent.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SelectionArea(
                    child: Markdown(
                      data: _markdownContent,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontSize: fontSize.toDouble(),
                        ),
                      ),
                    ),
                  ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: data['prev'] == null
                      ? null
                      : () {
                          context.go('/kinh/${data['prev']['key']}');
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
                          context.go('/kinh/${data['next']['key']}');
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
