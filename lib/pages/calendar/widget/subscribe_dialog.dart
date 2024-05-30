import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';

class SubscribeDialog extends StatefulWidget {
  final List<Map<String, dynamic>> thanhSoList;
  final ValueChanged<List> onUpdateSelected;

  const SubscribeDialog({
    super.key,
    required this.thanhSoList,
    required this.onUpdateSelected,
  });

  @override
  State<SubscribeDialog> createState() => _SubscribeDialogState();
}

class _SubscribeDialogState extends State<SubscribeDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Hiển thị lịch từ Thánh Sở đã đăng ký',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Chọn từ danh sách các Thánh Sở dưới đây để hiển thị thông tin lên lịch của bạn nhé!',
          ),
          const SizedBox(height: 15),
          ...widget.thanhSoList.map((item) {
            var itemSelected = item['checked'] ?? false;
            return CheckboxListTile(
              value: itemSelected,
              onChanged: (value) {
                setState(() {
                  item['checked'] = value;
                });
              },
              title: Text(item['thanhSo'].toString()),
              controlAffinity: ListTileControlAffinity.leading,
            );
          }),
          Row(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: ColorConstants.primaryColor,
                ),
                onPressed: () {
                  widget.onUpdateSelected(widget.thanhSoList);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cập nhật',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Đóng'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
