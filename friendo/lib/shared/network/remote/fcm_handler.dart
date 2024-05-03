import 'package:dio/dio.dart';

class FCMHandler {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/fcm/', // server address
        receiveDataWhenStatusError: true,
        headers: {
          'Authorization': 'key=AAAAhU0Uc4s:APA91bH47FUsH68eCj98ljyL7gOTm11MMCReQFThjC2LIuzBuVc8q4RQbFUaDkay1npxY1yVthLlFnxLu7WU2uRuQ5jz5no5-I6-b19WOiFnEbjZ77QFDUqpmN_ez825Ljz8cM1_Buaw',
        }
      ),
    );
  }

  static Future<Response> getData({
    required String method,
    Map<String, dynamic>? queries,
  }) async {
    return await dio.get(
      method, // address inside the server
      queryParameters: queries, // queries I will do there
    );
  }

  static Future<Response> sendData({
    String method = 'send',
    Map<String, dynamic>? queries,
    Map<String, dynamic>? data,
  }) async {
    return await dio.post(
      method,
      queryParameters: queries,
      data: data,
    );
  }
}
