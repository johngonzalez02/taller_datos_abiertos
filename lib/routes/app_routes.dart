/// Rutas de la app. Se usan desde las vistas para navegar con go_router.
///
///   /                               -> Dashboard
///   /lista/:dataset                 -> Listado   (ej. /lista/departamentos)
///   /lista/:dataset/:id             -> Detalle   (ej. /lista/departamentos/5)
class AppRoutes {
  AppRoutes._();

  static const String dashboard = '/';

  static String list(String datasetKey) => '/lista/$datasetKey';

  static String detail(String datasetKey, int id) => '/lista/$datasetKey/$id';
}
