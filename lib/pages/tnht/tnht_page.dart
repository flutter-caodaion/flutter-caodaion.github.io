// kinh_page.dart
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/kinh/widget/kinh_list.dart';
import 'package:caodaion/pages/tnht/model/table_content.model.dart';
import 'package:caodaion/pages/tnht/widget/table_content.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TNHTPage extends StatefulWidget {
  const TNHTPage({super.key});

  @override
  State<TNHTPage> createState() => _TNHTPageState();
}

class _TNHTPageState extends State<TNHTPage> {
  List<bool> isSelected = [true, false];
  List<Map<String, dynamic>> tnhtTableContent = TableContentModel.tableContent.toList();
  List<Map<String, dynamic>> searchTNHTResult = TableContentModel.tableContent;

  TextEditingController controller = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _loadDisplayMode();
  }

  _loadDisplayMode() async {
    final prefs = await SharedPreferences.getInstance();
    int storedIndex =
        prefs.getInt(TokenConstants.selectedTNHTTableContentDisplayMode) ?? 0;
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = storedIndex == i;
      }
    });
  }

  _saveDisplayMode(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(TokenConstants.selectedTNHTTableContentDisplayMode, index);
  }

  @override
  Widget build(BuildContext context) {
    onChangeSearchBox(String text) {
      searchText = text;
      searchTNHTResult.clear();
      if (text.isEmpty) {
        searchTNHTResult = tnhtTableContent;
        setState(() {});
        return;
      }
      text = text.toLowerCase();
      for (var tnht in tnhtTableContent) {
        var nameField = (tnht['name'] as String).toLowerCase();
        if (nameField.contains(text)) {
          searchTNHTResult.add(tnht);
        }
      }
      setState(() {});
    }

    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.whiteBackdround,
          titleSpacing: 0,
          title: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            shadowColor: Colors.transparent,
            color: ColorConstants.primaryBackground,
            child: ListTile(
              leading: const Icon(Icons.search),
              title: TextField(
                controller: controller,
                decoration: const InputDecoration(
                    hintText: 'Tìm kiếm bài học', border: InputBorder.none),
                onChanged: onChangeSearchBox,
              ),
              trailing: controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        controller.clear();
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : const SizedBox(),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Wrap(
                children: [
                  ToggleButtons(
                    isSelected: isSelected,
                    onPressed: (index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = index == i;
                        }
                        _saveDisplayMode(index);
                      });
                    },
                    borderRadius: const BorderRadius.all(
                      Radius.circular(60),
                    ),
                    fillColor: ColorConstants.primaryBackground,
                    selectedColor: Colors.black,
                    color: Colors.black,
                    children: [
                      Tooltip(
                        message: 'bố cục danh sách',
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              if (isSelected[0] == true)
                                Icon(
                                  Icons.check,
                                  size: 18,
                                  color: ColorConstants.primaryColor,
                                ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(Icons.menu),
                            ],
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'bố cục lưới',
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              if (isSelected[1] == true)
                                Icon(
                                  Icons.check,
                                  size: 18,
                                  color: ColorConstants.primaryColor,
                                ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Icon(Icons.grid_view),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        body: searchTNHTResult.isNotEmpty
            ? TableContent(
                isSelected: isSelected,
                tableContent: searchTNHTResult,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Không thể tìm thấy kinh với từ khóa của bạn:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '"$searchText"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Hãy thử nhập chính xác dấu để tìm kiếm dễ hơn bạn nhé!',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
