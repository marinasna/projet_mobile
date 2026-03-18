import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/l10n/app_localizations.dart';
import 'package:formation_flutter/res/app_colors.dart';
import 'package:formation_flutter/screens/homepage/homepage_empty.dart';
import 'package:formation_flutter/states/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.my_scans_screen_title),
        centerTitle: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SvgPicture.asset('res/svg/icons8-star.svg', width: 20),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              end: 15.0,
              start: 8.0,
            ), // Approximating the 15px right margin
            child: GestureDetector(
              onTap: () {
                // Sign out logic
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                authProvider.logout();
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
      body: HomePageEmpty(onScan: () => _onScanButtonPressed(context)),
    );
  }

  void _onScanButtonPressed(BuildContext context) {
    context.push('/product', extra: '5000159484695');
  }
}
