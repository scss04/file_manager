import 'dart:io';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/widgets.dart';

class FileManagerController {
  final ValueNotifier<String> _path = ValueNotifier<String>('');
  final ValueNotifier<String> title = ValueNotifier<String>('');
  final ValueNotifier<SortBy> _short = ValueNotifier<SortBy>(SortBy.name);

  _updatePath(String path) {
    _path.value = path;
    title.value = path.split('/').last;
  }

  ValueNotifier<String> get getPathNotifier => _path;
  ValueNotifier<SortBy> get getSortedByNotifier => _short;

  /// The sorting type that is currently in use is returned.
  SortBy get getSortedBy => _short.value;

  /// [setSortedBy] is used to set the sorting type.
  ///
  /// `SortBy{ name, type, date, size }`
  set sortedBy(SortBy sortType) => _short.value = sortType;

  /// Get current Directory.
  Directory get getCurrentDirectory => Directory(_path.value);

  /// Get current path, similar to [getCurrentDirectory].
  String get getCurrentPath => _path.value;

  /// Set current directory path by providing string of path, similar to [openDirectory].
  set setCurrentPath(String path) {
    _updatePath(path);
  }

  /// return true if current directory is the root. false, if the current directory not on root of the stogare.
  Future<bool> isRootDirectory() async {
    final List<Directory> storageList = (await FileManager.getStorageList());
    return (storageList
        .where((element) => element.path == Directory(_path.value).path)
        .isNotEmpty);
  }

  /// Jumps to the parent directory of currently opened directory if the parent is accessible.
  Future<void> goToParentDirectory() async {
    if (!(await isRootDirectory()))
      openDirectory(Directory(_path.value).parent);
  }

  /// Open directory by providing [Directory].
  void openDirectory(FileSystemEntity entity) {
    if (entity is Directory) {
      _updatePath(entity.path);
    } else {
      throw ("FileSystemEntity entity is File. Please provide a Directory(folder) to be opened not File");
    }
  }

  void dispose() {
    _path.dispose();
    title.dispose();
    _short.dispose();
  }
}
