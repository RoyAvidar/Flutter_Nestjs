import 'package:flutter/material.dart';
import 'package:flutter_main/models/address.dart';
import 'package:flutter_main/providers/address_provider.dart';
import 'package:flutter_main/providers/cart.dart';
import 'package:flutter_main/providers/orders.dart';
import 'package:flutter_main/screens/confirm_order_screen.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:pay/pay.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);
  static const routeName = '/payment';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var isLoading = true;
  bool _isChecked = false;
  bool _isChecked2 = false;
  Address? address;

  // final _paymentItems = [
  //   PaymentItem(
  //     label: 'Total',
  //     amount: '99.99',
  //     status: PaymentItemStatus.final_price,
  //   )
  // ];

  // void onGooglePayResult(paymentResult) {
  //   debugPrint(paymentResult.toString());
  // }

  // void onApplePayResult(paymentResult) {
  //   debugPrint(paymentResult.toString());
  // }

  Future<Address?> getAddress() async {
    final addressId = ModalRoute.of(context)!.settings.arguments as int;
    final addressData =
        await Provider.of<AddressProvider>(context, listen: false)
            .getAddressByID(addressId);
    setState(() {
      address = addressData;
      isLoading = false;
    });
    return address;
  }

  submit() async {
    final cartId =
        await Provider.of<CartProvider>(context, listen: false).getCartId();
    final order = await Provider.of<OrdersProvider>(context, listen: false)
        .addOrder(cartId, address!.addressId!);
    Provider.of<OrdersProvider>(context, listen: false)
        .sendConfirmOrderEmail(int.parse(order.id!));
    final isClean = await Provider.of<CartProvider>(context, listen: false)
        .clearCart(cartId);
    if (isClean) {
      Navigator.of(context).pushReplacementNamed(
        ConfirmOrderScreen.routeName,
        arguments: int.parse(order.id!),
      );
    } else {
      throw new Error();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text(
              'Payment',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          address == null
              ? Text('Error: no address was chosen.')
              : Column(
                  children: [
                    CheckboxListTile(
                      dense: true,
                      title: Text('Cash On Delivery'),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.green,
                      checkColor: Colors.black,
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    CheckboxListTile(
                      dense: true,
                      title: Text('Google Pay'),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.green,
                      checkColor: Colors.black,
                      value: _isChecked2,
                      onChanged: (value) {
                        setState(() {
                          _isChecked2 = value!;
                        });
                      },
                    ),
                  ],
                ),
          // GooglePayButton(
          //   paymentConfigurationAsset:
          //       'default_payment_profile_google_pay.json',
          //   paymentItems: _paymentItems,
          //   style: GooglePayButtonStyle.black,
          //   type: GooglePayButtonType.pay,
          //   margin: const EdgeInsets.only(top: 15.0),
          //   onPaymentResult: onGooglePayResult,
          //   loadingIndicator: const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // ),
          // ApplePayButton(
          //   paymentConfigurationAsset: 'default_payment_profile_apple_pay.json',
          //   paymentItems: _paymentItems,
          //   style: ApplePayButtonStyle.black,
          //   type: ApplePayButtonType.buy,
          //   margin: const EdgeInsets.only(top: 15.0),
          //   onPaymentResult: onApplePayResult,
          //   loadingIndicator: const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // ),

          //will submit the order and navigate to confirm_order_screen with orderId.
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            child: Text('Complete Order'),
            onPressed: () {
              submit();
            },
          ),
        ],
      ),
    );
  }
}
