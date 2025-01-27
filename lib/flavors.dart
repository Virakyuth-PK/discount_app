enum Flavor {
  prd,
  dev,
}

class FConfig {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.prd:
        return 'Discount% Calculator';
      case Flavor.dev:
        return 'Discount% DEV Calculator';
      default:
        return 'title';
    }
  }

}
