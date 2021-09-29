import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/provider/cart_provider.dart';
import 'package:volt_arena/provider/favs_provider.dart';
import 'package:volt_arena/provider/products.dart';
import 'package:volt_arena/widget/feeds_products.dart';
import 'package:volt_arena/wishlist/wishlist.dart';

import 'cart/cart.dart';
import 'consts/colors.dart';
import 'consts/my_icons.dart';
import 'models/product.dart';

class Feeds extends StatefulWidget {
  static const routeName = '/Feeds';

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> {
  Future<void> _getProductsOnRefresh() async {
    await Provider.of<Products>(context, listen: false).fetchProducts();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProductsOnRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)!.settings.arguments;
    final productsProvider = Provider.of<Products>(
      context,
    );

    List<Product> productsList = productsProvider.products;
    if (popular == 'popular') {
      productsList = productsProvider.popularProducts;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text('Services'),
          centerTitle: true,
          actions: [
            Consumer<FavsProvider>(
              builder: (_, favs, ch) => Badge(
                badgeColor: ColorsConsts.cartBadgeColor,
                animationType: BadgeAnimationType.slide,
                toAnimate: true,
                position: BadgePosition.topEnd(top: 5, end: 7),
                badgeContent: Text(
                  favs.getFavsItems.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  icon: Icon(
                    MyAppIcons.wishlist,
                    color: ColorsConsts.favColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(WishlistScreen.routeName);
                  },
                ),
              ),
            ),
            Consumer<CartProvider>(
              builder: (_, cart, ch) => Badge(
                badgeColor: ColorsConsts.cartBadgeColor,
                animationType: BadgeAnimationType.slide,
                toAnimate: true,
                position: BadgePosition.topEnd(top: 5, end: 7),
                badgeContent: Text(
                  cart.getCartItems.length.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                  icon: Icon(
                    MyAppIcons.cart,
                    color: ColorsConsts.cartColor,
                  ),
                  onPressed: () {
                    // Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                ),
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _getProductsOnRefresh,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 240 / 420,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: List.generate(productsList.length, (index) {
              return ChangeNotifierProvider.value(
                value: productsList[index],
                child: FeedProducts(),
              );
            }),
          ),
        ),

        //         StaggeredGridView.countBuilder(
        //           padding: ,
        //   crossAxisCount: 6,
        //   itemCount: 8,
        //   itemBuilder: (BuildContext context, int index) =>FeedProducts(),
        //   staggeredTileBuilder: (int index) =>
        //       new StaggeredTile.count(3, index.isEven ? 4 : 5),
        //   mainAxisSpacing: 8.0,
        //   crossAxisSpacing: 6.0,
        // ),
      ),
    );
  }
}
