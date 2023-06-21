import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hiring_task/models/login-models/dashboard_model.dart';
import 'package:hiring_task/models/login-models/profile/subscription_model.dart';
import 'package:hiring_task/view-model/login/after-login/subscription_services.dart';
import 'package:hiring_task/view/screens/log-in/after-login/renew_membership_screen.dart';
import 'package:hiring_task/view/screens/log-in/widgets/text_widgets/table_header_text.dart';
import 'package:hiring_task/widgets/custom_drawer_widget.dart';
import 'package:hiring_task/widgets/images/image_widget.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SubscribeProductsScreen extends StatefulWidget {
  const SubscribeProductsScreen({super.key});
  static const String routeName = 'subscribe-products-screen';

  @override
  State<SubscribeProductsScreen> createState() =>
      _SubscribeProductsScreenState();
}

class _SubscribeProductsScreenState extends State<SubscribeProductsScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // scaffold key
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _pageController.dispose();
    scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final response = args['response'] as DashboardModel;
    final userId = args['userId'];
    return WillPopScope(
      onWillPop: () async {
        scaffoldKey.currentState?.openDrawer();
        return false;
      },
      child: WillPopScope(
        onWillPop: () async {
          scaffoldKey.currentState?.openDrawer();
          return false;
        },
        child: Scaffold(
          key: scaffoldKey,
          drawer: CustomDrawerWidget(
            userId: response.memberData?.user?.id ?? userId,
            response: response,
          ),
          bottomNavigationBar: BottomNavyBar(
            showElevation: true,
            selectedIndex: _currentIndex,
            onItemSelected: (index) {
              setState(() => _currentIndex = index);
              _pageController.jumpToPage(index);
            },
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                title: const Text('GTIN Subscription'),
                icon: const Icon(Icons.home),
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).primaryColorLight,
              ),
              BottomNavyBarItem(
                title: const Text('Other Subscription'),
                icon: const Icon(Icons.apps),
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Theme.of(context).primaryColorLight,
              ),
            ],
          ),
          appBar: AppBar(
            title: const Text("Subscribe Products"),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
          ),
          body: FutureBuilder(
            future: SubscriptionServices.getSubscription(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.hexagonDots(
                    color: Theme.of(context).primaryColor,
                    size: 70,
                  ),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 60,
                      ),
                      Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 60,
                      ),
                      Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                );
              }
              final response = snapshot.data;

              return PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                dragStartBehavior: DragStartBehavior.start,
                children: <Widget>[
                  _currentIndex == 0
                      ? GtinSubscription(
                          response: response!,
                          userId: userId.toString(),
                        )
                      : OtherSubscription(response: response!),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class OtherSubscription extends StatefulWidget {
  const OtherSubscription({super.key, required this.response});
  final SubscritionModel response;

  @override
  State<OtherSubscription> createState() => _OtherSubscriptionState();
}

class _OtherSubscriptionState extends State<OtherSubscription> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // ImageWidget(
                //   context,
                //   imageUrl: 'assets/images/subscribed_products_image.png',
                //   fit: BoxFit.contain,
                // ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        dataRowColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08);
                            }
                            return Colors.white;
                          },
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        dividerThickness: 2,
                        border: const TableBorder(
                          horizontalInside: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          verticalInside: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        columns: const [
                          DataColumn(
                            label: TableHeaderText(text: 'Product'),
                          ),
                          DataColumn(
                            label: TableHeaderText(text: 'Registration Date'),
                          ),
                          DataColumn(
                            label: TableHeaderText(text: 'Expiry'),
                          ),
                        ],
                        rows: widget.response.otherSubscription!
                            .map(
                              (e) => DataRow(
                                cells: [
                                  DataCell(Text(widget
                                      .response.gtinSubscription!.gtin
                                      .toString())),
                                  DataCell(Text(widget
                                      .response.gtinSubscription!.registerDate
                                      .toString())),
                                  DataCell(Text(widget
                                      .response.gtinSubscription!.expiry
                                      .toString())),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GtinSubscription extends StatefulWidget {
  const GtinSubscription(
      {super.key, required this.response, required this.userId});
  final SubscritionModel response;
  final String userId;

  @override
  State<GtinSubscription> createState() => _GtinSubscriptionState();
}

class _GtinSubscriptionState extends State<GtinSubscription> {
  @override
  Widget build(BuildContext context) {
    final gtin = widget.response.gtinSubscription;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Your Subscription Will Expire On:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  widget.response.gtinSubscription!.expiry.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Subscription Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        dataRowColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.selected)) {
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.08);
                            }
                            return Colors.white;
                          },
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        dividerThickness: 2,
                        border: const TableBorder(
                          horizontalInside: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                          verticalInside: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        columns: const [
                          DataColumn(
                            label: TableHeaderText(text: 'Product'),
                          ),
                          DataColumn(
                            label: TableHeaderText(text: 'Registration Date'),
                          ),
                          DataColumn(
                            label: TableHeaderText(text: 'Expiry'),
                          ),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text(widget
                                  .response.gtinSubscription!.gtin
                                  .toString())),
                              DataCell(Text(widget
                                  .response.gtinSubscription!.registerDate
                                  .toString())),
                              DataCell(Text(widget
                                  .response.gtinSubscription!.expiry
                                  .toString())),
                            ],
                          ),
                        ].toList(),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(),
                //   ),
                //   child: SingleChildScrollView(
                //     scrollDirection: Axis.horizontal,
                //     child: SingleChildScrollView(
                //       scrollDirection: Axis.vertical,
                //       child: DataTable(
                //         dataRowColor: MaterialStateProperty.resolveWith<Color>(
                //           (Set<MaterialState> states) {
                //             if (states.contains(MaterialState.selected)) {
                //               return Theme.of(context)
                //                   .colorScheme
                //                   .primary
                //                   .withOpacity(0.08);
                //             }
                //             return Colors.white;
                //           },
                //         ),
                //         decoration: BoxDecoration(
                //           color: Theme.of(context).primaryColor,
                //           border: Border.all(color: Colors.grey, width: 1),
                //         ),
                //         dividerThickness: 2,
                //         border: const TableBorder(
                //           horizontalInside: BorderSide(
                //             color: Colors.grey,
                //             width: 2,
                //           ),
                //           verticalInside: BorderSide(
                //             color: Colors.grey,
                //             width: 2,
                //           ),
                //         ),
                //         columns: const [
                //           DataColumn(
                //             label: TableHeaderText(text: 'Product'),
                //           ),
                //           DataColumn(
                //             label: TableHeaderText(text: 'Registration Date'),
                //           ),
                //           DataColumn(
                //             label: TableHeaderText(text: 'Expiry'),
                //           ),
                //         ],
                //         rows: widget.response.otherSubscription!
                //             .map(
                //               (e) => DataRow(
                //                 cells: [
                //                   DataCell(Text(widget
                //                       .response.gtinSubscription!.gtin
                //                       .toString())),
                //                   DataCell(Text(widget
                //                       .response.gtinSubscription!.registerDate
                //                       .toString())),
                //                   DataCell(Text(widget
                //                       .response.gtinSubscription!.expiry
                //                       .toString())),
                //                 ],
                //               ),
                //             )
                //             .toList(),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 40),
                // const Text(
                //   "Actions",
                //   style: TextStyle(
                //     fontSize: 30,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        RenewMembershipScreen.routeName,
                        arguments: {
                          'response': widget.response,
                          'user_id': widget.userId,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).primaryColorDark,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text("Renew Membership"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
