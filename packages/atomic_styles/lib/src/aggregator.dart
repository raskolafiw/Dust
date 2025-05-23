import 'dart:async';
import 'package:build/build.dart';
import 'package:glob/glob.dart';

import 'rules.dart'; // Import the rules and generator

/// A Builder that aggregates atomic class names from all `.classes` files
/// generated by `AtomicStyleBuilder` and outputs a single `web/atomic_styles.css`.
class AtomicCssAggregator implements Builder {
  // inputExtensions is not used by Builder in this configuration,
  // but defining it doesn't hurt and clarifies intent.
  final inputExtensions = const ['.classes'];

  @override
  final Map<String, List<String>> buildExtensions = const {
    // We expect inputs from the cache generated by the scanner.
    // This pattern technically reads *any* .dart file, but we rely on the
    // scanner having run first and produced .classes files in the cache.
    // The builder configuration in build.yaml will ensure this runs after the scanner.
    // We target a single known output file.
    r'$lib$': ['../web/atomic_styles.css'],
    r'$web$': ['atomic_styles.css'] // Also handle case where web/ is input root
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final allFoundClasses = <String>{};

    // Find all .classes files generated by the scanner phase.
    // These should be in the build cache.
    final classFiles = buildStep.findAssets(Glob('**/*.classes'));

    await for (final inputId in classFiles) {
      try {
        final content = await buildStep.readAsString(inputId);
        final classesInFile =
            content.split('\n').where((line) => line.trim().isNotEmpty);
        allFoundClasses.addAll(classesInFile);
        // We don't delete the input .classes files here, build_runner manages cache.
      } catch (e) {
        log.warning(
            'AtomicCssAggregator: Failed to read input ${inputId.path}: $e');
      }
    }

    if (allFoundClasses.isEmpty) {
      log.info(
          'AtomicCssAggregator: No atomic classes found in any temp file.');
      // Optionally delete the output file if it exists? Or write an empty file?
      // Let's write an empty file for consistency.
      final outputId =
          _determineOutputId(buildStep.inputId); // Use helper to get output ID
      if (outputId == null) {
        log.warning(
            'AtomicCssAggregator: Could not determine output path for input ${buildStep.inputId}. Skipping empty file write.');
        return;
      }
      await buildStep.writeAsString(
          // Use BuildStep's writeAsString
          outputId,
          '/* No atomic styles generated */');
      return;
    }

    // Regenerate CSS based on the *unique* set of found classes
    // This ensures consistency and applies rules correctly even if temp files had partial info.
    final finalCssMap = generateAtomicCss(allFoundClasses);

    // Generate the final CSS output string
    final cssOutputBuffer = StringBuffer();
    cssOutputBuffer.writeln('/* Generated by Dust AtomicCssAggregator */');
    cssOutputBuffer
        .writeln('/* Found ${allFoundClasses.length} unique atomic classes */');

    final sortedClassNames = finalCssMap.keys.toList()..sort();
    for (final className in sortedClassNames) {
      final escapedClassName = className.replaceAllMapped(
          RegExp(r'[.:/\]'), (match) => '\\${match.group(0)}');
      cssOutputBuffer.writeln('.$escapedClassName {');
      cssOutputBuffer.writeln('  ${finalCssMap[className]}');
      cssOutputBuffer.writeln('}');
    }

    // Define the final output asset ID
    final outputId =
        _determineOutputId(buildStep.inputId); // Use helper to get output ID
    if (outputId == null) {
      log.severe(
          'AtomicCssAggregator: Could not determine output path for input ${buildStep.inputId}. Cannot write CSS.');
      return;
    }

    // Write the final aggregated CSS file
    await buildStep.writeAsString(
        outputId, cssOutputBuffer.toString()); // Use BuildStep's writeAsString
    log.info(
        'AtomicCssAggregator: Wrote final aggregated CSS to ${outputId.path}');

    // Delete the temporary input files (optional, but good practice)
    // Note: Deleting inputs within a PostProcessBuilder might have side effects
    // in watch mode. Let's skip deletion for now.
    // await for (final inputId in tempFiles) {
    //   await buildStep.deletePrimaryInput(inputId);
    // }
  }
}

// Helper to determine the correct output AssetId based on the input.
// This is necessary because the builder might be triggered by inputs in lib or web.
AssetId? _determineOutputId(AssetId inputId) {
  if (inputId.path.startsWith('lib/')) {
    // Input was in lib, output goes to web/
    return AssetId(inputId.package, 'web/atomic_styles.css');
  } else if (inputId.path.startsWith('web/')) {
    // Input was in web, output stays in web/
    return AssetId(inputId.package, 'web/atomic_styles.css');
  }
  return null; // Should not happen with correct buildExtensions
}
