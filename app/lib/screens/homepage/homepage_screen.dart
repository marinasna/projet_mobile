import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/states/auth_provider.dart';
import 'package:formation_flutter/api/pocketbase_service.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecordModel> _scans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScans();
  }

  Future<void> _loadScans() async {
    try {
      final userId = pb.authStore.model?.id;
      if (userId == null) {
        setState(() {
          _scans = [];
          _isLoading = false;
        });
        return;
      }
      final records = await pb.collection('scans').getList(
        filter: 'user_id = "$userId"',
        sort: '-created', // Les plus récents en premier
      );
      if (mounted) {
        setState(() {
          _scans = records.items;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur chargement historique: $e');
      if (mounted) {
        setState(() {
          _scans = [];
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onScanButtonPressed(BuildContext context) async {
    final barcode = await context.push<String>('/scan');
    if (barcode != null) {
      // Une fois le scan terminé, on ouvre la page produit
      await context.push('/product', extra: barcode);
    }
    // Recharge l'historique de façon garantie lorsque l'utilisateur revient sur l'accueil
    _loadScans();
  }

  Future<void> _onProductTap(BuildContext context, String barcode) async {
    await context.push('/product', extra: barcode);
    _loadScans();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final bool hasHistory = _scans.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        title: Text(localizations.my_scans_screen_title),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: <Widget>[
          if (hasHistory)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () => _onScanButtonPressed(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.blueLight.withValues(alpha: 0.2), // Légèrement bleuté
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    'res/svg/icons8-barcode.svg', 
                    width: 24, 
                    colorFilter: const ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.star_rounded, color: AppColors.blue), // Backup icon as requested before
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 15.0, start: 8.0),
            child: GestureDetector(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
              child: SvgPicture.asset('res/svg/Path2.svg', width: 23, height: 23),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.blue))
          : (!hasHistory
              ? HomePageEmpty(onScan: () => _onScanButtonPressed(context))
              : _buildHistoryList()),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _scans.length,
      itemBuilder: (context, index) {
        final scan = _scans[index];
        final String name = scan.getStringValue('name', 'Inconnu');
        final String barcode = scan.getStringValue('barcode', '');
        final String imageUrl = scan.getStringValue('image_url', '');
        final String nutriscore = scan.getStringValue('nutriscore', 'unknown');

        Color dotColor = Colors.grey;
        switch (nutriscore.toLowerCase()) {
          case 'a': dotColor = Colors.green; break;
          case 'b': dotColor = Colors.lightGreen; break;
          case 'c': dotColor = Colors.yellow; break;
          case 'd': dotColor = Colors.orange; break;
          case 'e': dotColor = Colors.red; break;
        }

        return GestureDetector(
          onTap: () => _onProductTap(context, barcode),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          color: AppColors.grey1,
                          child: const Icon(Icons.fastfood, color: Colors.grey),
                        ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: AppColors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          barcode,
                          style: const TextStyle(
                            color: AppColors.grey2,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (nutriscore != 'unknown' && nutriscore.isNotEmpty)
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: dotColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Nutriscore : ${nutriscore.toUpperCase()}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.grey3,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

