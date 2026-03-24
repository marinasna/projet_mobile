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
import 'package:formation_flutter/screens/homepage/widgets/product_card.dart';

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
      final records = await pb
          .collection('scans')
          .getList(
            filter: 'user_id = "$userId"',
            sort: '-created',
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
      await context.push('/product', extra: barcode);
    }
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
                    color: AppColors.blueLight.withValues(
                      alpha: 0.2,
                    ), // Légèrement bleuté
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    'res/svg/icons8-barcode.svg',
                    width: 24,
                    colorFilter: const ColorFilter.mode(
                      AppColors.blue,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () async {
                await context.push('/favorites');
                _loadScans(); // Recharge au retour
              },
              child: const Icon(Icons.star_rounded, color: AppColors.blue),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 15.0, start: 8.0),
            child: GestureDetector(
              onTap: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
              child: SvgPicture.asset(
                'res/svg/Path2.svg',
                width: 23,
                height: 23,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.blue),
            )
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
        final String barcode = scan.getStringValue('barcode', '');

        return ProductCard(
          scan: scan,
          onTap: () => _onProductTap(context, barcode),
        );
      },
    );
  }
}
