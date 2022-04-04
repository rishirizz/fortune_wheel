import 'dart:ui';

class Fortune {
  final String image;
  final Color color;

  Fortune(this.image, this.color);

  String get asset => "assets/$image.png";
}
