import 'package:flutter/material.dart';

import '../consts/constants.dart';
import '../responsive.dart';
import '../services/utils.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.fct,
    required this.title,
    this.showTextfield = true, required bool showTexField,
  }) : super(key: key);

  final Function fct;
  final String title;
  final bool showTextfield;
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = Utils(context).color;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                fct();
              },
            ),
          if (Responsive.isDesktop(context))
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
          !showTextfield
              ? Container()
              : Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "البحث",
                      fillColor: Theme.of(context).cardColor,
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      suffixIcon: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(defaultPadding * 0.75),
                          margin: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: const Icon(
                            Icons.search,
                            size: 25,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
