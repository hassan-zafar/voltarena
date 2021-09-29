import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/upload_product_form.dart';

import 'bottom_bar.dart';
import 'provider/products.dart';

class MainScreens extends StatelessWidget {
  static const routeName = '/MainScreen';

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: PageView(
        children: [BottomBarScreen(), UploadProductForm()],
      ),
    );
  }
}
