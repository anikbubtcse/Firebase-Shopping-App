import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_shopping_app/components/payment_controller.dart';
import 'package:firebase_shopping_app/const/appcolors.dart';
import 'package:firebase_shopping_app/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  var obj = PaymentController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('cart')
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection('items')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text('Loading'),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Something error occured'),
                );
              }

              return Expanded(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs;
                      return Card(
                          elevation: 5.w,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        data[index]['image_path'][0]),
                                  ),
                                  Text('${data[index]['name']}'),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.email)
                                          .collection('items')
                                          .doc(data[index].id)
                                          .delete();
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                data[index]['counter'].toString(),
                                style: TextStyle(fontSize: 20.w),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Consumer<CartProvider>(
                                    builder: (BuildContext context, provider,
                                        Widget? child) {
                                      return FloatingActionButton(
                                        onPressed: () {
                                          provider.addition(data[index],
                                              data[index]['counter']);
                                        },
                                        child: Icon(
                                          Icons.add,
                                          size: 10.w,
                                        ),
                                      );
                                    },
                                  ),
                                  Consumer<CartProvider>(
                                    builder: (BuildContext context, provider,
                                        Widget? child) {
                                      return FloatingActionButton(
                                        onPressed: () {
                                          provider.subtraction(data[index],
                                              data[index]['counter']);
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          size: 10.w,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                            ],
                          ));
                    }),
              );
            },
          ),
          Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<CartProvider>(
                  builder: (BuildContext context, provider, Widget? child) {
                    provider.getCartAmount();
                    return Text(
                        'Total: \$${provider.amount.toStringAsFixed(2).toString()}',
                        style: TextStyle(
                            color: AppColors.deep_orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp));
                  },
                ),
                ElevatedButton(
                    onPressed: () {
                      obj.makePayment();
                    },
                    child: Text('CHECKOUT'))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
