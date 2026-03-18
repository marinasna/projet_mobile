import 'package:flutter/material.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/api/pocketbase_service.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:pocketbase/pocketbase.dart';

class ProductFetcher extends ChangeNotifier {
  ProductFetcher({required String barcode})
    : _barcode = barcode,
      _state = ProductFetcherLoading() {
    loadProduct();
  }

  final String _barcode;
  ProductFetcherState _state;
  bool isFavorite = false;
  String? _recordId;

  Future<void> loadProduct() async {
    _state = ProductFetcherLoading();
    notifyListeners();

    try {
      print('[ProductFetcher] fetching barcode: $_barcode');
      Product product = await OpenFoodFactsAPI().getProduct(_barcode);
      print('[ProductFetcher] success: ${product.name}');

      // PocketBase save
      try {
        final userId = pb.authStore.model?.id;
        if (userId != null) {
          // Vérification des doublons (même utilisateur, même code-barres)
          final existing = await pb.collection('scans').getList(
            filter: 'user_id = "$userId" && barcode = "${product.barcode}"',
            perPage: 1,
          );

          if (existing.items.isEmpty) {
            final bodyData = <String, dynamic>{
              'user_id': userId,
              'barcode': product.barcode,
              'name': product.name ?? 'Unknown',
              'nutriscore': product.nutriScore?.name ?? '',
              'is_favorite': false,
            };
            
            if (product.picture != null && product.picture!.isNotEmpty) {
              bodyData['image_url'] = product.picture;
            }
            
            final record = await pb.collection('scans').create(body: bodyData);
            _recordId = record.id;
            isFavorite = false;
            print('[PocketBase] saved scan record: ${record.id}');
          } else {
            final record = existing.items.first;
            _recordId = record.id;
            isFavorite = record.getBoolValue('is_favorite', false);
            print('[PocketBase] product already in history, skipping save. is_favorite: $isFavorite');
          }
        } else {
          print('[PocketBase] warning: user not authenticated, skipping save');
        }
      } catch (e) {
        if (e is ClientException) {
          print('[PocketBase] error (${e.statusCode}): ${e.response}');
        } else {
          print('[PocketBase] unknown error: $e');
        }
      }

      _state = ProductFetcherSuccess(product);
    } catch (error) {
      print('[ProductFetcher] error: $error');
      _state = ProductFetcherError(error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> toggleFavorite() async {
    if (_recordId == null) return;
    
    // Inverser l'état local immédiatement
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      await pb.collection('scans').update(_recordId!, body: {
        'is_favorite': isFavorite,
      });
      print('[PocketBase] favorite toggled to: $isFavorite for $_recordId');
    } catch (e) {
      print('[PocketBase] error updating favorite: $e');
      // Annuler en cas d'erreur
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }

  ProductFetcherState get state => _state;
}

sealed class ProductFetcherState {}

class ProductFetcherLoading extends ProductFetcherState {}

class ProductFetcherSuccess extends ProductFetcherState {
  ProductFetcherSuccess(this.product);

  final Product product;
}

class ProductFetcherError extends ProductFetcherState {
  ProductFetcherError(this.error);

  final dynamic error;
}
