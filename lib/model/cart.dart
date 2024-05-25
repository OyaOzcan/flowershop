import 'package:caseapp/model/product.dart';
class Cart {
  List<CartItem> items = [];

  void addItem(Flower flower) {
    CartItem? existingItem;
    try {
      existingItem = items.firstWhere((item) => item.flower.id == flower.id);
    } catch (e) {
      existingItem = null;
    }

    if (existingItem != null) {
      existingItem.increment();
    } else {
      items.add(CartItem(flower: flower));
    }
  }

  void removeItem(String flowerId) {
    items.removeWhere((item) => item.flower.id == flowerId);
  }
}

class CartItem {
  final Flower flower;
  int quantity;

  CartItem({required this.flower, this.quantity = 1});

  void increment() {
    quantity++;
  }

  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }
}
