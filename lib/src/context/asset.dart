import 'package:google_fonts/google_fonts.dart';
import 'package:mhu_dart_annotation/mhu_dart_annotation.dart';

part 'asset.g.has.dart';

part 'asset.g.dart';



@Has()
class AssetObj {
  final robotoMonoFont = GoogleFonts.robotoMono();
  final robotoSlabFont = GoogleFonts.robotoSlab();
}

@Compose()
abstract class AssetCtx implements HasAssetObj {}

Future<AssetCtx> createAssetCtx() async {
  final assetObj = AssetObj();
  await GoogleFonts.pendingFonts();

  return ComposedAssetCtx(
    assetObj: assetObj,
  );
}
