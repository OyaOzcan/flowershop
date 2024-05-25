import 'package:caseapp/model/product.dart';
import 'package:caseapp/view/all_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:caseapp/view/detail_page.dart';
import 'package:caseapp/view_model/products_view_model.dart';
import 'package:provider/provider.dart';
import 'package:caseapp/view_model/cart_view_model.dart';
import 'package:caseapp/view_model/favorites_view_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> images = [
    'assets/slider/slider1.png',
    'assets/slider/slider2.png',
    'assets/slider/slider3.png',
    'assets/slider/slider4.png',
  ];
  String? _userName;

  int _currentImageIndex = 0;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProductsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Welcome, $_userName'),
            CircleAvatar(
              radius: 25,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSlider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildCategories(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildProducts(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    List<String> categories = ['All', 'Roses', 'Tulips', 'Orchids', 'Daisies', 'Irises', 'Sunflowers', 'Herbs', 'Lilies', 'Specials', 'Carnations'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = categories[index];
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductsPage(category: categories[index])),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xffF4C2C2),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _selectedCategory == categories[index] ? Color.fromARGB(255, 251, 251, 251) : const Color.fromARGB(255, 110, 19, 13),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProducts(ProductsViewModel viewModel) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Popular Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsPage()));
                },
                child: Text('See All', style: TextStyle(fontSize: 16, color:Color.fromARGB(255, 110, 19, 13), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Container(
          height: screenHeight * 0.6,
          padding: const EdgeInsets.all(2.0),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (screenWidth / (screenHeight * 0.45)),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: viewModel.flowers.length > 4 ? 4 : viewModel.flowers.length,
            itemBuilder: (context, index) {
              final flower = viewModel.flowers[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlowerDetailView(flower: flower)),
                  );
                },
                child: _buildCard(
                  context,
                  flower,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, Flower flower) {
    var screenHeight = MediaQuery.of(context).size.height;
    final isFavorite = Provider.of<FavoritesViewModel>(context).isFavorite(flower);
    final isInCart = Provider.of<CartViewModel>(context).isItemInCart(flower);

    return Card(
      color: Colors.white, 
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight * 0.1,
                  width: screenHeight * 0.1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(flower.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    flower.name,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  '\$${flower.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
                  final snackBar = SnackBar(content: Text('${flower.name} deleted from favorites!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  Provider.of<FavoritesViewModel>(context, listen: false).addFavorite(flower);
                  final snackBar = SnackBar(content: Text('${flower.name} added favorites!'));
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
    );
  }

  Widget _buildSlider() {
    return CarouselSlider.builder(
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                image: AssetImage(images[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 155,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, reason) {
          setState(() {
            _currentImageIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildProductList(ProductsViewModel viewModel) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _selectedCategory == 'All' ? viewModel.flowers.length : viewModel.filteredFlowers.length,
      itemBuilder: (context, index) {
        final flower = _selectedCategory == 'All' ? viewModel.flowers[index] : viewModel.filteredFlowers[index];
        return Card(
          child: ListTile(
            title: Column(
              children: [
                Image.asset(flower.imagePath, width: 50, height: 50),
                Text(flower.name),
                Text('\$${flower.price}'),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FlowerDetailView(flower: flower)),
              );
            },
          ),
        );
      },
    );
  }

   void _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _userName =
            userData.data()?['username'] ?? user.displayName ?? 'Kullanıcı Adı';
      });
    }
  }

}
