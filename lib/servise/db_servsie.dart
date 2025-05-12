import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/Carousel_model.dart';
import '../Model/Comment_Model.dart';
import '../Model/Member.dart';
import '../Model/harajat_model.dart';
import 'auth_servise.dart';

class DBServise {
  static final _firestore = FirebaseFirestore.instance;
  static const String folde_users = "users"; // TO‘G‘RI QILINDI
  static const String folde_harajat = 'harajat';
  static const String folde_carousel = 'carousel';


  static Future<void> storeMember(Member member) async {
    member.user_id = AuthServise.currentUserId();
    return _firestore.collection(folde_users).doc(member.user_id).set(member.toJson());
  }

  static Future<Member> loadMember() async {
    String uid = AuthServise.currentUserId();
    var value = await _firestore.collection(folde_users).doc(uid).get();

    if (value.exists && value.data() != null) {
      return Member.fromJson(value.data()!);
    } else {
      throw Exception("Foydalanuvchi topilmadi.");
    }
  }


  static Future<HarajatModel> storeHarajat(HarajatModel harajat) async {
    Member me = await loadMember();

    String id = _firestore
        .collection(folde_users)
        .doc(me.user_id)
        .collection(folde_harajat)
        .doc()
        .id;

    harajat.id = id; // Hujjat ID sini harajatga yozamiz

    await _firestore
        .collection(folde_users)
        .doc(me.user_id)
        .collection(folde_harajat)
        .doc(id)
        .set(harajat.toJson());

    return harajat;
  }


  static Future<List<HarajatModel>> loadHarajat() async {
    List<HarajatModel> harajatlar = [];
    String uid = AuthServise.currentUserId();

    var querySnapshot = await _firestore
        .collection(folde_users)
        .doc(uid)
        .collection(folde_harajat)
        .get();

    for (var harajat in querySnapshot.docs) {
      harajatlar.add(HarajatModel.fromJson(harajat.data()));
    }return harajatlar;
  }
  static Future<CarouselModel> storeCarouselImageForAdmin(CarouselModel image) async {
    String postId = _firestore.collection(folde_carousel).doc().id;
    image.id = postId;

    await _firestore
        .collection(folde_carousel)
        .doc(postId)
        .set(image.toJson());

    return image;
  }

  static Future<void> deleteHarajat(String harajatId) async {
    String uid = AuthServise.currentUserId();
    await _firestore
        .collection(folde_users)
        .doc(uid)
        .collection(folde_harajat)
        .doc(harajatId)
        .delete();
  }

  // Harajatni yangilash
  static Future<void> updateHarajat(HarajatModel harajat) async {
    String uid = AuthServise.currentUserId();
    await _firestore
        .collection(folde_users)
        .doc(uid)
        .collection(folde_harajat)
        .doc(harajat.id)
        .update(harajat.toJson());
  }

  static Future<void> storeComment(CommentModel comment) async {
  await _firestore.collection('comments').add(comment.toJson());
  }


}
