import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formation_flutter/res/app_icons.dart';
import 'package:formation_flutter/screens/product/product_fetcher.dart';
import 'package:formation_flutter/screens/product/states/empty/product_page_empty.dart';
import 'package:formation_flutter/screens/product/states/error/product_page_error.dart';
import 'package:formation_flutter/screens/product/states/success/product_page_body.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.barcode})
    : assert(barcode.length > 0);

  final String barcode;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations materialLocalizations =
        MaterialLocalizations.of(context);

    return ChangeNotifierProvider<ProductFetcher>(
      create: (_) => ProductFetcher(barcode: barcode),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Consumer<ProductFetcher>(
              builder: (BuildContext context, ProductFetcher notifier, _) {
                return switch (notifier.state) {
                  ProductFetcherLoading() => const ProductPageEmpty(),
                  ProductFetcherError(error: var err) => ProductPageError(
                    error: err,
                  ),
                  ProductFetcherSuccess() => ProductPageBody(),
                };
              },
            ),
            PositionedDirectional(
              top: 0.0,
              start: 0.0,
              child: _HeaderIcon(
                icon: AppIcons.close,
                tooltip: materialLocalizations.closeButtonTooltip,
                onPressed: Navigator.of(context).pop,
              ),
            ),
            PositionedDirectional(
              top: 0.0,
              end: 0.0,
              child: Consumer<ProductFetcher>(
                builder: (context, notifier, _) {
                  if (notifier.isFavorite) {
                    return _HeaderSvgIcon(
                      svgAsset: 'res/svg/icons8-star-full.svg',
                      tooltip: 'Retirer des favoris',
                      color: Colors.white,
                      onPressed: notifier.toggleFavorite,
                    );
                  } else {
                    return _HeaderSvgIcon(
                      svgAsset: 'res/svg/Shape.svg',
                      tooltip: 'Favori',
                      color: Colors.white,
                      onPressed: notifier.toggleFavorite,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.tooltip, this.onPressed})
    : assert(tooltip.length > 0);

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(8.0),
        child: Material(
          type: MaterialType.transparency,
          child: Tooltip(
            message: tooltip,
            child: InkWell(
              onTap: onPressed ?? () {},
              customBorder: const CircleBorder(),
              child: Ink(
                padding: const EdgeInsetsDirectional.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.0),
                ),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSvgIcon extends StatelessWidget {
  const _HeaderSvgIcon({
    required this.svgAsset, 
    required this.tooltip, 
    required this.color,
    this.onPressed
  }) : assert(tooltip.length > 0);

  final String svgAsset;
  final String tooltip;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(8.0),
        child: Material(
          type: MaterialType.transparency,
          child: Tooltip(
            message: tooltip,
            child: InkWell(
              onTap: onPressed ?? () {},
              customBorder: const CircleBorder(),
              child: Ink(
                padding: const EdgeInsetsDirectional.all(12.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.0),
                ),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    svgAsset, 
                    width: 24,  
                    height: 24,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

