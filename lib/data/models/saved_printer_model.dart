import 'dart:convert';

class SavedPrinterModel {
  final String name;
  final String macAdress;
  final String template;

  SavedPrinterModel({
    required this.name,
    required this.macAdress,
    required this.template,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'macAdress': macAdress, 'template': template};
  }

  factory SavedPrinterModel.fromMap(Map<String, dynamic> map) {
    return SavedPrinterModel(
      name: map['name'] ?? '',
      macAdress: map['macAdress'] ?? '',
      template: map['template'] ?? 'Check-In Struct',
    );
  }

  String toJson() => json.encode(toMap());

  factory SavedPrinterModel.fromJson(String source) =>
      SavedPrinterModel.fromMap(json.decode(source));
}
