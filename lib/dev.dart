import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:musico/gen/assets.gen.dart';
import 'package:musico/start.dart';

///开发环境
Future<void> main() async {
  await dotenv.load(fileName: Assets.env.envDev);
  await start();
}
