import 'dart:convert';

import 'package:hiring_task/models/login-models/profile/subscription_list_model.dart';
import 'package:hiring_task/utils/url.dart';
import 'package:http/http.dart' as http;

class SubscriptionListServices {
  static Future<SubscriptionListModel> getSubscriptionList(int userId) async {
    const String url = "${BaseUrl.gs1}/api/member/subscription/list";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          "user_id": userId,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Host': 'gs1.org.sa',
        },
      );
      print("user id: $userId");
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print('body: $body');
        return SubscriptionListModel.fromJson(body);
      } else {
        print('not fine');

        throw Exception('Unable to fetch member subscription');
      }
    } catch (e) {
      rethrow;
    }
  }
}
