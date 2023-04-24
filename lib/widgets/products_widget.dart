import 'package:flutter/material.dart';

import '../services/utils.dart';
import 'text_widget.dart';

class ProductWidget extends StatefulWidget {
  const ProductWidget({
    Key? key,
  }) : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;

    final color = Utils(context).color;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).cardColor.withOpacity(0.6),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
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
                          'https://i5.walmartimages.com/asr/943f9068-0b85-4bec-9be3-406547f8bd5c.3a3dbb0e35b878d3755cfdebea7f9155.png',
                          fit: BoxFit.fill,
                          // width: screenWidth * 0.12,
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
                  TextWidget(
                    text: 'أدوية',
                    color: color,
                    textSize: 16,
                    isTitle: true,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: '5 د.ل',
                        color: color,
                        textSize: 12,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Visibility(
                          visible: true,
                          child: Text(
                            '10 د.ل',
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: color,
                                fontSize: 12),
                          )),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
