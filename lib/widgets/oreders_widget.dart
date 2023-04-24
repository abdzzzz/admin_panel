import 'package:flutter/material.dart';

import '../services/utils.dart';
import 'text_widget.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({Key? key}) : super(key: key);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  'https://i5.walmartimages.com/asr/943f9068-0b85-4bec-9be3-406547f8bd5c.3a3dbb0e35b878d3755cfdebea7f9155.png',
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: ' 5د.ل x8',
                      color: color,
                      textSize: 12,
                      isTitle: true,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'من',
                            color: Colors.blue,
                            textSize: 12,
                            isTitle: true,
                          ),
                          TextWidget(
                            text: 'الزبون',
                            color: color,
                            textSize: 12,
                            isTitle: true,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '20/4/2023',
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
