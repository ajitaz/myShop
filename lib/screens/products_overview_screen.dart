import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../providers/cart.dart';
import './cart_screen.dart';

enum FiltersOption { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FiltersOption selectedValue) {
              setState(() {
                if (selectedValue == FiltersOption.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites only'),
                value: FiltersOption.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FiltersOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch as Widget,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer:AppDrawer(),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
