import 'dart:async';
import 'package:mangayomi/eval/bridge/m_source.dart';
import 'package:mangayomi/eval/model/m_pages.dart';
import 'package:mangayomi/eval/compiler/compiler.dart';
import 'package:mangayomi/eval/model/m_provider.dart';
import 'package:mangayomi/models/source.dart';
import 'package:mangayomi/eval/runtime/runtime.dart';
import 'package:mangayomi/sources/source_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'get_latest_updates.g.dart';

@riverpod
Future<MPages?> getLatestUpdates(
  GetLatestUpdatesRef ref, {
  required Source source,
  required int page,
}) async {
  MPages? latestUpdatesManga;

  try {
    final bytecode =
        compilerEval(useTestSourceCode ? testSourceCode : source.sourceCode!);

    final runtime = runtimeEval(bytecode);

    var res = await runtime.executeLib('package:mangayomi/main.dart', 'main',
        [$MSource.wrap(source.toMSource())]);
    latestUpdatesManga = await (res as MProvider).getLatestUpdates(page);
  } catch (e) {
    throw Exception(e);
  }

  return latestUpdatesManga;
}
