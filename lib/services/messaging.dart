import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

class Messaging {
  static final Client client = Client();

  static const String serverKey =
      'AAAA9jgmMCQ:APA91bG-dCIe7FciiRnwwm-aoc_ma-KBf44H62T18WHBgxnEMI0TKsrWMFqasD1zc6o4fOkgn4kNjSpP4bYTsU8AFX_fyZngpibPfzD7hpVPpo5ceMAjihTA1xkBFyDc9-K8ItSnWrqo';

  static Future<Response> sendToAll({@required String title, @required String body,})
  => sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic({@required String title, @required String body, @required String topic})
  => sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        'https://fcm.googleapis.com/fcm/send',
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}