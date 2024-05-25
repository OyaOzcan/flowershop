import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caseapp/view_model/cart_view_model.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('C A R T'),
        ),
        body: Consumer<CartViewModel>(
          builder: (context, cartViewModel, child) {
            double totalPrice = cartViewModel.cartItems.fold(
              0.0,
              (sum, item) => sum + item.flower.price * item.quantity,
            );
            return Column(
              children: [
                Expanded(
                  child: cartViewModel.cartItems.isEmpty
                      ? Center(child: Text('No items in the cart'))
                      : ListView.builder(
                          itemCount: cartViewModel.cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartViewModel.cartItems[index];
                            return Dismissible(
                              key: Key(cartItem.flower.id),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                cartViewModel.removeItemFromCart(cartItem.flower.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${cartItem.flower.name} removed from cart')),
                                );
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: Card(
                                color: Colors.white,
                                child: ListTile(
                                  leading: Image.asset(cartItem.flower.imagePath),
                                  title: Text(cartItem.flower.name),
                                  subtitle: Text('Quantity: ${cartItem.quantity}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      cartViewModel.removeItemFromCart(cartItem.flower.id);
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                           Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Köşelerin ovalliğini azalt
                                ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _processPayment(context, totalPrice);
                        },
                        child: Text('Proceed to Payment',
                        style: TextStyle(
                          color: Color.fromARGB(255, 110, 19, 13),
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, double amount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Successful'),
          content: Text('Your payment of \$${amount.toStringAsFixed(2)} has been processed successfully.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Provider.of<CartViewModel>(context, listen: false).cartItems.clear();
                Provider.of<CartViewModel>(context, listen: false).saveCartToPrefs();
                Navigator.of(context).pop(); // AlertDialog'u kapat
              },
            ),
          ],
        );
      },
    ).then((_) {
      Provider.of<CartViewModel>(context, listen: false).notifyListeners();
    });
  }
}
