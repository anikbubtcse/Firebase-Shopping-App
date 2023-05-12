import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FavoriteProvider extends ChangeNotifier {
  Future addToFavorite(Map productDetails) async {
    CollectionReference users = FirebaseFirestore.instance
        .collection('favorite')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('items');

    return users.doc().set({
      'image_path': productDetails['image_path'],
      'price': productDetails['price'],
      'name': productDetails['name']
    }).then((value) {
      Fluttertoast.showToast(msg: 'Successfully added to favorite');
    }).catchError((error) => print("Failed to add user: $error"));
  }
}
