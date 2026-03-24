import 'package:flutter/material.dart';
import 'package:formation_flutter/model/rappel.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/res/app_theme_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class RappelPage extends StatelessWidget {
  const RappelPage({super.key, required this.rappel, this.productImageUrl});

  final Rappel rappel;
  final String? productImageUrl;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Rappel produit',
          style: context.theme.title2.copyWith(
            color: AppColors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (rappel.lienVersAffichettePdf != null)
            IconButton(
              onPressed: () => _openPdf(rappel.lienVersAffichettePdf!),
              // On utilise Transform pour s'assurer que la flèche pointe dans le bon sens (vers la droite)
              icon: Transform.scale(
                scaleX: -1,
                child: const Icon(AppIcons.share, color: AppColors.blue),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Image du produit pleine largeur comme la maquette
            _buildProductImage(),
            
            // Sections
            _buildSection(context, 'Dates de commercialisation', _formatDates()),
            _buildSection(context, 'Distributeurs', rappel.distributeurs),
            _buildSection(context, 'Zone géographique', rappel.zoneGeographiqueDeVente),
            _buildSection(context, 'Motif du rappel', rappel.motifRappel),
            _buildSection(context, 'Risques encourus', rappel.risquesEncourus),
            
            if (rappel.descriptionComplementaireRisque != null && 
                rappel.descriptionComplementaireRisque!.isNotEmpty)
              _buildSection(context, 'Description du risque', rappel.descriptionComplementaireRisque),
              
            if (rappel.conduitesATenirList.isNotEmpty)
              _buildSection(context, 'Conduite à tenir', rappel.conduitesATenirList.join('\n')),
              
            if (rappel.informationsComplementaires != null && 
                rappel.informationsComplementaires!.isNotEmpty)
              _buildSection(context, 'Informations complémentaires', _cleanText(rappel.informationsComplementaires)),
              
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    String? url;

    // Priorité 1: Image du produit (Open Food Facts) 
    if (productImageUrl != null && productImageUrl!.trim().isNotEmpty) {
      url = productImageUrl!.trim();
    } else {
      // Priorité 2: Image du rappel
      final rawUrls = rappel.liensVersLesImages ?? '';
      final candidates = rawUrls
          .split(RegExp(r'[|¤\n]'))
          .map((u) => u.trim())
          .where((u) => u.isNotEmpty && (u.startsWith('http://') || u.startsWith('https://')))
          .map((u) => u.startsWith('http://') ? u.replaceFirst('http://', 'https://') : u)
          .toList();
      if (candidates.isNotEmpty) url = candidates.first;
    }

    if (url == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            url,
            height: 220,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }


  Widget _buildSection(BuildContext context, String title, String? content) {
    if (content == null || content.trim().isEmpty) return const SizedBox.shrink();
    
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.grey1,
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            title,
            style: context.theme.title3.copyWith(
              color: AppColors.blue, 
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Text(
            content,
            style: const TextStyle(
              color: AppColors.grey3, 
              fontSize: 14.0, 
              height: 1.5
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  String? _formatDates() {
    final debut = rappel.dateDebutCommercialisation?.trim() ?? '';
    final fin = rappel.dateFinCommercialisation?.trim() ?? '';
    
    if (debut.isEmpty && fin.isEmpty) return null;
    
    if (debut.isNotEmpty && fin.isNotEmpty) {
      return 'Du ${_formatDate(debut)} au ${_formatDate(fin)}';
    }
    if (debut.isNotEmpty) return 'Depuis le ${_formatDate(debut)}';
    return "Jusqu'au ${_formatDate(fin)}";
  }

  String _formatDate(String raw) {
    final parts = raw.split('-');
    if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    return raw;
  }

  String? _cleanText(String? text) {
    if (text == null) return null;
    return text.replaceAll('¤', '\n').trim();
  }

  Future<void> _openPdf(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
