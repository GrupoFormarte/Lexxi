class ConexionOnline {
  final bool isConected;

  ConexionOnline({required this.isConected});

  factory ConexionOnline.fromJson(json) =>
      ConexionOnline(isConected: json['is_coneted']);

  Map<String, dynamic> toJson() => {'is_coneted': isConected};
}
