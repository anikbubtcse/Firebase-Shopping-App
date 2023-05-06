import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Expanded(
            child: Container(
                padding: EdgeInsets.all(20.w),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('favorite')
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .collection('items')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('There are some error'));
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView(
                        children: snapshot.data!.docs.map((document) {
                          return Card(
                            elevation: 8.w,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    NetworkImage(document['image_path'][1]),
                              ),
                              title: Text(document['name']),
                              subtitle: Text(
                                '${document['price']}'.toString(),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('favorite')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .collection('items')
                                      .doc(document.id)
                                      .delete();
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                )))
      ],
    ));
  }
}
