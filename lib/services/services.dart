import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static Function()? _cartTapCallback;

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidInit);

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == 'cart' && _cartTapCallback != null) {
          _cartTapCallback!();
        }
      },
    );
  }

  static void setCartNotificationTapCallback(Function() callback) {
    _cartTapCallback = callback;
  }

  static Future<void> showCartNotification(
    String productName, {
    int delaySeconds = 4,
  }) async {
    await Future.delayed(Duration(seconds: delaySeconds));

    const androidDetails = AndroidNotificationDetails(
      'cart_channel_id',
      'Cart Notifications',
      channelDescription: 'Notifications when items are added to cart',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      'Added to Cart',
      '$productName has been added to your cart.',
      notificationDetails,
      payload: 'cart',
    );
  }
}


