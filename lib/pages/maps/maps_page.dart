// maps_page.dart
import 'dart:convert';
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/pages/maps/service/maps_service.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final List<Marker> _allMarkers = [
    Marker(
      point: LatLng(
        MapsConstants.caodaionLatitute,
        MapsConstants.caodaionLongitute,
      ),
      child: SvgPicture.asset('assets/icons/caodaion-pin.svg'),
      alignment: Alignment.topCenter,
    )
  ];
  List<Marker> _displayMarkers = [];

  LatLng _currentPosition = LatLng(
    MapsConstants.caodaionLatitute,
    MapsConstants.caodaionLongitute,
  );
  Map<String, dynamic> aPoint = {
    "value": "Vị trí hiện tại",
    "latLgn": LatLng(
      MapsConstants.caodaionLatitute,
      MapsConstants.caodaionLongitute,
    ),
  };
  final MapController _mapController = MapController();
  MapsService mapsService = MapsService();
  double searchRadius = 999999999999999;
  bool isShowFilter = false;

  Future fetchRoute(LatLng start, LatLng end) async {
    final url =
        'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coords = data['routes'][0]['geometry']['coordinates'] as List;
      return {
        "coords": coords.map((c) => LatLng(c[1], c[0])).toList(),
        "data": data,
      };
    } else {
      throw Exception('Failed to load route');
    }
  }

  List<LatLng> routePoints = [];
  var routeData;
  var routeElement;
  String convertDistance(double meters) {
    if (meters >= 1000) {
      double kilometers = meters / 1000;
      return '${kilometers.toStringAsFixed(1)} km';
    } else {
      return '${meters.toString()} m';
    }
  }

  String convertDuration(double seconds) {
    int hours = seconds ~/ 3600; // Number of whole hours
    int minutes = (seconds % 3600) ~/ 60; // Number of whole minutes
    String hoursText = (hours > 0) ? '$hours giờ ' : ''; // Hours text
    String minutesText = '$minutes phút'; // Minutes text
    return hoursText + minutesText;
  }

  _openWithGoogleMaps(element) async {
    const baseUrl = 'https://www.google.com/maps/dir/';
    var coordinates =
        "${_currentPosition.latitude},${_currentPosition.longitude}/${double.parse(element['latLng'].split(',')[0])},${double.parse(element['latLng'].split(',')[1])}";
    final Uri url = Uri.parse(baseUrl + coordinates);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  _showRoutePoints(element) {
    final legs = routeData['routes'][0]['legs'][0];
    setState(() {
      routeElement = element;
    });
    showModalBottomSheet(
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (legs != null)
                Text(
                  "${convertDuration(legs['duration'])} (${convertDistance(legs['distance'])})",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              Text(
                "Chỉ đường từ vị trí của bạn đến ${element['name']} (${element['address']})",
              ),
              const SizedBox(
                height: 24,
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _openWithGoogleMaps(element);
                    },
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/Google_Maps_icon_(2020).svg',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          "Mở Google Maps",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        routePoints = [];
                        routeData = null;
                        routeElement = null;
                        Navigator.of(context).pop();
                      });
                    },
                    child: const Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.delete_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Xoá chỉ đường",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _getRoute(LatLng start, LatLng end, element) async {
    final fetchedRoute = await fetchRoute(start, end);
    if (fetchedRoute.isNotEmpty) {
      final points = fetchedRoute['coords'];
      setState(() {
        routePoints = points;
        routeData = fetchedRoute['data'];
        _showRoutePoints(element);
      });

      if (points.isNotEmpty) {
        final bounds = calculateBounds(points);
        _mapController.fitBounds(
          bounds,
          options: FitBoundsOptions(padding: EdgeInsets.all(20)),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeMarkers();
  }

  @override
  void didUpdateWidget(covariant MapsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _getCurrentLocation();
    _initializeMarkers();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      aPoint['latLng'] = _currentPosition;
      _mapController.move(_currentPosition, 15.0);
    });
  }

  _showMarkerDetails(element) {
    _mapController.moveAndRotate(
      LatLng(
        double.parse(element['latLng'].split(',')[0]),
        double.parse(element['latLng'].split(',')[1]),
      ),
      15,
      0,
    );
    showModalBottomSheet(
      backgroundColor: Colors.white,
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                element['name'],
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (element['address'].isNotEmpty)
                Stack(
                  children: [
                    const SizedBox(height: 8.0),
                    ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(element['address']),
                    ),
                  ],
                ),
              if (element['phone'].isNotEmpty)
                Stack(
                  children: [
                    const SizedBox(height: 8.0),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(element['phone']),
                    ),
                  ],
                ),
              if (element['organization'].isNotEmpty)
                Stack(
                  children: [
                    const SizedBox(height: 8.0),
                    ListTile(
                      leading: const Icon(Icons.diversity_2_rounded),
                      title: Text(element['organization']),
                    )
                  ],
                ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  if (!double.parse(element['latLng'].split(',')[0]).isNaN &&
                      !double.parse(element['latLng'].split(',')[1]).isNaN)
                    ElevatedButton(
                      onPressed: () {
                        _getRoute(
                            aPoint['latLng'],
                            LatLng(
                              double.parse(element['latLng'].split(',')[0]),
                              double.parse(element['latLng'].split(',')[1]),
                            ),
                            element);
                        Navigator.of(context).pop();
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.directions,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Chỉ đường',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _initializeMarkers() async {
    final mapResponse = await mapsService.fetchThanhSo();
    if (mapResponse!['data'].isNotEmpty) {
      for (var element in mapResponse['data']) {
        if (element['key'].isNotEmpty &&
            element['latLng'].isNotEmpty &&
            !element['key'].contains('edit')) {
          _allMarkers.add(
            Marker(
              point: LatLng(
                double.parse(element['latLng'].split(',')[0]),
                double.parse(element['latLng'].split(',')[1]),
              ),
              child: GestureDetector(
                onTap: () => _showMarkerDetails(element),
                child: SvgPicture.asset('assets/icons/thanhSo.svg'),
              ),
              alignment: Alignment.topCenter,
            ),
          );
        }
      }
    }
    if (mounted) {
      setState(() {
        _displayMarkers = List.from(_allMarkers);
      });
    }
  }

  List<Marker> _searchMarkers(LatLng location, double radius) {
    const Distance distance = Distance();
    return _allMarkers.where((marker) {
      final double markerDistance = distance.as(
        LengthUnit.Meter,
        location,
        marker.point,
      );
      return markerDistance <= radius;
    }).toList();
  }

  LatLngBounds calculateBounds(List<LatLng> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng));
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Tìm theo phạm vi (mét)',
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  searchRadius = double.tryParse(value) ?? 999999999999999.0;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Tìm kiếm'),
          ),
        ],
      ),
    );
  }

  _clickSearchButton() {
    setState(() {
      if (routeElement != null) {
        _showRoutePoints(routeElement);
      } else {
        isShowFilter = !isShowFilter;
      }
    });
  }

  @override
  void dispose() {
    // Clean up resources here
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/apps');
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.map,
                  color: ColorConstants.mapsColor,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text("Bản đồ"),
              ],
            ),
            IconButton(
              onPressed: () {
                _clickSearchButton();
              },
              icon: Icon(
                routeElement != null
                    ? Icons.route_rounded
                    : Icons.search_rounded,
              ),
            ),
          ],
        ),
        backgroundColor: ColorConstants.whiteBackdround,
      ),
      body: Column(
        children: [
          if (isShowFilter) _buildFilterSection(),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition,
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
                  markers: [
                    Marker(
                      point: _currentPosition,
                      child: const Icon(
                        Icons.adjust_rounded,
                        color: Colors.black,
                      ),
                      alignment: Alignment.topCenter,
                    ),
                  ],
                ),

                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 45,
                    size: const Size(40, 40),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(50),
                    maxZoom: 15,
                    markers: [..._displayMarkers],
                    builder: (context, markers) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue),
                        child: Center(
                          child: Text(
                            markers.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 8,
                      color: const Color(0xff0f53ff),
                      borderColor: const Color(0xff0f28f5),
                      borderStrokeWidth: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        tooltip: "Vị trí hiện tại",
        child: const Icon(
          Icons.my_location,
        ),
      ),
    );
  }
}
