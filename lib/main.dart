import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payment_gateway_integration/key_constants.dart';
import 'package:http/http.dart' as http;

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = public;
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeStripe(),
    );
  }
}


class HomeStripe extends StatefulWidget {
  const HomeStripe({super.key});

  @override
  State<HomeStripe> createState() => _HomeStripeState();
}

Map<String, dynamic>? payemntIntent;

class _HomeStripeState extends State<HomeStripe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('oi')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            makePayment();
          },
          child: Text('Payment Flutter'),
        ),
      ),
    );
  }
}

Future<void> makePayment() async {
  try {
    payemntIntent = await createPaymentIntent("1000", "BRL");

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        customFlow: true,
        merchantDisplayName: "Realize o pagamento: :)",
        paymentIntentClientSecret: payemntIntent!['client_secret'],
        googlePay: const PaymentSheetGooglePay(
          merchantCountryCode: 'BR',
          currencyCode: 'BRL',
          testEnv: true,
        ),
      ),
    );

    await diplayPaymentSheet();
  } catch (e) {
    print("12");
  }
}

createPaymentIntent(String payment, String currency) async {
  try {
    Map<String, dynamic> bodyResponse = {
      'currency': currency,
      'amount': payment,
      'payment_method_types[]': 'card',
    };

    var reponse = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      body: bodyResponse,
      headers: {
        'authorization': 'Bearer ${secret}',
        'Cotent-type': 'application/x-www-form-urlercoded',
      },
    );

    return jsonDecode(reponse.body);
  } catch (e) {
    log(e.toString());
  }
}

diplayPaymentSheet() async {
  try {
    await Stripe.instance.presentPaymentSheet().then((value) async {
      await Stripe.instance.confirmPaymentSheetPayment();
    });

    payemntIntent = null;
  } on StripeException catch (e) {
    log(e.toString());  
  } catch (e) {
    log(e.toString());
  }
}
