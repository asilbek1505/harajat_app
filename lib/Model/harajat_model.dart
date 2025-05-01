class HarajatModel {
  String? id;           // Firebase document ID (ixtiyoriy)
  String price;         // Harajat summasi
  String malumot;       // Harajat haqida izoh
  String sana;          // ISO formatdagi sana (YYYY-MM-DD)

  HarajatModel({
    this.id,
    required this.price,
    required this.malumot,
    required this.sana,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'malumot': malumot,
      'sana': sana,
    };
  }

   HarajatModel.fromJson(Map<String, dynamic> json)
      : id=json['id'],
      price= json['price'],
      malumot=json['malumot'] ,
      sana= json['sana'];


}
