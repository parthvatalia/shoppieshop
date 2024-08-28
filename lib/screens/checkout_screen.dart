import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/success_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  static const routeName = '/checkout';

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  final _addressController = TextEditingController();
  String? _selectedPaymentMethod;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handlePaymentMethodSelected(String methodId) {
    setState(() {
      _selectedPaymentMethod = methodId;
    });
  }

  Future<void> _placeOrder() async {
    final cart = Provider.of<CartProvider>(context, listen: false);

    if (_selectedPaymentMethod != null) {
      await cart.completeOrder(
        _addressController.text,
        _selectedPaymentMethod!,
      );

      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const SuccessDialog(message: 'Order placed successfully!');
        },
      );

      // Wait for 3 seconds before navigating back
      await Future.delayed(const Duration(seconds: 3));

      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 10),
                  PaymentMethodSelector(
                    onMethodSelected: _handlePaymentMethodSelected,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Order Summary',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Consumer<CartProvider>(
                    builder: (ctx, cart, child) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: cart.items.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          title: Text(cart.items.values.elementAt(index).title),
                          subtitle: Text(
                              'Price: \$${cart.items.values.elementAt(index).price}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cart.removeItem(
                                  cart.items.values.elementAt(index).id,context);
                            },
                          ),
                          leading: Text(
                            '${cart.items.values.elementAt(index).quantity}x',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Consumer<CartProvider>(
                    builder: (ctx, cart, child) => Text(
                      'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _placeOrder,
                    child: const Text('Place Order'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
