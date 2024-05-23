import 'package:cipherx/controllers/product_controller.dart';
import 'package:cipherx/features/product_details.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final isloading = StateProvider((ref) => false);

class MyProduct extends ConsumerWidget {
  const MyProduct({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var heigth = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final product = ref.watch(makeuplistprovider);
    var loading = ref.watch(isloading);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Product List'),
        centerTitle: true,
      ),
      body: loading == true
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: product.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                    itemindex: index,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                                height: heigth * 0.13,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.03, right: width * 0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: heigth * 0.1,
                                        width: width * 0.25,
                                        child: Image.network(
                                          '${product[index].imageLink}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'id : ${product[index].id}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'price : Rs.${product[index].price}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            'rating : ${product[index].rating}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          ),
                        );
                      }),
                ),
              ),
            ),
    );
  }
}
