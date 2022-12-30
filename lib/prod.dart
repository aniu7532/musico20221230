import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/start.dart';

Future<void> main() async {
  await dotenv.load(fileName: Assets.env.envProd);
  await start();
}
