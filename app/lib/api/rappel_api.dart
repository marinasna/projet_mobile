import 'package:dio/dio.dart';
import 'package:formation_flutter/api/pocketbase_service.dart';
import 'package:formation_flutter/model/rappel.dart';
import 'package:pocketbase/pocketbase.dart';

class RappelApi {
  static const String _baseUrl =
      'https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/rappelconso-v2-gtin-trie/records';

  /// Cherche un rappel pour le GTIN donné, le sauvegarde dans PocketBase,
  /// et retourne le Rappel si trouvé, null sinon.
  Future<Rappel?> fetchAndSaveRappel(String gtin) async {
    try {
      final rappel = await _fetchRappel(gtin);
      if (rappel == null) return null;

      await _saveRappelToPocketBase(rappel);
      return rappel;
    } catch (e) {
      print('[RappelApi] error: $e');
      return null;
    }
  }

  Future<Rappel?> _fetchRappel(String gtin) async {
    final dio = Dio();
    final url =
        '$_baseUrl?where=gtin%3D$gtin&limit=1&order_by=date_publication%20DESC';

    print('[RappelApi] fetching rappel for gtin: $gtin');
    final response = await dio.get<Map<String, dynamic>>(url);

    if (response.statusCode != 200 || response.data == null) {
      print('[RappelApi] HTTP error: ${response.statusCode}');
      return null;
    }

    final data = response.data!;
    final int totalCount = data['total_count'] as int? ?? 0;

    if (totalCount == 0) {
      print('[RappelApi] no recall found for gtin: $gtin');
      return null;
    }

    final results = data['results'] as List<dynamic>;
    if (results.isEmpty) return null;

    final rappel = Rappel.fromJson(results.first as Map<String, dynamic>);
    print('[RappelApi] recall found: ${rappel.numeroFiche} — ${rappel.libelle}');
    return rappel;
  }

  Future<void> _saveRappelToPocketBase(Rappel rappel) async {
    try {
      // Vérifier si ce rappel existe déjà (même numéro de fiche)
      print('[RappelApi] checking PocketBase for existing rappel...');
      final existing = await pb.collection('rappels').getList(
        filter: 'numero_fiche = "${rappel.numeroFiche}"',
        perPage: 1,
      );

      if (existing.items.isNotEmpty) {
        print(
          '[RappelApi] PocketBase: rappel ${rappel.numeroFiche} already stored, skipping.',
        );
        return;
      }

      print('[RappelApi] saving to PocketBase...');
      final body = <String, dynamic>{
        'gtin': rappel.gtin,
        'numero_fiche': rappel.numeroFiche,
      };

      void addIfNotNull(String key, String? value) {
        if (value != null && value.isNotEmpty) body[key] = value;
      }

      addIfNotNull('libelle', rappel.libelle);
      addIfNotNull('marque_produit', rappel.marqueProduit);
      addIfNotNull('modeles_ou_references', rappel.modelesOuReferences);
      addIfNotNull('categorie_produit', rappel.categorieProduit);
      addIfNotNull('sous_categorie_produit', rappel.sousCategoriseProduit);
      addIfNotNull('nature_juridique_rappel', rappel.natureJuridiqueRappel);
      addIfNotNull(
        'date_debut_commercialisation',
        rappel.dateDebutCommercialisation,
      );
      addIfNotNull(
        'date_fin_commercialisation',
        rappel.dateFinCommercialisation,
      );
      addIfNotNull('distributeurs', rappel.distributeurs);
      addIfNotNull('zone_geographique_de_vente', rappel.zoneGeographiqueDeVente);
      addIfNotNull('motif_rappel', rappel.motifRappel);
      addIfNotNull('risques_encourus', rappel.risquesEncourus);
      addIfNotNull(
        'description_complementaire_risque',
        rappel.descriptionComplementaireRisque,
      );
      addIfNotNull('conduites_a_tenir', rappel.conduitesATenir);
      addIfNotNull(
        'informations_complementaires',
        rappel.informationsComplementaires,
      );
      addIfNotNull('liens_vers_les_images', rappel.liensVersLesImages);
      addIfNotNull('lien_vers_affichette_pdf', rappel.lienVersAffichettePdf);
      addIfNotNull('lien_vers_la_fiche_rappel', rappel.lienVersLaFicheRappel);
      addIfNotNull('date_publication', rappel.datePublication);
      addIfNotNull('date_fin_procedure', rappel.dateFinProcedure);
      addIfNotNull('numero_contact', rappel.numeroContact);
      addIfNotNull('modalites_compensation', rappel.modalitesCompensation);
      addIfNotNull('temperature_conservation', rappel.temperatureConservation);
      addIfNotNull('marque_salubrite', rappel.marqueSalubrite);
      addIfNotNull('identification_produits', rappel.identificationProduits);
      addIfNotNull('conditionnements', rappel.conditionnements);

      await pb.collection('rappels').create(body: body);
      print(
        '[RappelApi] PocketBase: saved rappel ${rappel.numeroFiche} for gtin ${rappel.gtin}',
      );
    } catch (e) {
      if (e is ClientException) {
        print('[RappelApi] PocketBase error (${e.statusCode}): ${e.response}');
      } else {
        print('[RappelApi] PocketBase unknown error: $e');
      }
    }
  }
}
