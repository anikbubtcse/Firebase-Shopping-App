import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartProvider extends ChangeNotifier {
  int _totalCartItems = 0;

  int get totalCartItems => _totalCartItems;

  List<Map<String, dynamic>> list = [];

  addToCart(Map productDetails) async {
    CollectionReference users = FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('items');

    return users
        .doc()
        .set({
          'image_path': productDetails['image_path'],
          'price': productDetails['price'],
          'name': productDetails['name'],
          'counter': 0
        })
        .then((value) =>
            Fluttertoast.showToast(msg: 'Successfully added to cart'))
        .catchError((error) => print("Failed to add user: $error"));
  }

  int totalCartItem() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('items')
        .get()
        .then((QuerySnapshot querySnapshot) {
      _totalCartItems = querySnapshot.docs.length;
      notifyListeners();
    });
    return totalCartItems;
  }

  Future<void> addition(document, int count) async {
    CollectionReference users = FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('items');
    return users
        .doc(document.id)
        .update({'counter': count + 1})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> subtraction(document, int count) async {
    if (count > 0) {
      CollectionReference users = FirebaseFirestore.instance
          .collection('cart')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('items');
      return users
          .doc(document.id)
          .update({'counter': count - 1})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }
}
