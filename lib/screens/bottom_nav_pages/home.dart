import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_shopping_app/const/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../details_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('carousel_slider');
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  final List<String> _carouselImageLink = [];
  double _currentPosition = 0;

  List<Map> _productImages = [];

  _fetchCarouselImages() async {
    _users.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _carouselImageLink.add(doc['image_path']);
        });
      });
    });
  }

  _fetchProductsImages() async {
    _products.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _productImages.add({
            'image_path': doc['image_path'],
            'price': doc['price'],
            'product_description': doc['product_description'],
            'name': doc['product_name']
          });
        });
      });
    });
  }

  @override
  void initState() {
    _fetchCarouselImages();
    _fetchProductsImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 55.h,
                      child: TextFormField(
                        readOnly: true,
                        onTap: () {
                          Navigator.of(context).pushNamed('Search_Screen');
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.blue)),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.grey)),
                            hintText: 'Search product here ...',
                            hintStyle: TextStyle(fontSize: 15.sp)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              CarouselSlider(
                  items: _carouselImageLink.map((item) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                      aspectRatio: 3 / 1.5,
                      onPageChanged: (val, carouselpagechangereason) {
                        setState(() {
                          _currentPosition = val.toDouble();
                        });
                      })),
              SizedBox(
                height: 10.w,
              ),
              DotsIndicator(
                dotsCount: _carouselImageLink.length == 0
                    ? 1
                    : _carouselImageLink.length,
                position: _currentPosition,
                decorator: DotsDecorator(
                    size: Size(6.w, 6.w),
                    spacing: EdgeInsets.only(left: 5.w, right: 5.w),
                    activeSize: Size(8.w, 8.w),
                    activeColor: AppColors.deep_orange,
                    color: AppColors.deep_orange.withOpacity(0.5)),
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.w,
                      mainAxisSpacing: 5.h,
                      childAspectRatio: 1),
                  itemCount: _productImages.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => ProductDetailsPage(_productImages[index])));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.hardEdge,
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                child: AspectRatio(
                                  aspectRatio: 2 / 1.5,
                                  child: Image.network(
                                      _productImages[index]['image_path'][0]),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(_productImages[index]['name']),
                                  Text("\$${_productImages[index]['price']}"
                                      .toString()),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
