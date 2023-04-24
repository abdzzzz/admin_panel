import 'package:admin_panel/screens/add_product.dart';
import 'package:admin_panel/widgets/buttons.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../consts/constants.dart';
import '../controllers/MenuController.dart';
import '../responsive.dart';
import '../services/utils.dart';
import '../widgets/grid_products.dart';
import '../widgets/header.dart';
import '../widgets/orders_list.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          controller: ScrollController(),
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Header(
                  fct: () {
                    context.read<MenuControllerr>().controlDashboarkMenu();
                  },
                  title: 'لوحة التحكم',
                  showTexField: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ButtonsWidget(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UploadProductForm()));
                        },
                        text: "اضافة صنف",
                        icon: Icons.add,
                        backgroundColor: Colors.blue),
                    const Spacer(),
                    ButtonsWidget(
                        onPressed: () {},
                        text: "مشاهدة الكل",
                        icon: Icons.store,
                        backgroundColor: Colors.blue),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // flex: 5,
                    child: Column(
                      children: [
                        Responsive(
                          mobile: ProductGridWidget(
                            crossAxisCount: size.width < 650 ? 2 : 4,
                            childAspectRatio:
                                size.width < 650 && size.width > 350
                                    ? 1.1
                                    : 0.8,
                          ),
                          desktop: ProductGridWidget(
                            childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          ),
                        ),
                        const OrdersList(),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
