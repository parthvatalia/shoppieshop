import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity + 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    saveCartToLocalStorage();
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    saveCartToLocalStorage();
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    saveCartToLocalStorage();
    notifyListeners();
  }

  Future<void> addOrder() async {
    print('Order placed');
    _items.clear();
    notifyListeners();
  }

  Future<void> completeOrder() async {
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
