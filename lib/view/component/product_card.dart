import 'package:caseapp/model/product.dart';
import 'package:caseapp/view/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caseapp/view_model/cart_view_model.dart';
import 'package:caseapp/view_model/favorites_view_model.dart';

class ProductCard extends StatelessWidget {
  final Flower flower;

  const ProductCard({Key? key, required this.flower}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isFavorite = Provider.of<FavoritesViewModel>(context).isFavorite(flower);
    final isInCart = Provider.of<CartViewModel>(context).isItemInCart(flower);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FlowerDetailView(flower: flower)),
        );
      },
      child: Card(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: screenWidth * 0.4,
                    height: screenWidth * 0.4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(flower.imagePath),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(flower.name, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text('\$${flower.price}', style: TextStyle(color: Colors.grey)),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  if (isFavorite) {
                    Provider.of<FavoritesViewModel>(context, listen: false).removeFavorite(flower.id);
                    final snackBar = SnackBar(content: Text('${flower.name} favorilerden çıkarıldı!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    Provider.of<FavoritesViewModel>(context, listen: false).addFavorite(flower);
                    final snackBar = SnackBar(content: Text('${flower.name} favorilere eklendi!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                icon: Icon(isInCart ? Icons.shopping_cart : Icons.shopping_cart_outlined),
                onPressed: () {
                  if (isInCart) {
                    Provider.of<CartViewModel>(context, listen: false).removeItemFromCart(flower.id);
                    final snackBar = SnackBar(content: Text('${flower.name} deleted!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    Provider.of<CartViewModel>(context, listen: false).addItemToCart(flower, 1);
                    final snackBar = SnackBar(content: Text('${flower.name} added to cart!'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
