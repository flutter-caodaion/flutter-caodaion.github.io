// genimi_ai_page.dart
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenimiAIPage extends StatefulWidget {
  const GenimiAIPage({super.key});

  @override
  State<GenimiAIPage> createState() => _GenimiAIPageState();
}

class _GenimiAIPageState extends State<GenimiAIPage> {
  @override
  void initState() {
    super.initState();
  }

  final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest', apiKey: TokenConstants.genimiAPIKey);

  void generateContent(String value) async {
    if (value.isNotEmpty) {
      setState(() {
        isLoading = true;
        chatHistory.add({"from": 'user', "content": value});
        controller.clear();
      });
      final content = [Content.text(value)];
      final response = await model.generateContent(content);
      setState(() {
        final text =
            "${response.text}\n---\n**LƯU Ý:**\nNội dung trên chỉ mang tính chất tham khảo vì chúng mình vẫn đang trong quá trình thử nghiệm";
        chatHistory.add({"from": 'gemini', "content": text});
        isLoading = false;
      });
      _scrollToBottom();
    }
  }

  TextEditingController controller = TextEditingController();
  String chatContent = '';
  List<Map<String, dynamic>> chatHistory = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/gemini_sparkle_v002_d4735304ff6292a690345.svg',
              ),
              const SizedBox(
                width: 8,
              ),
              const Text('Genimi'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: chatHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: chatHistory[index]['from'] == 'user'
                        ? Card(
                            color: ColorConstants.primaryBackground,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Markdown(
                                shrinkWrap: true,
                                data: chatHistory[index]['content'] as String,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Markdown(
                              shrinkWrap: true,
                              data: chatHistory[index]['content'] as String,
                            ),
                          ),
                  );
                },
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                color: ColorConstants.primaryBackground,
                child: ListTile(
                  title: TextField(
                    controller: controller,
                    autofocus: true,
                    decoration:
                        const InputDecoration(hintText: "Nhập lệnh tại đây"),
                    onChanged: (value) {
                      setState(() {
                        chatContent = value;
                      });
                    },
                    onSubmitted: (value) {
                      generateContent(chatContent);
                    },
                  ),
                  trailing: Tooltip(
                    message: "Gửi",
                    child: IconButton(
                      onPressed: () {
                        if (isLoading) {
                          null;
                        } else {
                          generateContent(chatContent);
                        }
                      },
                      icon: const Icon(Icons.send_rounded),
                      color: isLoading ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
