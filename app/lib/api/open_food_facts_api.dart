import 'dart:async';
import 'package:dio/dio.dart';
import 'package:formation_flutter/model/product.dart';

class OpenFoodFactsAPI {
  static const String _baseUrl = 'https://api.formation-flutter.fr/v2';

  static final OpenFoodFactsAPI _instance = OpenFoodFactsAPI._internal();

  factory OpenFoodFactsAPI() => _instance;

  final Dio _dio;
  
  final Map<String, Future<Product?>> _activeRequests = {};
  Future<void> _queue = Future.value();

  OpenFoodFactsAPI._internal() : _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  Future<Product?> getProduct(String barcode) {
    if (_activeRequests.containsKey(barcode)) {
      return _activeRequests[barcode]!;
    }

    final completer = Completer<Product?>();
    _activeRequests[barcode] = completer.future;

    _queue = _queue.then((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      try {
        final response = await _dio.get(
          '/getProduct',
          queryParameters: {'barcode': barcode},
        );

        final Map<String, dynamic> data = response.data['response'];
        final product = Product.fromJson(data);
        completer.complete(product);
      } on DioException catch (e) {
        if (e.response?.statusCode == 404) {
          completer.complete(null);
        } else {
          _activeRequests.remove(barcode);
          completer.completeError(e);
        }
      } catch (e) {
        _activeRequests.remove(barcode);
        completer.completeError(e);
      }
    }).catchError((_) {});

    return completer.future;
  }
}
