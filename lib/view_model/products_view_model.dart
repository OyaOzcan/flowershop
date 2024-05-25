import 'package:caseapp/model/sorting_option.dart';
import 'package:flutter/material.dart';
import 'package:caseapp/model/product.dart';

class ProductsViewModel with ChangeNotifier {
  List<Flower> flowers = [];
  List<Flower> filteredFlowers = [];
  SortingOption _currentSortingOption = SortingOption.alphabetical;

  ProductsViewModel() {
    loadFlowers();  
  }

  void loadFlowers() {
    flowers = [
      Flower(id: '1', name: 'Red Rose', price: 15.0, imagePath: 'assets/redrose.jpg', description: 'Beautiful red roses, perfect for any occasion.', category: 'Roses'),
      Flower(id: '2', name: 'Yellow Tulip', price: 12.0, imagePath: 'assets/yellowtulip.JPEG', description: 'Bright yellow tulips to brighten your day.', category: 'Tulips'),
      Flower(id: '3', name: 'Pink Orchid', price: 20.0, imagePath: 'assets/pinkorchid.jpeg', description: 'Elegant white orchids, a symbol of luxury and beauty.', category: 'Orchids'),
      Flower(id: '4', name: 'Pink Daisy', price: 8.0, imagePath: 'assets/flower.jpg', description: 'Charming pink daisies for a cheerful vibe.', category: 'Daisies'),
      Flower(id: '5', name: 'Blue Iris', price: 18.0, imagePath: 'assets/lale.jpg', description: 'Stunning blue irises, rich in color and depth.', category: 'Irises'),
      Flower(id: '6', name: 'Sunflower', price: 10.0, imagePath: 'assets/sunflower.JPG', description: 'Vibrant sunflowers, the epitome of summer.', category: 'Sunflowers'),
      Flower(id: '7', name: 'Lavender', price: 15.0, imagePath: 'assets/lavender.jpg', description: 'Calming lavender, perfect for relaxation.', category: 'Herbs'),
      Flower(id: '8', name: 'Lily', price: 22.0, imagePath: 'assets/lilyum.jpg', description: 'Delicate lilies, elegant and refined.', category: 'Lilies'),
      Flower(id: '9', name: 'Cherry Blossom', price: 25.0, imagePath: 'assets/sakayik.jpeg', description: 'Beautiful cherry blossoms, a sign of spring.', category: 'Specials'),
      Flower(id: '10', name: 'Carnation', price: 9.0, imagePath: 'assets/bucket2.jpg', description: 'Colorful carnations, a classic choice for any floral arrangement.', category: 'Carnations'),
      Flower(id: '11', name: 'White Daisy', price: 22.0, imagePath: 'assets/whitedaisyy.jpg', description: 'Delicate lilies, elegant and refined.', category: 'Daisies'),
      Flower(id: '12', name: 'Pink Rose', price: 25.0, imagePath: 'assets/pinkrose2.jpg', description: 'Beautiful cherry blossoms, a sign of spring.', category: 'Specials'),
      Flower(id: '13', name: 'Peony', price: 9.0, imagePath: 'assets/buket.jpg', description: 'Colorful carnations, a classic choice for any floral arrangement.', category: 'Roses')
    ];
    
    sortFlowers();
    notifyListeners();
  }

  void filterFlowersByCategory(String category) {
    filteredFlowers = flowers.where((flower) => flower.category == category).toList();
    notifyListeners();
  }

  void setSortingOption(SortingOption option) {
    _currentSortingOption = option;
    sortFlowers(); 
    notifyListeners();
  }
  void sortFlowers() {
    switch (_currentSortingOption) {
      case SortingOption.alphabetical:
        flowers.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortingOption.priceLowToHigh:
        flowers.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortingOption.priceHighToLow:
        flowers.sort((a, b) => b.price.compareTo(a.price));
        break;
    }
  }
  void searchFlowers(String searchTerm) {
  filteredFlowers = flowers.where((flower) =>
    flower.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
    flower.description.toLowerCase().contains(searchTerm.toLowerCase())
  ).toList();
  notifyListeners();
}
void resetFilters() {
  filteredFlowers = List<Flower>.from(flowers);
  notifyListeners();
}

}
