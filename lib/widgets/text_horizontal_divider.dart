import 'package:caodaion/constants/constants.dart';
import 'package:flutter/material.dart';

class TextHorizontalDivider extends StatelessWidget {
  const TextHorizontalDivider({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: Divider(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 16,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: ColorConstants.textHorizontalDividerTextColor,
            ),
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Divider(),
          ),
        ),
      ],
    );
  }
}
