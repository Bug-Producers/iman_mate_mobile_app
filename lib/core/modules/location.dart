import 'package:flutter/foundation.dart';

class Location {
  final double lat;
  final double lng;
  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "lat": lat,
      "lng": lng,
    };
  }
}