// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseMessagingService {
//   // Inicializar Firebase
//   static Future<void> initializeFirebase() async {
//     await Firebase.initializeApp();
//     // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     _configureFirebaseListeners();
//   }

//   // Manejar mensajes en segundo plano
//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await Firebase.initializeApp();
//     print('Handling a background message: ${message.messageId}');
//   }

//   // Solicitar permisos para iOS
//   static Future<void> requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }

//   // Obtener el token de FCM
//   static Future<String?> getToken() async {
//     try {
//       FirebaseMessaging messaging = FirebaseMessaging.instance;
//       String? token = await messaging.getToken();
//       print('FirebaseMessaging token: $token');
//       return token;
//     } on Exception catch (e) {
//       return '';
//     }
//   }

//   // Configurar listeners para notificaciones
//   static void _configureFirebaseListeners() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');

//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//       }

//       onMessage(message);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       onMessageOpenedApp(message);
//     });
//   }

//   // Métodos para ser implementados por el usuario
//   static void Function(RemoteMessage message) onMessage = (message) {};
//   static void Function(RemoteMessage message) onMessageOpenedApp = (message) {};
// }
