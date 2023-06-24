import 'dart:convert';

class Item {
  String name;
  String serialNo;
  String expiryDate;
  String acceptDate;
  String locationCode;
  int piece;
  bool isChecked;

  Item({
    required this.name,
    required this.serialNo,
    required this.expiryDate,
    required this.acceptDate,
    required this.locationCode,
    this.piece = 0,
    this.isChecked = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'serialNo': serialNo,
      'expiryDate': expiryDate,
      'acceptDate': acceptDate,
      'locatonCode': locationCode,
      'piece': piece,
      'isChecked': isChecked,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'] as String,
      serialNo: map['serialNo'] as String,
      expiryDate: map['expiryDate'] as String,
      acceptDate: map['acceptDate'] as String,
      locationCode: map['locationCode'] as String,
      piece: map['piece'] as int,
      isChecked: map['isChecked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());
  factory Item.fromJson(String source) =>
      Item.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Item(name: $name, serialNo: $serialNo, expiryDate: $expiryDate, acceptDate: $acceptDate, locationCode: $locationCode, piece: $piece, isChecked: $isChecked)';
  }

  @override
  bool operator ==(covariant Item other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.serialNo == serialNo &&
        other.expiryDate == expiryDate &&
        other.acceptDate == acceptDate &&
        other.locationCode == locationCode &&
        other.piece == piece &&
        other.isChecked == isChecked;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        serialNo.hashCode ^
        expiryDate.hashCode ^
        acceptDate.hashCode ^
        locationCode.hashCode ^
        piece.hashCode ^
        isChecked.hashCode;
  }
}

List<Item> items = itemList
    .map((String itemName) => Item(
        name: itemName,
        acceptDate: '',
        expiryDate: '',
        locationCode: '',
        serialNo: ''))
    .toList();

List<String> itemList = [];
