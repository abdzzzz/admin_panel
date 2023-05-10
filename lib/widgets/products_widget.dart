import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/edit_prod.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  String title = '';
  String productCat = '';
  String des = '';
  String? imageUrl;

  String price = '0.0';
  double salePrice = 0.0;
  bool isOnSale = false;
  bool isPiece = false;

  @override
  void initState() {
    getProductsData();
    super.initState();
  }

  Future<void> getProductsData() async {
    try {
      final DocumentSnapshot productsDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.id)
          .get();
      if (productsDoc == null) {
        return;
      } else {
        setState(() {
          title = productsDoc.get('title');
          productCat = productsDoc.get('productCategoryName');
          imageUrl = productsDoc.get('imageUrl');
          price = productsDoc.get('price');
          salePrice = productsDoc.get('salePrice');
          isOnSale = productsDoc.get('isOnSale');
          isPiece = productsDoc.get('isPiece');
          des = productsDoc.get('des');
        });
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    final color = Utils(context).color;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor.withOpacity(0.6),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(
                    id: widget.id,
                    title: title,
                    price: price,
                    salePrice: salePrice,
                    productCat: productCat,
                    imageUrl: imageUrl!,
                    isOnSale: isOnSale,
                    des: des,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Image.network(
                            imageUrl!,
                            fit: BoxFit.fill,
                            height: size.width * 0.12,
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton(
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    onTap: () {},
                                    value: 1,
                                    child: const Text('تعديل'),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {},
                                    value: 2,
                                    child: const Text(
                                      'حذف',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ])
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        TextWidget(
                          text: isOnSale
                              ? 'د.ل${salePrice.toStringAsFixed(2)}'
                              : 'د.ل$price',
                          color: color,
                          textSize: 18,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Visibility(
                            visible: isOnSale,
                            child: Text(
                              'د.ل$price',
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: color),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    TextWidget(
                      text: title,
                      color: color,
                      textSize: 20,
                      isTitle: true,
                    ),
                  ]),
            ),
          ),
        ));
  }
}
