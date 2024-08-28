import 'package:flutter/material.dart';

import '../models/payment_method.dart';

class PaymentMethodSelector extends StatefulWidget {
  final Function(String) onMethodSelected;

  const PaymentMethodSelector({Key? key, required this.onMethodSelected}) : super(key: key);

  @override
  _PaymentMethodSelectorState createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends State<PaymentMethodSelector> {

  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(id: 'credit_card', title: 'Credit Card', icon: Icons.credit_card),
    PaymentMethod(id: 'paypal', title: 'PayPal', icon: Icons.payment),
    PaymentMethod(id: 'cod', title: 'Cash on Delivery', icon: Icons.money_off),
  ];
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20,),
         Text('payment method' ,  style: Theme.of(context).textTheme.headlineSmall,),
        ListView.builder(
          shrinkWrap: true,
          itemCount: paymentMethods.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              leading: Icon(paymentMethods[index].icon),
              title: Text(paymentMethods[index].title),
              trailing: _selectedPaymentMethod == paymentMethods[index].id
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = paymentMethods[index].id;
                });
                widget.onMethodSelected(_selectedPaymentMethod!);
              },
            );
          },
        ),
      ],
    );
  }
}
