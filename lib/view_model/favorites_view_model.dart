import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:caseapp/model/product.dart';

class FavoritesViewModel with ChangeNotifier {
  List<Flower> favorites = [];

  FavoritesViewModel() {
    loadFavoritesFromPrefs();
  }

  void addFavorite(Flower flower) {
    if (!isFavorite(flower)) {
      favorites.add(flower);
      saveFavoritesToPrefs();
      notifyListeners();
    }
  }

  void removeFavorite(String flowerId) {
    favorites.removeWhere((flower) => flower.id == flowerId);
    saveFavoritesToPrefs();
    notifyListeners();
  }

  bool isFavorite(Flower flower) {
    return favorites.any((item) => item.id == flower.id);
  }

  Future<void> saveFavoritesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteItemsJson = favorites.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList('favorites', favoriteItemsJson);
  }

  Future<void> loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteItemsJson = prefs.getStringList('favorites') ?? [];
    favorites = favoriteItemsJson.map((itemJson) {
      Map<String, dynamic> itemMap = json.decode(itemJson);
      return Flower.fromJson(itemMap);
    }).toList();
    notifyListeners();
  }
}
