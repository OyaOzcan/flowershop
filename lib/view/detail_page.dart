import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caseapp/model/product.dart';
import 'package:caseapp/view_model/cart_view_model.dart';
import 'package:caseapp/view_model/favorites_view_model.dart';

class FlowerDetailView extends StatefulWidget {
  final Flower flower;

  FlowerDetailView({required this.flower});

  @override
  _FlowerDetailViewState createState() => _FlowerDetailViewState();
}

class _FlowerDetailViewState extends State<FlowerDetailView> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: Colors.white
          ),
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Consumer<FavoritesViewModel>(
            builder: (context, favoritesViewModel, child) {
              bool isFavorite = favoritesViewModel.isFavorite(widget.flower);
              return IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  if (isFavorite) {
                    favoritesViewModel.removeFavorite(widget.flower.id);
                  } else {
                    favoritesViewModel.addFavorite(widget.flower);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              widget.flower.imagePath,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.6, // Yüksekliği artırın
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55, // Container'ı daha aşağıya çekin
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 232, 232),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: EdgeInsets.all(30.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.flower.name,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (_quantity > 1) {
                                        _quantity--;
                                      }
                                    });
                                  },
                                ),
                                Text(_quantity.toString(), style: TextStyle(fontSize: 20)),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      _quantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(widget.flower.description),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${widget.flower.price}',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Provider.of<CartViewModel>(context, listen: false).addItemToCart(widget.flower, _quantity);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${widget.flower.name} added to cart')),
                            );
                          },
                          child: Text('Add to Cart',
                          style: TextStyle(
                            color: Color.fromARGB(255, 110, 19, 13),
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
