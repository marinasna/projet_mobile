import 'package:formation_flutter/api/pocketbase_service.dart';
import 'package:formation_flutter/model/rappel.dart';
import 'package:pocketbase/pocketbase.dart';

class RappelApi {
  /// Cherche un rappel pour le GTIN donné directement dans PocketBase.
  /// Les données sont synchronisées régulièrement par le serveur (Cron job).
  Future<Rappel?> fetchRappelFromPocketBase(String gtin) async {
    try {
      final cleanGtin = gtin.trim();
      print('[RappelApi] searching PocketBase for gtin: $cleanGtin');
      
      final result = await pb.collection('rappels').getFirstListItem(
        'gtin = "$cleanGtin"',
      );

      final rappel = Rappel.fromRecord(result);
      print('[RappelApi] recall found in local DB: ${rappel.numeroFiche}');
      return rappel;
    } catch (e) {
      if (e is ClientException && e.statusCode == 404) {
        print('[RappelApi] no recall found in PocketBase for gtin: $gtin');
      } else {
        print('[RappelApi] error fetching from PocketBase: $e');
      }
      return null;
    }
  }
}
