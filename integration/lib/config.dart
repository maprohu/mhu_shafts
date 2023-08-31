part of 'main.dart';

@Has()
typedef SampleFw = Fw<SmpSampleMsg>;

@Compose()
abstract class SampleConfigObj implements HasSchemaLookupByName, HasSampleFw {}

Future<SampleConfigObj> createSampleConfigObj(AppCtx appCtx) async {
  return ComposedSampleConfigObj(
    schemaLookupByName: await mhuShaftsExampleLib.fileDescriptorSet
        .descriptorSchemaLookupByName(),
    sampleFw: fw(SmpSampleMsg()..freeze()),
  );
}

SampleConfigObj sampleConfigObj({
  @ext required ConfigCtx configCtx,
}) {
  return configCtx.configObj;
}
