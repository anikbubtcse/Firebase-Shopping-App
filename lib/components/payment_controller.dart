import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentController {
  Map<String, dynamic>? paymentIntent;

  void makePayment() async {
    try {
      paymentIntent = await createPaymentIntent();

      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "us", currencyCode: "USD", testEnv: true);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!["client_secret"],
            style: ThemeMode.dark,
            merchantDisplayName: 'Anik Saha',
            googlePay: gpay),
      );
      displayPaymentSheet();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("Done");
    } catch (e) {
      print("Failed");
    }
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {'amount': "100", 'currency': 'USD'};
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51NGpvjE0WnZRRNjI4AwW4Gtt3E1Tng5Xwy6YMOLOt97XUMnup5JmK4ux15ut0NDI3D0hrtVXsiyx2CSXC7T3JmOJ0014rIgZnK",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
