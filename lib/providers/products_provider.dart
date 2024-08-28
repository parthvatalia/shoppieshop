import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = [
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

  List<Product> get items => [..._items];

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void update(String? token) {
  }
}
