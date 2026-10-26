import 'package:flutter/material.dart';

import '../config/datasets.dart';
import '../models/catalog_entry.dart';
import '../services/api_client.dart';
import '../widgets/remote_image.dart';
import '../widgets/state_views.dart';

/// Detalle de un registro. Recibe por la ruta el dataset y el id; busca el
/// registro en los datos (ya en cache si se vino desde el listado).
class EntryDetailView extends StatefulWidget {
  const EntryDetailView({
    super.key,
    required this.dataset,
    required this.entryId,
  });

  final Dataset dataset;
  final int entryId;

  @override
  State<EntryDetailView> createState() => _EntryDetailViewState();
}

class _EntryDetailViewState extends State<EntryDetailView> {
  late Future<CatalogEntry?> _future;

  @override
  void initState() {
    super.initState();
    _future = _find();
  }

  Future<CatalogEntry?> _find() async {
    final entries = await widget.dataset.load();
    for (final entry in entries) {
      if (entry.id == widget.entryId) return entry;
    }
    return null;
  }

  void _retry() {
    setState(() {
      _future = _find();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.dataset.title)),
      body: FutureBuilder<CatalogEntry?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView(message: 'Cargando detalle...');
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            return ErrorView(
              message: error is ApiException
                  ? error.message
                  : 'Ocurrió un error inesperado.',
              onRetry: _retry,
            );
          }
          final entry = snapshot.data;
          if (entry == null) {
            return const EmptyView(message: 'No se encontró el registro.');
          }
          return _DetailBody(entry: entry);
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.entry});

  final CatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final rows = <Widget>[];
    entry.details.forEach((label, value) {
      if (rows.isNotEmpty) rows.add(const Divider(height: 1));
      rows.add(_DetailRow(label: label, value: value));
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (entry.imageUrl.isNotEmpty)
            RemoteImage(
              url: entry.imageUrl,
              width: double.infinity,
              height: 240,
              borderRadius: 0,
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (rows.isNotEmpty)
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(children: rows),
                    ),
                  ),
                if (entry.description.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Descripción',
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(entry.description, style: textTheme.bodyMedium),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
