// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:build_test/src/multi_asset_reader.dart';
import 'package:glob/glob.dart';
import 'package:test/test.dart';

final isAssetNotFound = const isInstanceOf<AssetNotFoundException>();
final throwsAssetNotFound = throwsA(isAssetNotFound);

void main() {
  group('$MultiAssetReader', () {
    AssetReader assetReader;

    test('should throw an $AssetNotFoundException with no readers', () {
      var missingId = new AssetId('some_pkg', 'some_pkg.dart');
      assetReader = new MultiAssetReader([]);
      expect(
        assetReader.readAsString(missingId),
        throwsAssetNotFound,
      );
    });

    test('should read an asset from an underyling reader', () async {
      var idA = new AssetId('some_pkg', 'a.dart');
      var idB = new AssetId('some_pkg', 'b.dart');
      var idC = new AssetId('some_pkg', 'missing.dart');
      assetReader = new MultiAssetReader([
        new InMemoryAssetReader(sourceAssets: {
          idA: new DatedString('A'),
        }),
        new InMemoryAssetReader(sourceAssets: {
          idB: new DatedString('B'),
        }),
      ]);
      expect(await assetReader.readAsString(idA), 'A');
      expect(await assetReader.readAsString(idB), 'B');
      expect(assetReader.readAsString(idC), throwsAssetNotFound);
    });

    test('should combine files when using `findAssets`', () {
      var idA = new AssetId('some_pkg', 'lib/a.dart');
      var idB = new AssetId('some_pkg', 'lib/b.dart');
      assetReader = new MultiAssetReader([
        new InMemoryAssetReader(
          sourceAssets: {
            idA: new DatedString('A'),
          },
          rootPackage: 'some_pkg',
        ),
        new InMemoryAssetReader(
          sourceAssets: {
            idB: new DatedString('B'),
          },
          rootPackage: 'some_pkg',
        ),
      ]);
      expect(assetReader.findAssets(new Glob('lib/*.dart')), [idA, idB]);
    });
  });
}
