import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:caseapp/model/product.dart';

class CartViewModel with ChangeNotifier {
  List<CartItem> cartItems = [];

  CartViewModel() {
    loadCartFromPrefs();
  }

void addItemToCart(Flower flower, int quantity) {
  int index = cartItems.indexWhere((item) => item.flower.id == flower.id);
  if (index >= 0) {
    cartItems[index].quantity += quantity;
  } else {
    cartItems.add(CartItem(flower: flower, quantity: quantity));
  }
  saveCartToPrefs();
  notifyListeners();
}

  void removeItemFromCart(String flowerId) {
    cartItems.removeWhere((item) => item.flower.id == flowerId);
    saveCartToPrefs();
    notifyListeners();
  }

  Future<void> saveCartToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItemsJson = cartItems.map((item) {
      return json.encode({
        'flower': item.flower.toJson(),
        'quantity': item.quantity,
      });
    }).toList();
    await prefs.setStringList('cartItems', cartItemsJson);
  }

  Future<void> loadCartFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItemsJson = prefs.getStringList('cartItems') ?? [];
    cartItems = cartItemsJson.map((itemJson) {
      if (itemJson != null) {
        Map<String, dynamic> itemMap = json.decode(itemJson);
        if (itemMap['flower'] != null && itemMap['quantity'] != null) {
          Flower flower = Flower.fromJson(itemMap['flower']);
          int quantity = itemMap['quantity'];
          return CartItem(flower: flower, quantity: quantity);
        }
      }
      return null;
    }).whereType<CartItem>().toList();
    notifyListeners();
  }

  bool isItemInCart(Flower flower) {
    return cartItems.any((item) => item.flower.id == flower.id);
  }
   double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + item.quantity * item.flower.price);
  }
}

class CartItem {
  Flower flower;
  int quantity;

  CartItem({required this.flower, required this.quantity});
}
