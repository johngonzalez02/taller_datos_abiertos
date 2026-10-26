import 'package:flutter/material.dart';

/// Imagen de red con indicador de carga e icono de respaldo si falla o no hay URL.
class RemoteImage extends StatelessWidget {
  const RemoteImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius = 12,
  });

  final String url;
  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final placeholder = Container(
      width: width,
      height: height,
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(Icons.image_not_supported_outlined,
          color: scheme.onSurfaceVariant),
    );

    // Decodifica la imagen al tamano en que se muestra, para ahorrar memoria.
    final w = width;
    final logicalWidth =
        (w == null || !w.isFinite) ? MediaQuery.sizeOf(context).width : w;
    final cacheWidth =
        (logicalWidth * MediaQuery.devicePixelRatioOf(context)).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: url.isEmpty
          ? placeholder
          : Image.network(
              url,
              width: width,
              height: height,
              fit: BoxFit.cover,
              cacheWidth: cacheWidth,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return SizedBox(
                  width: width,
                  height: height,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => placeholder,
            ),
    );
  }
}
