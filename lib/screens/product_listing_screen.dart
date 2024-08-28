import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductListingScreen extends StatelessWidget {
  ProductListingScreen({Key? key}) : super(key: key);

  final List<Product> products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          "https://cdn.pixabay.com/photo/2013/07/12/15/34/shirt-150087_1280.png",
    ),
    Product(
      id: 'p2',
      title: 'Blue Jeans',
      description: 'A nice pair of blue jeans.',
      price: 59.99,
      imageUrl:
          "https://cdn.pixabay.com/photo/2013/07/12/18/22/t-shirt-153369_1280.png",
    ),
    Product(
      id: 'p3',
      title: 'Green Hoodie',
      description: 'A warm green hoodie for winter.',
      price: 89.99,
      imageUrl:
          "https://cdn.pixabay.com/photo/2016/07/26/07/16/hoodie-1542198_1280.png",
    ),
    Product(
      id: 'p4',
      title: 'Black Sneakers',
      description: 'Stylish black sneakers.',
      price: 79.99,
      imageUrl:
          "https://cdn.pixabay.com/photo/2014/03/25/16/35/lace-up-shoes-297486_1280.png",
    ),
    Product(
      id: 'p5',
      title: 'White Cap',
      description: 'A simple white cap.',
      price: 19.99,
      imageUrl:
          "https://cdn.pixabay.com/photo/2014/04/02/14/10/hat-306380_1280.png",
    ),
    Product(
      id: 'p6',
      title: 'Leather Wallet',
      description: 'A classic leather wallet.',
      price: 49.99,
      imageUrl:
          "https://cdn.pixabay.com/photo/2023/08/12/02/59/wallet-8184645_640.png",
    ),
    Product(
      id: 'p7',
      title: 'Blue Scarf',
      description: 'A cozy blue scarf.',
      price: 34.99,
      imageUrl:
          "https://cdn.pixabay.com/photo/2021/04/27/18/36/scarf-6212163_640.png",
    ),
    Product(
      id: 'p8',
      title: 'Stylish Sunglasses',
      description: 'Sunglasses with a modern design.',
      price: 29.99,
      imageUrl:
          "https://cdn.pixabay.com/photo/2016/05/09/14/47/glasses-1381709_640.png",
    ),
    Product(
      id: 'p9',
      title: 'Casual Jacket',
      description: 'A casual jacket for daily wear.',
      price: 99.99,
      imageUrl:
          "https://cdn.pixabay.com/photo/2017/06/27/01/11/jacket-2445833_1280.png",
    ),
    Product(
      id: 'p10',
      title: 'Red Beanie',
      description: 'A warm red beanie.',
      price: 24.99,
      imageUrl:
          "https://cdn.pixabay.com/photo/2014/04/03/10/52/winter-311566_1280.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
            },
          ),
        ],
      ),
      body: AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: products.length,
          itemBuilder: (ctx, i) => AnimationConfiguration.staggeredGrid(
            position: i,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: ProductItem(product: products[i]),
              ),
            ),
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final scaffold = ScaffoldMessenger.of(context);

    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            cart.addItem(product.id, product.price, product.title);
            scaffold.showSnackBar(
              SnackBar(
                content: const Text(
                  'Added to cart!',
                ),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeItem(product.id);
                  },
                ),
              ),
            );
          },
          color: Theme.of(context).secondaryHeaderColor,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) => _buildProductDetail(context),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CachedNetworkImage(
            imageUrl: product.imageUrl,
            height: 300,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetail(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.close)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              height: 200,
              width: double.infinity,
              placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.contain,
            ),
          ),
          Text(
            product.title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 10),
          Text(
            '\$${product.price}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
