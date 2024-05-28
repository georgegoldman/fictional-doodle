import "dart:ffi";
import "dart:io";

import "package:ffi/ffi.dart";

// ignore: camel_case_types

typedef InitKeyboardEventNative = Void Function(Pointer<Utf8> device);
typedef InitKeyboardEventDart = void Function(Pointer<Utf8> device);

typedef StopKeyboardEventNative = Void Function();
typedef StopKeyboardEventDart = void Function();

typedef GetKeyboardEventStatusNative = Int8 Function();
typedef GetKeyboardEventStatusDart = int Function();

typedef SetEventCheckIntervalNative = Void Function(Int32 interval);
typedef SetEventCheckIntervalDart = void Function(int interval);

// typedef CheckAndResetKeyboardEventStatusNative = Void Function();
// typedef CheckAndResetKeyboardEventStatusDart = void Function();

class KeyboardEvent {
  final DynamicLibrary _lib;

  late final InitKeyboardEventDart initKeyboardEvent;
  late final StopKeyboardEventDart stopKeyboardEvent;
  late final GetKeyboardEventStatusDart getKeyboardEventStatus;
  late final SetEventCheckIntervalDart setEventCheckInterval;
  // late final CheckAndResetKeyboardEventStatusDart
  //     checkAndResetKeyboardEventStatus;

  KeyboardEvent._(this._lib) {
    initKeyboardEvent = _lib
        .lookup<NativeFunction<InitKeyboardEventNative>>('init_keyboard_event')
        .asFunction();
    stopKeyboardEvent = _lib
        .lookup<NativeFunction<StopKeyboardEventNative>>('stop_keyboard_event')
        .asFunction();
    getKeyboardEventStatus = _lib
        .lookup<NativeFunction<GetKeyboardEventStatusNative>>(
            'get_keyboard_event_status')
        .asFunction();

    setEventCheckInterval = _lib
        .lookup<NativeFunction<SetEventCheckIntervalNative>>(
            'set_event_check_interval')
        .asFunction();
    // checkAndResetKeyboardEventStatus = _lib
    //     .lookup<NativeFunction<CheckAndResetKeyboardEventStatusNative>>(
    //         'check_and_reset_keyboard_event_status')
    //     .asFunction();
  }

  static Future<KeyboardEvent> load() async {
    final libraryPath = _getLibraryPath();
    final lib = DynamicLibrary.open(libraryPath);
    return KeyboardEvent._(lib);
  }

  static String _getLibraryPath() {
    if (Platform.isMacOS) {
      return 'your path for mac lib file';
    } else if (Platform.isLinux) {
      return 'lib/library/linux/libkeyboard_event.so';
    } else if (Platform.isWindows) {
      return 'your path for mac lib file';
    } else {
      throw UnsupportedError("This platform is not supported.");
    }
  }
}
