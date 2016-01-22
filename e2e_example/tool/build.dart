// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
library build.example.generate;

import 'package:build/build.dart';

import 'package:e2e_example/copy_builder.dart';

main() async {
  var phase = new Phase([
    new CopyBuilder()
  ], [
    new InputSet('e2e_example', filePatterns: ['example/*.txt'])
  ]);

  var result = await build([
    [phase]
  ]);

  if (result.status == BuildStatus.Success) {
    print('''
Build Succeeded!

Type: ${result.buildType}
Outputs: ${result.outputs}''');
  } else {
    print('''
Build Failed :(

Type: ${result.buildType}
Outputs: ${result.outputs}

Exception: ${result.exception}
Stack Trace:
${result.stackTrace}''');
  }
}