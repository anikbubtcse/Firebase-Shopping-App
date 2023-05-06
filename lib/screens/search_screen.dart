import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_shopping_app/const/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _productName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.w),
          child: Column(
            children: [
              SizedBox(
                  height: 55.h,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _productName = value;
                      });
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.blue,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.zero),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.zero)),
                  )),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .snapshots(),
                  builder: (context, snapshop) {
                    return snapshop.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                itemCount: snapshop.data!.docs.length,
                                itemBuilder: (context, index) {
                                  if (_productName.isEmpty) {
                                    return (ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshop
                                            .data!
                                            .docs[index]['image_path'][0]),
                                      ),
                                      title: Text(snapshop.data!.docs[index]
                                          ['product_name']),
                                      subtitle: Text(
                                          '\$${snapshop.data!.docs[index]['price'].toString()}'),
                                    ));
                                  }

                                  if (snapshop.data!.docs[index]['product_name']
                                      .toString()
                                      .toLowerCase()
                                      .startsWith(_productName.toLowerCase())) {
                                    return (ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshop
                                            .data!
                                            .docs[index]['image_path'][0]),
                                      ),
                                      title: Text(snapshop.data!.docs[index]
                                          ['product_name']),
                                      subtitle: Text(
                                          '\$${snapshop.data!.docs[index]['price'].toString()}'),
                                    ));
                                  }
                                  return Container();
                                }));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
