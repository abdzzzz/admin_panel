import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';
import 'loading_manager.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen(
      {Key? key,
      required this.id,
      required this.title,
      required this.price,
      required this.salePrice,
      required this.productCat,
      required this.imageUrl,
      required this.isOnSale,
      required this.des})
      : super(key: key);

  final String id, title, des, price, productCat, imageUrl;
  final bool isOnSale;
  final double salePrice;
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  // Title and price controllers
  late final TextEditingController _titleController,
      _priceController,
      _desController;
  // Category
  late String _catValue;
  // Sale
  String? _salePercent;
  late String percToShow;
  late double _salePrice;
  late bool _isOnSale;
  // Image
  File? _pickedImage;
  Uint8List webImage = Uint8List(10);
  late String _imageUrl;

  bool _isLoading = false;
  @override
  void initState() {
    _priceController = TextEditingController(text: widget.price);
    _desController = TextEditingController(text: widget.des);
    _titleController = TextEditingController(text: widget.title);

    _salePrice = widget.salePrice;
    _catValue = widget.productCat;
    _isOnSale = widget.isOnSale;

    _imageUrl = widget.imageUrl;
    // Calculate the percentage
    percToShow =
        '${(100 - (_salePrice * 100) / double.parse(widget.price)).round().toStringAsFixed(2)}%';
    super.initState();
  }

  @override
  void dispose() {
    // Dispose the controllers
    _priceController.dispose();
    _titleController.dispose();
    _desController.dispose();
    super.dispose();
  }

  void _updateProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    String? imageUrl;
    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage != null) {}

      try {
        setState(() {
          _isLoading = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child('${widget.id}.jpg');

        if (kIsWeb) /* if web */ {
          // putData() accepts Uint8List type argument
          await ref.putData(webImage).whenComplete(() async {
            final imageUri = await ref.getDownloadURL();
            await FirebaseFirestore.instance
                .collection('products')
                .doc(widget.id)
                .update({
              'title': _titleController.text,
              'price': _priceController.text,
              'salePrice': _salePrice,
              'imageUrl': imageUri.toString(),
              'productCategoryName': _catValue,
              'isOnSale': _isOnSale,
              'des': _desController.text,
            });
          });
        } else /* if mobile */ {
          // putFile() accepts File type argument
          await ref.putFile(_pickedImage!).whenComplete(() async {
            final imageUri = await ref.getDownloadURL();
            await FirebaseFirestore.instance
                .collection('products')
                .doc(widget.id)
                .update({
              'title': _titleController.text,
              'price': _priceController.text,
              'salePrice': _salePrice,
              'imageUrl': imageUri.toString(),
              'productCategoryName': _catValue,
              'isOnSale': _isOnSale,
              'des': _desController.text,
            });
          });
        }

        Fluttertoast.showToast(
          msg: "تم تعديل المنتج",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      // key: context.read<MenuControllerr>().getEditProductscaffoldKey,
      drawer: const SideMenu(),
      body: Row(
        children: [
          // if (Responsive.isDesktop(context))
          // const Expanded(
          // child: SideMenu(),
          //),
          Expanded(
            flex: 5,
            child: LoadingManager(
              isLoading: _isLoading,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //  Header(
                    //  showTexField: false,
                    //fct: () {
                    //context
                    //  .read<MenuControllerr>()
                    //.controlEditProductsMenu();
                    //},
                    //  title: 'تعديل المنتج',
                    //  ),
                    Center(
                      child: Container(
                        width: size.width > 650 ? 650 : size.width,
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextWidget(
                                text: 'اسم الصنف',
                                color: color,
                                isTitle: true,
                                textSize: 12,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _titleController,
                                key: const ValueKey('Title'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'ادخل اسم الصنف';
                                  }
                                  return null;
                                },
                                decoration: inputDecoration,
                              ),
                              TextWidget(
                                text: ' وصف المنتج',
                                color: color,
                                textSize: 12,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _desController,
                                key: const ValueKey('Des'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'من فضلك الوصف';
                                  }
                                  return null;
                                },
                                decoration: inputDecoration,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: FittedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          TextWidget(
                                            text: 'السعر',
                                            color: color,
                                            textSize: 12,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: TextFormField(
                                              controller: _priceController,
                                              key: const ValueKey('Price د.ل'),
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'ادخل السعر';
                                                }
                                                return null;
                                              },
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9.]')),
                                              ],
                                              decoration: inputDecoration,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextWidget(
                                            text: 'نوع الصنف',
                                            color: color,
                                            isTitle: true,
                                            textSize: 12,
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            color: scaffoldColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: catDropDownWidget(color),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: _isOnSale,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _isOnSale = newValue!;
                                                  });
                                                },
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              TextWidget(
                                                text: 'التخفيض',
                                                color: color,
                                                isTitle: true,
                                                textSize: 12,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          AnimatedSwitcher(
                                            duration:
                                                const Duration(seconds: 1),
                                            child: !_isOnSale
                                                ? Container()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextWidget(
                                                        text:
                                                            "د.ل${_salePrice.toStringAsFixed(1)}",
                                                        color: color,
                                                        textSize: 15,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      salePourcentageDropDownWidget(
                                                          color),
                                                    ],
                                                  ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        height: size.width > 650
                                            ? 350
                                            : size.width * 0.45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(12)),
                                          child: _pickedImage == null
                                              ? Image.network(_imageUrl)
                                              : (kIsWeb)
                                                  ? Image.memory(
                                                      webImage,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image.file(
                                                      _pickedImage!,
                                                      fit: BoxFit.fill,
                                                    ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          FittedBox(
                                            child: TextButton(
                                              onPressed: () {
                                                _pickImage();
                                              },
                                              child: TextWidget(
                                                text: 'تحميل صورة',
                                                color: Colors.blue,
                                                textSize: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ButtonsWidget(
                                      onPressed: () async {
                                        GlobalMethods.warningDialog(
                                            title: 'الحذف?',
                                            subtitle: 'اضغط موافق للحذف',
                                            fct: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('products')
                                                  .doc(widget.id)
                                                  .delete();
                                              await Fluttertoast.showToast(
                                                msg: "تم حذف المنتج",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                              );
                                              while (
                                                  Navigator.canPop(context)) {
                                                Navigator.pop(context);
                                              }
                                            },
                                            context: context);
                                      },
                                      text: 'حذف',
                                      icon: IconlyBold.danger,
                                      backgroundColor: Colors.red.shade700,
                                    ),
                                    ButtonsWidget(
                                      onPressed: () {
                                        _updateProduct();
                                      },
                                      text: 'تحديث',
                                      icon: IconlyBold.setting,
                                      backgroundColor: Colors.blue,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownButtonHideUnderline salePourcentageDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem<String>(
            value: '10',
            child: Text('10%'),
          ),
          DropdownMenuItem<String>(
            value: '15',
            child: Text('15%'),
          ),
          DropdownMenuItem<String>(
            value: '25',
            child: Text('25%'),
          ),
          DropdownMenuItem<String>(
            value: '50',
            child: Text('50%'),
          ),
          DropdownMenuItem<String>(
            value: '75',
            child: Text('75%'),
          ),
          DropdownMenuItem<String>(
            value: '0',
            child: Text('0%'),
          ),
        ],
        onChanged: (value) {
          if (value == '0') {
            return;
          } else {
            setState(() {
              _salePercent = value;
              _salePrice = double.parse(widget.price) -
                  (double.parse(value!) * double.parse(widget.price) / 100);
            });
          }
        },
        hint: Text(_salePercent ?? percToShow),
        value: _salePercent,
      ),
    );
  }

  DropdownButtonHideUnderline catDropDownWidget(Color color) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        style: TextStyle(color: color),
        items: const [
          DropdownMenuItem(
            value: 'اختار النوع',
            child: Text('اختار النوع'),
          ),
          DropdownMenuItem(
            value: 'الفيتامينات',
            child: Text('الفيتامينات'),
          ),
          DropdownMenuItem(
            value: 'العناية بالبشره',
            child: Text('العناية بالبشره'),
          ),
          DropdownMenuItem(
            value: 'العناية بالشعر',
            child: Text('العناية بالشعر'),
          ),
          DropdownMenuItem(
            value: 'الام والطفل',
            child: Text('الام والطفل'),
          ),
          DropdownMenuItem(
            value: 'الادوية',
            child: Text('الادوية'),
          ),
          DropdownMenuItem(
            value: 'الاجهزة الطبيه',
            child: Text('الاجهزة الطبيه'),
          ),
          DropdownMenuItem(
            value: 'المكياج والاكسسورات',
            child: Text('المكياج والاكسسورات'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _catValue = value!;
          });
        },
        hint: const Text('اختار النوع'),
        value: _catValue,
      ),
    );
  }

  Future<void> _pickImage() async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _pickedImage = selected;
        });
      } else {
        log('No file selected');
        // showToast("No file selected");
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _pickedImage = File("a");
          webImage = f;
        });
      } else {
        log('No file selected');
      }
    } else {
      log('Perm not granted');
    }
  }
}
