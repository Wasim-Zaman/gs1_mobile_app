import 'package:flutter/material.dart';
import 'package:hiring_task/view-model/home/home_services.dart';
import 'package:hiring_task/utils/colors.dart';
import 'package:hiring_task/view/screens/log-in/gs1_member_login_screen.dart';
import 'package:hiring_task/widgets/custom_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home-screen';

  gs1Login() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: AppBar(backgroundColor: Colors.white)),
      backgroundColor: darkBlue,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: whiteColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // LogoWidget(),
                  Image.asset(
                    "assets/images/logo.png",
                    width: 150,
                    height: 150,
                  ),

                  // CustomElevatedButton(
                  //   caption: "Our Services",
                  //   bgColor: Colors.grey.shade400,
                  //   onPressed: gs1Login,
                  //   textColor: Colors.black,
                  //   buttonWidth: 150,
                  //   margin: const EdgeInsets.symmetric(horizontal: 20),
                  // ),
                ],
              ),
            ),
            const TitleWidget(),
            const DescriptionWidget(),
            Container(
              color: whiteColor,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomElevatedButton(
                    caption: "Get a Bar Code",
                    bgColor: darkBlue,
                    onPressed: () => HomeServices.getBarCode(context),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomElevatedButton(
                        caption: "GS1 Member Login",
                        bgColor: orangeColor,
                        onPressed: () => Navigator.of(context).pushNamed(
                          Gs1MemberLoginScreen.routeName,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (await canLaunch("http://www.gs1.org.sa")) {
                            await launch("http://www.gs1.org.sa");
                          } else {
                            throw 'Could not launch http://www.gs1.org.sa';
                          }
                        },
                        child: const Text(
                          "Visit Our Website",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 13,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: darkBlue,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButtonWidget(
                          caption: "Product\nContents",
                          onClick: () {
                            HomeServices.productContentsClick(context);
                          },
                          bgColor: pinkColor,
                          icon: Icons.shopping_bag_outlined,
                        ),
                        CustomButtonWidget(
                          onClick: () {
                            HomeServices.retailInformationClick(context);
                          },
                          bgColor: Colors.orange,
                          icon: Icons.badge_outlined,
                          caption: 'Retail\nInformation',
                        ),
                        CustomButtonWidget(
                          onClick: () {
                            HomeServices.regulatoryAffairsClick(context);
                          },
                          bgColor: Colors.purple,
                          icon: Icons.shield_moon_outlined,
                          caption: 'Government/\nRegulatory Affairs',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButtonWidget(
                          onClick: () {
                            // Navigate to new page
                            // Navigator.of(context)
                            //     .pushNamed(VerifyByGS1Screen.routeName);
                            HomeServices.verifiedByGS1Click(context);
                          },
                          bgColor: Colors.transparent,
                          icon: Icons.shutter_speed_sharp,
                          caption: "Verified by\nGS1",
                          imageIcon: "assets/images/gs1-logo.png",
                        ),
                        CustomButtonWidget(
                          onClick: () {
                            HomeServices.gtinReporterClick(context);
                          },
                          bgColor: Colors.blueGrey,
                          icon: Icons.insert_chart_outlined_outlined,
                          caption: 'GTIN\nReporter',
                        ),
                        CustomButtonWidget(
                          onClick: () {},
                          bgColor: Colors.cyan,
                          icon: Icons.emoji_food_beverage_outlined,
                          caption: 'Product\nTracking',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10,
      ),
      child: const Text(
        "Explore how new 2D barcodes combined with the power of GS1 Digital link unlock new possibilities for consumers, brands, retailers, governments, regulators and more.",
        softWrap: true,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: whiteColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Text(
        "One Barcode.\nInfinite Possibility.",
        style: TextStyle(
          color: darkBlue,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: whiteColor,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width * 0.5,
        height: MediaQuery.of(context).size.height * 0.16,
      ),
    );
  }
}

class CustomButtonWidget extends StatelessWidget {
  final IconData? icon;
  final Color? bgColor;
  final String? caption;
  final VoidCallback? onClick;
  final String? imageIcon;
  const CustomButtonWidget({
    super.key,
    this.icon,
    this.bgColor,
    this.caption,
    this.onClick,
    this.imageIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Column(
        children: [
          Container(
            color: bgColor ?? Colors.red,
            child: imageIcon == null
                ? Icon(
                    icon ?? Icons.card_travel_outlined,
                    size: 100,
                    color: Colors.white,
                  )
                : Image.asset(
                    imageIcon ?? '',
                    width: 105,
                    height: 105,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 5),
          Text(
            caption ?? 'Retailer\nShopper App',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
