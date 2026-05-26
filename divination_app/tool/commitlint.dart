import 'dart:io';

const _allowedTypes = <String>{
  'build',
  'chore',
  'ci',
  'docs',
  'feat',
  'fix',
  'perf',
  'refactor',
  'revert',
  'style',
  'test',
};

final _headerFormat = RegExp(
  r'^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([a-z0-9._/-]+\))?(!)?: (.+)$',
);

void main(List<String> args) async {
  final filePath = _readOption(args, '--file');
  final revRange = _readOption(args, '--rev-range');

  if ((filePath == null && revRange == null) ||
      (filePath != null && revRange != null)) {
    _printUsageAndExit();
  }

  if (filePath != null) {
    final message = _normalizeMessage(File(filePath).readAsStringSync());
    final errors = _validateMessage(message);
    if (errors.isNotEmpty) {
      _printErrors('commit message', errors);
      exit(1);
    }

    stdout.writeln('commitlint: commit message passed');
    return;
  }

  final result = await Process.run('git', [
    'log',
    '--format=%H%x1f%B%x1e',
    revRange!,
  ]);

  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    exit(result.exitCode);
  }

  final records = result.stdout.toString().split('\x1e');
  var hasErrors = false;

  for (final record in records) {
    if (record.trim().isEmpty) {
      continue;
    }

    final separatorIndex = record.indexOf('\x1f');
    if (separatorIndex == -1) {
      continue;
    }

    final commitHash = record.substring(0, separatorIndex).trim();
    final message = _normalizeMessage(record.substring(separatorIndex + 1));
    final errors = _validateMessage(message);

    if (errors.isNotEmpty) {
      hasErrors = true;
      _printErrors(commitHash, errors);
    }
  }

  if (hasErrors) {
    exit(1);
  }

  stdout.writeln('commitlint: all commit messages passed');
}

String? _readOption(List<String> args, String option) {
  final index = args.indexOf(option);
  if (index == -1 || index + 1 >= args.length) {
    return null;
  }

  return args[index + 1];
}

Never _printUsageAndExit() {
  stderr.writeln(
    'Usage: dart tool/commitlint.dart --file <path> | --rev-range <range>',
  );
  exit(64);
}

String _normalizeMessage(String rawMessage) {
  final lines = rawMessage
      .split('\n')
      .where((line) => !line.trimLeft().startsWith('#'))
      .toList();

  return lines.join('\n').trim();
}

List<String> _validateMessage(String message) {
  final errors = <String>[];

  if (message.isEmpty) {
    return ['commit message cannot be empty'];
  }

  if (_containsChinese(message)) {
    errors.add('commit message must not contain Chinese characters');
  }

  if (_containsEmoji(message)) {
    errors.add('commit message must not contain emoji');
  }

  final lines = message
      .split('\n')
      .map((line) => line.trimRight())
      .where((line) => line.isNotEmpty)
      .toList();

  if (lines.isEmpty) {
    errors.add('commit message cannot be empty');
    return errors;
  }

  final header = lines.first;
  final match = _headerFormat.firstMatch(header);

  if (match == null) {
    errors.add('header must follow conventional commits: type(scope): subject');
    return errors;
  }

  final type = match.group(1)!;
  final subject = match.group(4)!.trim();

  if (!_allowedTypes.contains(type)) {
    errors.add('type "$type" is not allowed');
  }

  if (subject.isEmpty) {
    errors.add('subject cannot be empty');
  }

  if (header.length > 72) {
    errors.add('header must be 72 characters or fewer');
  }

  if (!_isAscii(header)) {
    errors.add('header must use ASCII characters only');
  }

  if (subject.endsWith('.')) {
    errors.add('subject must not end with a period');
  }

  return errors;
}

bool _containsChinese(String value) {
  for (final rune in value.runes) {
    if ((rune >= 0x3400 && rune <= 0x4DBF) ||
        (rune >= 0x4E00 && rune <= 0x9FFF) ||
        (rune >= 0xF900 && rune <= 0xFAFF)) {
      return true;
    }
  }

  return false;
}

bool _containsEmoji(String value) {
  for (final rune in value.runes) {
    if ((rune >= 0x1F000 && rune <= 0x1FAFF) ||
        (rune >= 0x2600 && rune <= 0x27BF) ||
        rune == 0x200D ||
        rune == 0xFE0F) {
      return true;
    }
  }

  return false;
}

bool _isAscii(String value) {
  for (final codeUnit in value.codeUnits) {
    if (codeUnit > 0x7F) {
      return false;
    }
  }

  return true;
}

void _printErrors(String source, List<String> errors) {
  stderr.writeln('commitlint failed for $source');
  for (final error in errors) {
    stderr.writeln('- $error');
  }
}
