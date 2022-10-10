import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../bin/source/gh_api.dart';
import '../bin/source/saving.dart';

void main() {
  Directory? td = null;
  setUp(() {
    assert(td == null);
    td = Directory.systemTemp.createTempSync();
  });

  tearDown(() {
    try {
      td!.deleteSync(recursive: true);
      td = null;
    } on OSError catch (_) {
      // windows
    }
  });

  // TODO prepare specific files in repos for testing

  test('download file to file', () {
    final target = File(path.join(td!.path, "a.md"));

    expect(td!.listSync().length, 0);
    expect(target.existsSync(), false);

    updateLocal(
        argToEndpoint(
            "https://github.com/rtmigo/ghfile_test_data/blob/dev/dir-abc/a.md"),
        target.path);

    expect(td!.listSync().length, 1);
    expect(target.existsSync(), true);
  });

  test('download file to dir', () {
    final fn = path.join(td!.path, "a.md");

    expect(td!.listSync().length, 0);
    expect(File(fn).existsSync(), false);

    updateLocal(
        argToEndpoint(
            "https://github.com/rtmigo/ghfile_test_data/blob/dev/dir-abc/a.md"),
        td!.path);

    expect(td!.listSync().length, 1);
    expect(File(fn).existsSync(), true);
  });

  test('download flat dir', () {
    updateLocal(
        argToEndpoint(
            "https://github.com/rtmigo/ghfile_test_data/blob/dev/dir-abc/"),
        td!.path);

    expect(td!.listSync(recursive: true).length, 3);
    expect(File(path.join(td!.path, "a.md")).existsSync(), true);
    expect(File(path.join(td!.path, "b.md")).existsSync(), true);
    expect(File(path.join(td!.path, "c.md")).existsSync(), true);
  });

  test('download subdirs dir', () {
    updateLocal(
        argToEndpoint(
            "https://github.com/rtmigo/ghfile_test_data/blob/dev/"),
        td!.path);

    expect(td!.listSync(recursive: true).length, greaterThan(5));
    expect(File(path.join(td!.path, "file_one.txt")).existsSync(), true);
    expect(File(path.join(td!.path, "file_two.txt")).existsSync(), true);
    expect(File(path.join(td!.path, "dir-abc", "a.md")).existsSync(), true);
    expect(File(path.join(td!.path, "dir-abc", "b.md")).existsSync(), true);
    expect(File(path.join(td!.path, "dir-abc", "c.md")).existsSync(), true);
  });

}


