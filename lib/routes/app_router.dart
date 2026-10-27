import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/datasets.dart';
import '../views/dashboard_view.dart';
import '../views/entry_detail_view.dart';
import '../views/entry_list_view.dart';
import '../widgets/state_views.dart';
import 'app_routes.dart';

Widget _notFound(String message) {
  return Scaffold(
    appBar: AppBar(title: const Text('No encontrado')),
    body: EmptyView(message: message),
  );
}

/// Configuracion de navegacion con go_router.
///
/// Rutas anidadas, asi el boton "atras" regresa Detalle -> Listado -> Dashboard:
///   /                       name: dashboard
///   /lista/:dataset         name: lista     (parametro: dataset)
///   /lista/:dataset/:id     name: detalle   (parametros: dataset, id)
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.dashboard,
  errorBuilder: (context, state) =>
      _notFound('La página "${state.uri}" no existe.'),
  routes: [
    GoRoute(
      path: '/',
      name: 'dashboard',
      builder: (context, state) => const DashboardView(),
      routes: [
        GoRoute(
          path: 'lista/:dataset',
          name: 'lista',
          builder: (context, state) {
            final dataset = datasetByKey(state.pathParameters['dataset'] ?? '');
            if (dataset == null) {
              return _notFound('La categoría solicitada no existe.');
            }
            return EntryListView(dataset: dataset);
          },
          routes: [
            GoRoute(
              path: ':id',
              name: 'detalle',
              builder: (context, state) {
                final dataset =
                    datasetByKey(state.pathParameters['dataset'] ?? '');
                final id = int.tryParse(state.pathParameters['id'] ?? '');
                if (dataset == null || id == null) {
                  return _notFound('El registro solicitado no existe.');
                }
                return EntryDetailView(dataset: dataset, entryId: id);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
