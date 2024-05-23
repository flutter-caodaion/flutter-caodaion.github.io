import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class KinhList extends StatefulWidget {
  final List<bool> isSelected;
  const KinhList({super.key, required this.isSelected, required this.kinhList});
  final List<Map<String, dynamic>> kinhList;

  @override
  State<KinhList> createState() => _KinhListState();
}

class _KinhListState extends State<KinhList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (widget.isSelected[0])
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverList.builder(
              itemCount: widget.kinhList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: TextButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            '${widget.kinhList[index]['name']}',
                            style: TextStyle(
                                fontSize: ResponsiveBreakpoints.of(context)
                                        .isDesktop
                                    ? 20
                                    : ResponsiveBreakpoints.of(context).isTablet
                                        ? 14
                                        : ResponsiveBreakpoints.of(context)
                                                .isMobile
                                            ? 14
                                            : 12,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    onPressed: () {
                      context.go("/kinh/${widget.kinhList[index]['key']}");
                    },
                  ),
                );
              },
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveBreakpoints.of(context).isMobile
                    ? 3
                    : ResponsiveBreakpoints.of(context).isTablet
                        ? 4
                        : ResponsiveBreakpoints.of(context).isDesktop
                            ? 6
                            : 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: widget.kinhList.length,
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                    ),
                    child: Text(
                      widget.kinhList[index]['name'],
                      style: TextStyle(
                        fontSize: ResponsiveBreakpoints.of(context).isDesktop
                            ? 20
                            : ResponsiveBreakpoints.of(context).isTablet
                                ? 14
                                : ResponsiveBreakpoints.of(context).isMobile
                                    ? 14
                                    : 12,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
