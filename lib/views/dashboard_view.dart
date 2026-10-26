import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/datasets.dart';
import '../routes/app_routes.dart';
import '../widgets/dataset_card.dart';

/// Pantalla principal: una card por cada endpoint seleccionado.
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Datos Abiertos de Colombia')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _FlagBar(),
          const SizedBox(height: 16),
          Text(
            'Explora Colombia',
            style:
                textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Información pública obtenida de API Colombia. Elige una '
            'categoría para ver su listado y consultar el detalle de cada registro.',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          for (final dataset in datasets)
            DatasetCard(
              dataset: dataset,
              onTap: () => context.go(AppRoutes.list(dataset.key)),
            ),
        ],
      ),
    );
  }
}

/// Franja con los colores de la bandera de Colombia.
class _FlagBar extends StatelessWidget {
  const _FlagBar();

  @override
  Widget build(BuildContext context) {
    return const ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: SizedBox(
        height: 10,
        child: Row(
          children: [
            Expanded(flex: 2, child: ColoredBox(color: Color(0xFFFCD116))),
            Expanded(child: ColoredBox(color: Color(0xFF003893))),
            Expanded(child: ColoredBox(color: Color(0xFFCE1126))),
          ],
        ),
      ),
    );
  }
}
