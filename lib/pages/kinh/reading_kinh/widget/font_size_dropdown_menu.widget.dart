import 'package:flutter/material.dart';

class FontSizeDropdownMenu extends StatefulWidget {
  final ValueChanged<int> onFontSizeChanged;

  const FontSizeDropdownMenu({super.key, required this.onFontSizeChanged});

  @override
  State<FontSizeDropdownMenu> createState() => _FontSizeDropdownMenuState();
}

class _FontSizeDropdownMenuState extends State<FontSizeDropdownMenu> {
  int selectedFontSize = 16;
  final List<DropdownMenuEntry> fontSizeRange = [
    const DropdownMenuEntry(value: 12, label: '12'),
    const DropdownMenuEntry(value: 13, label: '13'),
    const DropdownMenuEntry(value: 14, label: '14'),
    const DropdownMenuEntry(value: 15, label: '15'),
    const DropdownMenuEntry(value: 16, label: '16'),
    const DropdownMenuEntry(value: 17, label: '17'),
    const DropdownMenuEntry(value: 18, label: '18'),
    const DropdownMenuEntry(value: 19, label: '19'),
    const DropdownMenuEntry(value: 20, label: '20'),
    const DropdownMenuEntry(value: 21, label: '21'),
    const DropdownMenuEntry(value: 22, label: '22'),
    const DropdownMenuEntry(value: 23, label: '23'),
    const DropdownMenuEntry(value: 24, label: '24'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      label: const Text('Cỡ chữ'),
      initialSelection: selectedFontSize,
      dropdownMenuEntries: fontSizeRange,
      onSelected: (value) {
        widget.onFontSizeChanged(value);
      },
    );
  }
}
