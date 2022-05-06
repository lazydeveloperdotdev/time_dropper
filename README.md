# TimeDropper

[![Pub](https://img.shields.io/pub/v/time_dropper.svg)](https://pub.dartlang.org/packages/time_dropper)
[![License](https://img.shields.io/badge/licence-Apache2-green.svg)](https://github.com/rajyadavnp/time_dropper/blob/main/LICENSE)
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/rajyadavnp/time_dropper.svg)](https://github.com/rajyadavnp/time_dropper)
[![GitHub stars](https://img.shields.io/github/stars/rajyadavnp/time_dropper.svg?style=social)](https://github.com/rajyadavnp/time_dropper)

Gorgeous, fully animated, round dial time picker inspired
by [TimeDropperJS](https://felixg.io/products/timedropper-jquery)

## Features

- Animated, round dial and fully customizable
- Adapted with system theme and/or customizable with `TimeDropperThemeData`
- 3 different designs to choose from

| DEMO 1 | DEMO 2 | DEMO 3 |
|--------|--------|--------|
|![DEMO1](https://raw.githubusercontent.com/rajyadavnp/time_dropper/main/demo/style1.gif)|![DEMO2](https://raw.githubusercontent.com/rajyadavnp/time_dropper/main/demo/style2.gif)|![DEMO3](https://raw.githubusercontent.com/rajyadavnp/time_dropper/main/demo/style3.gif)|

## Getting started

- Add ```time_dropper: <latest_version>``` to ```pubspec.yaml```
- Run ```flutter pub get``` in the terminal in the project directory or select ```pub get``` from
  within   ```pubspec.yaml``` file
- Add import statement,

```dart
import 'package:time_dropper/time_dropper.dart';
```

## Usage

For full implementation, see [example](https://github.com/rajyadavnp/time_dropper/tree/main/example)

```dart
_showTimeDropper(GlobalKey key) {
  showTimeDropper(
    context: context,
    onDone: () {
      // TODO: use this callback if you want time update only when the time dropper window closes 
    },
    onTimeChanged: (time) {
      setState(() {
        _time = time;
      });
      // use this callback to get updates in real-time
    },
    containerKey: key,
    // Pass the key so that time dropper dialog opens up near the container widget 
    // Opens in the center if null
    initialTime: _time,
    style: TimeDropperStyle.outerFilled,
    // or TimeDropperStyle.innerFilled / TimeDropperStyle.bordered,
  );
}
```

## Additional information

### showTimeDropper() (function)

| Attributes | Type | Description |
| ---------- | ---- | ----------- |
| `context` | `BuildContext` | BuildContext |
| `onTimeChanged` | `void Function(TimeOfDay)?` | callback which returns `TimeOfDay` object as time is changed (realtime) |
| `onDone` | `void Function(TimeOfDay)?` | callback which returns `TimeOfDay` object when the dialog is closed  |
| `initialTime` | `TimeOfDay?` | time to be selected by default (selects current time, if null) |
| `containerKey` | `GlobalKey?` | Pass the key so that time dropper dialog opens up near the container widget (opens in the center, if null) |
| `barrierColor` | `Color?` | color of the background behind the dialog (default: `Colors.black12`) |
| `style` | `TimeDropperStyle` | one of the 3 styles, `TimeDropperStyle.outerFilled`, `TimeDropperStyle.innerFilled` or `TimeDropperStyle.bordered` |
| `themeData` | `TimeDropperThemeData?` | customize the dialog as you wish |

### TimeDropperStyle (enum)

| Style | Ref |
| ----- | --- |
| `TimeDropperStyle.outerFilled` | [DEMO 1](#features) |
| `TimeDropperStyle.innerFilled` | [DEMO 2](#features) |
| `TimeDropperStyle.bordered` | [DEMO 3](#features) |

### TimeDropperThemeData

| Attributes | Type | Description |
| ---------- | ---- | ----------- |
| `brightness` | `Brightness?` | brightness of the dialog (`light` or `dark`), default to adapt app theme |
| `primaryColor` | `Color?` | color for all major highlight components, default to app theme `colorScheme.secondary` |
| `canvasColor` | `Color?` | dial background color, default to app theme `canvasColor` |
| `handleColor` | `Color?` | color of the sliding handle, default to `primaryColor` |
| `handleDotsColor` | `Color?` | color of the dots in sliding handle, default to `Colors.white` |
| `innerColor` | `Color?` | color of the border (`TimeDropperStyle.bordered`) or inner dial (`TimeDropperStyle.innerFilled`), default to `primaryColor` |
| `selectedColor` | `Color?` | color of the selected text (hour or minute), default to `primaryColor` |
| `unSelectedColor` | `Color?` | color of the unselected text (hour or minute), default to app theme `hintColor` |
| `selectedHandColor` | `Color?` | color of the selected hand (hour or minute hand), default to `selectedColor.withOpacity(0.5)` |
| `unSelectedHandColor` | `Color?` | color of the selected hand (hour or minute hand), default to `unSelectedColor.withOpacity(0.5)` |
| `shadowColor` | `Color?` | color of the elevated shadow, default to app theme `hintColor` |
| `fontFamily` | `String?` | font family of the widget, default to app's `fontFamily` |
