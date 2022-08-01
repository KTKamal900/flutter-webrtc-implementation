import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreServices {
  var db = FirebaseFirestore.instance;

  Stream checkLatestRoom() {
    return db.collection("rooms").orderBy("createdAt").snapshots();
  }

  Future refreshTheRoom() async {
    WriteBatch batch = db.batch();

    await db
        .collection("rooms")
        .where("isAnswered", isEqualTo: false)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          batch.update(
              db.collection("rooms").doc(element.id), {"isAnswered": true});
        });
      }
    });

    await batch.commit().then((value) => debugPrint("Refresh Done"));
  }
}
