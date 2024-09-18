import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PayMongoService {
  final Dio _dio = Dio();
  String apiKey = dotenv.env['PAYMONGO_API_KEY'] ?? '';

  PayMongoService() {
    _dio.options = BaseOptions(
      baseUrl: 'https://api.paymongo.com/v1',
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$apiKey:'))}',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Map<String, dynamic>> createPaymenLink({
    required int amount,
    required String description,
    required String remarks,
  }) async {
    try {
      final response = await _dio.post(
        '/links',
        data: jsonEncode({
          'data': {
            'attributes': {
              'amount': amount,
              'description': description,
              'remarks': remarks,
            },
          },
        }),
      );
      return response.data;
    } on DioException catch (e) {
      // Handle Dio error here
      print('DioError: ${e.message}');
      throw Exception('Failed to create payment link');
    }
  }

  Future<Map<String, dynamic>> retrievePaymentStatus({
    required String paymentID,
  }) async {
    try {
      final response = await _dio.get('/links/$paymentID');
      print("Sulod ni sa retrievePayment response: $response");
      return response.data;
    } on DioException catch (e) {
      // Handle Dio error here
      print('DioError: ${e.message}');
      throw Exception('Failed to retrieve payment link');
    }
  }
}
