import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItemWidget(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(productId,context);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
