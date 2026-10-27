import 'package:flutter/material.dart';

import '../config/datasets.dart';

/// Card del Dashboard que presenta un endpoint y navega a su listado.
class DatasetCard extends StatelessWidget {
  const DatasetCard({super.key, required this.dataset, required this.onTap});

  final Dataset dataset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: dataset.color.withValues(alpha: 0.15),
                child: Icon(dataset.icon, color: dataset.color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dataset.title,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(dataset.description, style: textTheme.bodySmall),
                    const SizedBox(height: 6),
                    Text(
                      'GET /${dataset.endpoint}',
                      style: textTheme.labelSmall?.copyWith(
                        color: dataset.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
