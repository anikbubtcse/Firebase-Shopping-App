import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_shopping_app/provider/cart_provider.dart';
import 'package:firebase_shopping_app/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../const/appcolors.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map productDetails;

  ProductDetailsPage(this.productDetails);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  double _position = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('favorite')
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection('items')
                .where('name', isEqualTo: widget.productDetails['name'])
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return Consumer<FavoriteProvider>(
                builder: (context, value, child) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: CircleAvatar(
                        backgroundColor: AppColors.deep_orange,
                        child: IconButton(
                            onPressed: () {
                              snapshot.data.docs.length == 0
                                  ? value.addToFavorite(widget.productDetails)
                                  : Fluttertoast.showToast(
                                      msg: 'already added to favorite');
                            },
                            icon: snapshot.data.docs.length == 0
                                ? Icon(Icons.favorite_outline)
                                : Icon(Icons.favorite))),
                  );
                },
              );
            },
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
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('cart')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .collection('items')
                        .where('name', isEqualTo: widget.productDetails['name'])
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (!snapshot.hasData) {
                        return Text('');
                      }
                      return Consumer<CartProvider>(
                        builder: (BuildContext context, value, Widget? child) {
                          return Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: ScreenUtil().screenWidth,
                                child: ElevatedButton(
                                  onPressed: () {
                                    snapshot.data.docs.length == 0
                                        ? value.addToCart(widget.productDetails)
                                        : Fluttertoast.showToast(
                                            msg: 'Already added to cart');
                                  },
                                  child: const Text(
                                    'ADD TO CART',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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
