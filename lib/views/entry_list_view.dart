import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/datasets.dart';
import '../models/catalog_entry.dart';
import '../routes/app_routes.dart';
import '../services/api_client.dart';
import '../widgets/remote_image.dart';
import '../widgets/state_views.dart';

/// Listado de un endpoint. Maneja los estados cargando / exito / error.
class EntryListView extends StatefulWidget {
  const EntryListView({super.key, required this.dataset});

  final Dataset dataset;

  @override
  State<EntryListView> createState() => _EntryListViewState();
}

class _EntryListViewState extends State<EntryListView> {
  late Future<List<CatalogEntry>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.dataset.load();
  }

  void _reload() {
    setState(() {
      _future = widget.dataset.load(forceRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dataset.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _reload,
          ),
        ],
      ),
      body: FutureBuilder<List<CatalogEntry>>(
        future: _future,
        builder: (context, snapshot) {
          // Estado: cargando
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView(message: 'Cargando datos...');
          }

          // Estado: error
          if (snapshot.hasError) {
            final error = snapshot.error;
            return ErrorView(
              message: error is ApiException
                  ? error.message
                  : 'Ocurrió un error inesperado.',
              onRetry: _reload,
            );
          }

          // Estado: exito
          final entries = snapshot.data ?? const <CatalogEntry>[];
          if (entries.isEmpty) {
            return const EmptyView(message: 'No hay registros para mostrar.');
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${entries.length} registros',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: entries.length,
                  itemBuilder: (context, index) => _EntryTile(
                    dataset: widget.dataset,
                    entry: entries[index],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.dataset, required this.entry});

  final Dataset dataset;
  final CatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: entry.imageUrl.isNotEmpty
            ? RemoteImage(url: entry.imageUrl, width: 56, height: 56)
            : CircleAvatar(
                radius: 28,
                backgroundColor: dataset.color.withValues(alpha: 0.15),
                child: Icon(dataset.icon, color: dataset.color),
              ),
        title: Text(
          entry.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: entry.subtitle.isEmpty
            ? null
            : Text(
                entry.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
        trailing: const Icon(Icons.chevron_right),
        // Navega al detalle enviando el dataset y el id como parametros de ruta.
        onTap: () => context.go(AppRoutes.detail(dataset.key, entry.id)),
      ),
    );
  }
}
