import 'dart:convert';

import 'package:cipherx/controllers/product_controller.dart';
import 'package:cipherx/features/product.dart';
import 'package:cipherx/models/makeup_model.dart';
import 'package:cipherx/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class GetProductList {
  List<Makup> productlist = [];

  Future<void> getproduct(WidgetRef ref, BuildContext context) async {
    productlist.clear();
    ref.read(isloading.notifier).state = true;
    Response response = await http.get(Uri.parse(
        'http://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline'));
    var responsedata = jsonDecode(response.body);
    print(responsedata.toString());
    if (response.statusCode == 200) {
      ref.read(isloading.notifier).state = false;
      for (Map<String, dynamic> i in responsedata) {
        productlist.add(Makup.fromJson(i));
      }
      ref.read(makeuplistprovider.notifier).state = productlist;
    } else {
      ref.read(isloading.notifier).state = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('something went wrong')));
    }
  }
}
