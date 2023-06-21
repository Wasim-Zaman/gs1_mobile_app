import 'package:flutter/material.dart';
import 'package:hiring_task/providers/gtin.dart';
import 'package:hiring_task/view/screens/product-tracking/gtin_reporter_screen.dart';
import 'package:hiring_task/view/screens/gtin_tracking_screen.dart';
import 'package:hiring_task/view/screens/regulatory_affairs_screen.dart';
import 'package:hiring_task/view/screens/retail_information_screen.dart';
import 'package:hiring_task/view/screens/retailor_shopper_screen.dart';
import 'package:hiring_task/view/screens/safety_information_screen.dart';
import 'package:hiring_task/view/screens/verified-by-gs1/verify_by_gs1_screen.dart';
import 'package:hiring_task/widgets/custom_appbar_widget.dart';
import 'package:hiring_task/widgets/home_appbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../widgets/custom_elevated_button.dart';

class QRCodeScanningScreen extends StatefulWidget {
  const QRCodeScanningScreen({Key? key}) : super(key: key);
  static const routeName = '/scanning-screen';

  @override
  State<QRCodeScanningScreen> createState() => _QRCodeScanningScreenState();
}

class _QRCodeScanningScreenState extends State<QRCodeScanningScreen> {
  late String cameraText;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String gtinCode = '';
  bool isStartScanning = false;

  void _onQRViewCreated(QRViewController controller) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final icon = args['icon'];
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        gtinCode = scanData.code!;
        gtinCode = gtinCode.substring(0, 13);
        if (gtinCode.isNotEmpty &&
            gtinCode.length == 13 &&
            double.tryParse(gtinCode) != null) {
          controller.pauseCamera();
          // Navigate to the page based on the icon clicked
          /*
            * If icon is product-contents then navigate to RetailorShopperDetailScreen
            * If icon is retail-information then navigate to RetailInformationScreen 
            * if icon is regulatory-affairs then navigate to RegulatoryAffairsScreen
            * If icon is gtin-reporter then navigate to GtinReporterScreen 

          */

          if (icon == 'product-contents') {
            Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
            Navigator.of(context).pushNamed(
              RetailorShopperScreen.routeName,
              arguments: gtinCode,
            );
          }
          if (icon == 'retail-information') {
            Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
            Navigator.of(context).pushNamed(
              RetailInformationScreen.routeName,
              arguments: gtinCode,
            );
          }

          if (icon == "gtin-reporter") {
            Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
            Navigator.of(context).pushNamed(
              GtinReporterScreen.routeName,
              arguments: gtinCode,
            );
          }
          if (icon == "verified-by-gs1") {
            Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
            Navigator.of(context).pushNamed(
              VerifyByGS1Screen.routeName,
              arguments: gtinCode,
            );
          }

          if (icon == "regulatory-affairs") {
            Provider.of<GTIN>(context, listen: false).gtinNumber = gtinCode;
            Navigator.of(context).pushNamed(
              RegulatoryAffairsScreen.routeName,
              arguments: gtinCode,
            );
          }
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kindly scan appropriate QR Code')),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  startScanning() {
    setState(() {
      isStartScanning = true;
    });
  }

  stopScanning() {
    setState(() {
      isStartScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final icon = args['icon'];
    return Scaffold(
      appBar: HomeAppBarWidget(context),
      body: Column(
        children: [
          if (icon == 'product-contents')
            customAppBarWidget(
                title: 'Product Contents', icon: Icons.shopping_bag_outlined),
          if (icon == 'retail-information')
            customAppBarWidget(
                title: 'Retail Information',
                icon: Icons.shopping_bag_outlined,
                backgroundColor: Colors.green[800]),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Scan QR Code from your device's camera",
                  style: TextStyle(fontSize: 25),
                  softWrap: true,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    CustomElevatedButton(
                      caption: 'START',
                      onPressed: startScanning,
                      buttonWidth: MediaQuery.of(context).size.width * 0.2,
                    ),
                    CustomElevatedButton(
                      caption: 'RESET',
                      onPressed: stopScanning,
                      buttonWidth: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ],
                ),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  caption: 'PREVIOUS PAGE',
                  buttonWidth: MediaQuery.of(context).size.width * 0.43,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  child: isStartScanning
                      ? QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                        )
                      : const SizedBox.shrink(),
                ),
                const Text(
                  'Ready - Click START to scan',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 30),
                Text(gtinCode),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
