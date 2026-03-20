import 'package:flutter/material.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/homepage/widgets/product_card.dart';
import 'package:formation_flutter/api/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:go_router/go_router.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<RecordModel> _scans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final userId = pb.authStore.model?.id;
      if (userId == null) {
        setState(() {
          _scans = [];
          _isLoading = false;
        });
        return;
      }
      final records = await pb
          .collection('scans')
          .getList(
            filter: 'user_id = "$userId" && is_favorite = true',
            sort: '-created', // Les plus récents en premier
          );
      if (mounted) {
        setState(() {
          _scans = records.items;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur chargement favoris: $e');
      if (mounted) {
        setState(() {
          _scans = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onProductTap(BuildContext context, String barcode) async {
    await context.push('/product', extra: barcode);
    // Recharge les favoris au retour (au cas où l'utilisateur aurait retiré le favori)
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasFavorites = _scans.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: const Text(
          'Mes favoris',
          style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            )
          : (!hasFavorites
                ? const Center(
                    child: Text(
                      'Aucun produit favori pour le moment.',
                      style: TextStyle(color: AppColors.grey3, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _scans.length,
                    itemBuilder: (context, index) {
                      final scan = _scans[index];
                      final String barcode = scan.getStringValue('barcode', '');

                      return ProductCard(
                        scan: scan,
                        onTap: () => _onProductTap(context, barcode),
                      );
                    },
                  )),
    );
  }
}
