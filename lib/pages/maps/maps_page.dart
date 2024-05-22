// maps_page.dart
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<Marker> markers = [
    Marker(
      point: LatLng(
        MapsConstants.caodaionLatitute,
        MapsConstants.caodaionLongitute,
      ),
      height: 32,
      width: 32,
      child: SvgPicture.asset('assets/icons/caodaion-pin.svg'),
    )
  ];

  @override
  Widget build(BuildContext context) {
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
        body: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(
              MapsConstants.caodaionLatitute,
              MapsConstants.caodaionLongitute,
            ),
            initialZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.caodaion.app',
            ),
            // const RichAttributionWidget(
            //   attributions: [],
            // ),
            MarkerLayer(
              markers: markers,
            ),
          ],
        ),
      ),
    );
  }
}
