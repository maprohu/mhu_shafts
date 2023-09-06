part of 'main.dart';

@Has()
typedef SampleWatch = WatchProto<SmpSampleMsg>;

@Compose()
abstract class SampleConfigObj
    implements HasSchemaLookupByName, HasSampleWatch {}

Future<SampleConfigObj> createSampleConfigObj(AppCtx appCtx) async {
  return ComposedSampleConfigObj(
    schemaLookupByName: await mhuShaftsExamplePbschema.pbschemaLookupByName(
      dependencies: [],
    ),
    sampleWatch: watchVar(
      SmpSampleMsg()..freeze(),
    ).watchWriteMessage(
      getDefault: SmpSampleMsg.getDefault,
    ),
  );
}

SampleConfigObj sampleConfigObj({
  @ext required ConfigCtx configCtx,
}) {
  return configCtx.configObj;
}
