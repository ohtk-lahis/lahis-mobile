class Village {
  final int id;
  final String code;
  final String name;

  const Village({
    required this.id,
    required this.code,
    required this.name,
  });

  factory Village.fromJson(Map<String, dynamic> json) => Village(
        id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
        code: json['code']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
    };
  }

  String get displayName {
    if (code.isEmpty) {
      return name;
    }
    return '$code - $name';
  }
}
