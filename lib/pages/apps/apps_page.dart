import 'package:caodaion/util/platform.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/widgets/text_horizontal_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> appList = [
      if (!isWindows())
        {
          'name': '/qr',
          'label': 'Quét QR',
          'icon': Icon(
            Icons.qr_code_scanner_outlined,
            color: ColorConstants.qrColor,
            size: 32,
          ),
        },
      {
        'name': '/dong-ho',
        'label': 'Đồng hồ',
        'icon': SvgPicture.asset(
          'assets/icons/clock.svg',
          height: 32,
          width: 32,
          color: ColorConstants.clockColor,
        ),
      },
      {
        'name': '/lich',
        'label': 'Lịch',
        'icon': SvgPicture.asset(
          'assets/icons/calendar.svg',
          height: 32,
          width: 32,
          color: ColorConstants.calendarColor,
        ),
      },
      {
        'name': '/tnht',
        'label': 'TNHT',
        'icon': SvgPicture.asset(
          'assets/icons/close_book.svg',
          height: 32,
          width: 32,
          color: ColorConstants.tnhtColor,
        ),
      },
      {
        'name': '/kinh',
        'label': 'Kinh',
        'icon': SvgPicture.asset(
          'assets/icons/book.svg',
          height: 32,
          width: 32,
          color: ColorConstants.kinhColor,
        ),
      },
      {
        'name': '/tu-tinh',
        'label': 'Tự tỉnh',
        'icon': SvgPicture.asset(
          'assets/icons/chart.svg',
          height: 32,
          width: 32,
          color: ColorConstants.chartColor,
        ),
      },
      if (isPhone())
        {
          'name': '/widgets',
          'label': 'Widgets',
          'icon': const Icon(Icons.widgets),
        },
      {
        'name': '/ai',
        'label': 'Gemini AI',
        'icon': SvgPicture.asset(
          'assets/icons/gemini_sparkle_v002_d4735304ff6292a690345.svg',
          height: 32,
          width: 32,
        ),
      },
      {
        'name': '/maps',
        'label': 'Bản đồ',
        'icon': Icon(
          Icons.map,
          color: ColorConstants.mapsColor,
          size: 32,
        ),
      },
    ];

    List<Map<String, dynamic>> pinnedApps = [
      {
        'name': '',
        'label': 'Ghim',
        'icon': Icon(
          Icons.add,
          size: 32,
          color: ColorConstants.primaryColor,
        ),
      },
    ];

    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.go('/');
            },
          ),
          backgroundColor: ColorConstants.whiteBackdround,
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(radius: 24),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Khách',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const TextHorizontalDivider(title: 'ĐÃ GHIM'),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(12.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveBreakpoints.of(context).isMobile
                      ? 3
                      : ResponsiveBreakpoints.of(context).isTablet
                          ? 4
                          : ResponsiveBreakpoints.of(context).isDesktop
                              ? 6
                              : 1,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return GridTile(
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(index == 0 ? 0 : 0.25),
                                    blurRadius: 4,
                                  ),
                                ],
                                border: Border.all(
                                  color: ColorConstants.primaryColor,
                                ),
                              ),
                              child: Center(
                                child: pinnedApps[index]['icon'],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                pinnedApps[index]['label'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          if (index != 0) {
                            context.go(pinnedApps[index]['name']);
                          }
                        },
                      ),
                    );
                  },
                  childCount: pinnedApps.length,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const TextHorizontalDivider(title: 'KHÁM PHÁ'),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(12.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveBreakpoints.of(context).isMobile
                      ? 3
                      : ResponsiveBreakpoints.of(context).isTablet
                          ? 4
                          : ResponsiveBreakpoints.of(context).isDesktop
                              ? 6
                              : 1,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return GridTile(
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: appList[index]['icon'],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                appList[index]['label'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          context.go(appList[index]['name']);
                        },
                      ),
                    );
                  },
                  childCount: appList.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
