class Traffic {
  String name;
  String link;
  String x;
  String y;
  String width;
  String height;

  Traffic({
    required this.name,
    required this.link,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory Traffic.fromJson(Map<String, dynamic> json) {
    return Traffic(
      name: json['name'] as String,
      link: json['link'] as String,
      x: json['x'] as String,
      y: json['y'] as String,
      width: json['width'] as String,
      height: json['height'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'link': link,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    };
  }
}
