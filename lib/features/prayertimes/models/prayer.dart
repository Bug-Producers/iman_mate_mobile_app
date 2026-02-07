class Prayer {
  final String name;
  final DateTime time;

  Prayer({required this.name, required this.time});

  factory Prayer.fromJson(Map<String, dynamic> json, String datePart) {
    return Prayer(
      name: json['name'],
      time: DateTime.parse("${datePart}T${json['time']}:00"),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "time": "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
    };
  }
}