import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  double get totalAmount {
    return _items.values
        .fold(0.0, (sum, item) => sum + item.price * item.quantity);
  }

  void addItem(String productId, double price, String title, String imageUrl) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity + 1,
            price: existingCartItem.price,
            imageUrl: existingCartItem.imageUrl),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: productId,
            title: title,
            quantity: 1,
            price: price,
            imageUrl: imageUrl),
      );
    }
    saveCartToLocalStorage();
    notifyListeners();
  }

  void removeItem(String productId,BuildContext context) {
    _items.remove(productId);
    saveCartToLocalStorage();
    notifyListeners();
    if (_items.isEmpty) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }
  }


  void clearCart() {
    _items = {};
    saveCartToLocalStorage();
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          imageUrl: existingCartItem.imageUrl,
          quantity: quantity,
        ),
      );
      print(quantity);
      saveCartToLocalStorage();
      notifyListeners();
    }
  }

  Future<void> addOrder() async {
    print('Order placed');
    _items.clear();
    notifyListeners();
  }

  Future<void> completeOrder(address, paymentMethod) async {
    _items.clear();
    clearCart();
    notifyListeners();
  }

  // Save the cart to local storage
  Future<void> saveCartToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = _items.map((key, item) => MapEntry(key, item.toJson()));
    prefs.setString('cartItems', json.encode(cartData));
  }

  // Load the cart from local storage
  Future<void> loadCartFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('cartItems')) return;

    final extractedData =
        json.decode(prefs.getString('cartItems')!) as Map<String, dynamic>;
    _items = extractedData.map((key, value) =>
        MapEntry(key, CartItem.fromJson(value as Map<String, dynamic>)));
    notifyListeners();
  }
}
