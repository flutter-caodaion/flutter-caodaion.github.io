// kinh_page.dart
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/kinh/model/kinh.model.dart';
import 'package:caodaion/pages/kinh/widget/kinh_list.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class KinhPage extends StatefulWidget {
  const KinhPage({super.key});

  @override
  State<KinhPage> createState() => _KinhPageState();
}

class _KinhPageState extends State<KinhPage> {
  List<bool> isSelected = [true, false];
  List<Map<String, dynamic>> kinhList = KinhModel.kinhList.toList();
  List<Map<String, dynamic>> searchTuThoiResult = KinhModel.kinhList
      .where((item) => item['group'] == 'cung_tu_thoi')
      .toList();
  List<Map<String, dynamic>> searchQuanHonTangTeResult = KinhModel.kinhList
      .where((item) => item['group'] == 'quan_hon_tang_te')
      .toList();

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
        prefs.getInt(TokenConstants.selectedKinhListDisplayMode) ?? 0;
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = storedIndex == i;
      }
    });
  }

  _saveDisplayMode(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(TokenConstants.selectedKinhListDisplayMode, index);
  }

  @override
  Widget build(BuildContext context) {
    onChangeSearchBox(String text) {
      searchText = text;
      searchTuThoiResult.clear();
      searchQuanHonTangTeResult.clear();
      if (text.isEmpty) {
        searchTuThoiResult = KinhModel.kinhList
            .where((item) => item['group'] == 'cung_tu_thoi')
            .toList();
        searchQuanHonTangTeResult = KinhModel.kinhList
            .where((item) => item['group'] == 'quan_hon_tang_te')
            .toList();
        setState(() {});
        return;
      }
      text = text.toLowerCase();
      for (var kinhDetail in kinhList) {
        var nameField = (kinhDetail['name'] as String).toLowerCase();
        if (kinhDetail['group'] == 'cung_tu_thoi' && nameField.contains(text)) {
          searchTuThoiResult.add(kinhDetail);
        }
      }
      for (var kinhDetail in kinhList) {
        var nameField = (kinhDetail['name'] as String).toLowerCase();
        if (kinhDetail['group'] == 'quan_hon_tang_te' &&
            nameField.contains(text)) {
          searchQuanHonTangTeResult.add(kinhDetail);
        }
      }
      setState(() {});
    }

    return ResponsiveScaffold(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
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
                        hintText: 'Tìm kiếm Kinh', border: InputBorder.none),
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
              bottom: TabBar(
                tabs: const [
                  Tab(
                    text: 'Kinh cúng tứ thời',
                  ),
                  Tab(
                    text: 'Quan hôn tang tế',
                  ),
                ],
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.pressed)) {
                      return ColorConstants.primaryBackground;
                    }
                    return null;
                  },
                ),
              ),
            ),
            body: TabBarView(
              children: [
                if (searchTuThoiResult.isNotEmpty)
                  KinhList(
                    isSelected: isSelected,
                    kinhList: searchTuThoiResult,
                  )
                else
                  Column(
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
                if (searchQuanHonTangTeResult.isNotEmpty)
                  KinhList(
                    isSelected: isSelected,
                    kinhList: searchQuanHonTangTeResult,
                  )
                else
                  Column(
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
              ],
            )),
      ),
    );
  }
}
