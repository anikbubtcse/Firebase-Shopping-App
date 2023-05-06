import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../const/appcolors.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map productDetails;

  ProductDetailsPage(this.productDetails);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  double _position = 0;
  bool _check = false;

  Future _addToCart() async {
    CollectionReference users = FirebaseFirestore.instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('items');

    return users
        .doc()
        .set({
          'image_path': widget.productDetails['image_path'],
          'price': widget.productDetails['price'],
          'name': widget.productDetails['name']
        })
        .then((value) =>
            Fluttertoast.showToast(msg: 'Successfully added to cart'))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future _checkExistingData() async {
    FirebaseFirestore.instance
        .collection('favorite')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('items')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['name'] == widget.productDetails['name']) {
          setState(() {
            _check = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    _checkExistingData();
    super.initState();
  }

  Future _addToFavorite() async {
    if (_check == true) {
      Fluttertoast.showToast(msg: 'Already added to favorite');
    } else if (_check == false) {
      CollectionReference users = FirebaseFirestore.instance
          .collection('favorite')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .collection('items');

      return users
          .doc()
          .set({
            'image_path': widget.productDetails['image_path'],
            'price': widget.productDetails['price'],
            'name': widget.productDetails['name']
          })
          .then((value) =>
              Fluttertoast.showToast(msg: 'Successfully added to favorite'))
          .catchError((error) => print("Failed to add user: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: CircleAvatar(
                backgroundColor: AppColors.deep_orange,
                child: IconButton(
                    onPressed: () {
                      _addToFavorite();
                    },
                    icon: _check == false
                        ? Icon(Icons.favorite_outline)
                        : Icon(Icons.favorite))),
          ),
        ],
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundColor: AppColors.deep_orange,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back)),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.w),
              child: Column(
                children: [
                  AspectRatio(
                      aspectRatio: 3 / 1.5,
                      child: CarouselSlider(
                        items: widget.productDetails['image_path']
                            .map<Widget>((item) {
                          return Container(
                              width: 250.w,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Image.network(item,
                                      fit: BoxFit.fitHeight)));
                        }).toList(),
                        options: CarouselOptions(onPageChanged: (val, reason) {
                          setState(() {
                            _position = val.toDouble();
                          });
                        }),
                      )),
                  DotsIndicator(
                    dotsCount: widget.productDetails['image_path'].length,
                    position: _position,
                    decorator: DotsDecorator(
                        spacing: EdgeInsets.all(5.w),
                        size: Size(6.w, 6.w),
                        activeSize: Size(8.w, 8.w),
                        color: AppColors.deep_orange.withOpacity(0.4),
                        activeColor: AppColors.deep_orange),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    widget.productDetails['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    '\$${widget.productDetails['price']}'.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Product description',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.deep_orange)),
                    height: 150.h,
                    width: ScreenUtil().screenWidth,
                    child: SingleChildScrollView(
                      child: Text(
                        widget.productDetails['product_description'],
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: ScreenUtil().screenWidth,
                        margin: EdgeInsets.only(bottom: 20.w),
                        decoration: BoxDecoration(
                            color: AppColors.deep_orange,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          onPressed: () {
                            _addToCart();
                          },
                          child: Text(
                            'ADD TO CART',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
