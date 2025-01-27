import 'flavors.dart';

import 'main.dart' as runner;

void main() async {
  FConfig.appFlavor = Flavor.prd;
  runner.main();
}
