import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caseapp/view_model/favorites_view_model.dart';
import 'package:caseapp/view_model/cart_view_model.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesViewModel = Provider.of<FavoritesViewModel>(context);
    final cartViewModel = Provider.of<CartViewModel>(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('F A V O R I T E S'),
      ),
      body: favoritesViewModel.favorites.isEmpty
          ? Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favoritesViewModel.favorites.length,
              itemBuilder: (context, index) {
                final flower = favoritesViewModel.favorites[index];
                return Column(
                  children: [
                    ListTile(
                      leading: Image.asset(
                        flower.imagePath,
                        width: screenSize.width * 0.2, 
                        height: screenSize.height * 0.1, 
                      ),
                      title: Text(flower.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(flower.description),
                          Text('\$${flower.price}'),
                          SizedBox(height: screenSize.height * 0.01), 
                          Container(
                            width: screenSize.width * 0.25, 
                            height: screenSize.height * 0.04, 
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: () {
                                cartViewModel.addItemToCart(flower, 1);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${flower.name} added to cart')),
                                );
                              },
                              child: Text(
                                'Add to Cart', 
                                style: TextStyle(
                                  color: Color.fromARGB(255, 110, 19, 13),
                                  fontSize: screenSize.width * 0.03, 
                                )),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          favoritesViewModel.removeFavorite(flower.id);
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.01, 
                        horizontal: screenSize.width * 0.04, 
                      ),
                    ),
                    if (index < favoritesViewModel.favorites.length - 1)
                      Divider(
                        color: Colors.grey,
                        height: 1,
                        thickness: 1,
                        indent: screenSize.width * 0.04, 
                        endIndent: screenSize.width * 0.04, 
                      ),
                  ],
                );
              },
            ),
    );
  }
}
