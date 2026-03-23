import 'package:flutter/material.dart';
import 'package:formation_flutter/api/open_food_facts_api.dart';
import 'package:formation_flutter/api/pocketbase_service.dart';
import 'package:formation_flutter/api/rappel_api.dart';
import 'package:formation_flutter/model/product.dart';
import 'package:formation_flutter/model/rappel.dart';

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
  Rappel? rappel;

  Future<void> loadProduct() async {
    _state = ProductFetcherLoading();
    notifyListeners();

    try {
      print('[ProductFetcher] fetching barcode: $_barcode');
      
      // 1. Fetch Product from OpenFoodFacts (Optional)
      Product? product;
      try {
        product = await OpenFoodFactsAPI().getProduct(_barcode);
        if (product != null) {
          print('[ProductFetcher] product found: ${product.name}');
        }
      } catch (e) {
        print('[ProductFetcher] OpenFoodFacts error: $e');
      }

      // 2. Rappel produit check (Always runs)
      try {
        rappel = await RappelApi().fetchRappelFromPocketBase(_barcode);
        if (rappel != null) {
          print('[ProductFetcher] recall found in local DB: ${rappel!.numeroFiche}');
        }
      } catch (e) {
        print('[ProductFetcher] recall check error: $e');
        rappel = null;
      }

      // 3. Save to history (Unify Logic)
      try {
        final userId = pb.authStore.model?.id;
        if (userId != null) {
          print('[ProductFetcher] user authenticated, updating scan history...');
          
          final existing = await pb.collection('scans').getList(
            filter: 'user_id = "$userId" && barcode = "$_barcode"',
            perPage: 1,
          );

          if (existing.items.isEmpty) {
            String name = 'Produit Inconnu';
            String? imageUrl;
            String nutriscore = '';

            if (product != null) {
              name = product.name ?? 'Produit sans nom';
              imageUrl = product.picture;
              nutriscore = product.nutriScore?.name ?? '';
            } else if (rappel != null) {
              name = rappel!.libelle ?? 'Produit de Rappel';
              imageUrl = rappel!.firstImageUrl;
            }

            final bodyData = <String, dynamic>{
              'user_id': userId,
              'barcode': _barcode,
              'name': name,
              'nutriscore': nutriscore,
              'is_favorite': false,
              if (imageUrl != null && imageUrl.isNotEmpty) 'image_url': imageUrl,
            };

            final record = await pb.collection('scans').create(body: bodyData);
            _recordId = record.id;
            isFavorite = false;
            print('[ProductFetcher] scan created: ${record.id} ($name)');
          } else {
            final record = existing.items.first;
            _recordId = record.id;
            isFavorite = record.getBoolValue('is_favorite', false);
            print('[ProductFetcher] found existing scan: $_recordId');
          }
        } else {
          print('[ProductFetcher] WARNING: user NOT authenticated, scan NOT saved to history');
        }
      } catch (e) {
        print('[ProductFetcher] ERROR saving scan history: $e');
      }

      // 4. Final Success State
      if (product == null && rappel == null) {
        _state = ProductFetcherSuccess(
          Product(barcode: _barcode, name: 'Produit Inconnu'),
        );
      } else {
        _state = ProductFetcherSuccess(
          product ?? Product(barcode: _barcode, name: 'Produit de Rappel'),
        );
      }
    } catch (error) {
      print('[ProductFetcher] general error: $error');
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
