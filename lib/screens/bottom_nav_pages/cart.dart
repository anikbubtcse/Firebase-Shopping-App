import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  Widget _cardData(data, index) {
    return Card(
      elevation: 5.w,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data[index]['image_path'][0]),
        ),
        title: Text('${data[index]['name']}'),
        subtitle: Text('\$${data[index]['price']}'.toString()),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('cart')
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection('items')
                .doc(data[index].id)
                .delete();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
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

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs;

                  return _cardData(data, index);
                });
          },
        ),
      ),
    );
  }
}
