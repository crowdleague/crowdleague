import 'package:crowdleague/actions/settings/store_brightness_mode.dart';
import 'package:crowdleague/enums/settings/brightness_mode.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:flutter/material.dart';

class DarkModeToggle extends StatefulWidget {
  @override
  _DarkModeToggleState createState() => _DarkModeToggleState();
}

class _DarkModeToggleState extends State<DarkModeToggle> {
  List<bool> isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: <Widget>[
        Icon(Icons.wb_sunny),
        Icon(Icons.stars),
        Icon(Icons.system_update),
      ],
      onPressed: (int index) {
        if (index == BrightnessMode.dark.index) {
          context.dispatch(StoreBrightnessMode(mode: BrightnessMode.dark));
        } else if (index == BrightnessMode.light.index) {
          context.dispatch(StoreBrightnessMode(mode: BrightnessMode.light));
        } else if (index == BrightnessMode.system.index) {
          context.dispatch(StoreBrightnessMode(mode: BrightnessMode.system));
        }
        setState(() {
          for (var i = 0; i < 3; i++) {
            isSelected[i] = false;
          }
          isSelected[index] = !isSelected[index];
        });
      },
      isSelected: isSelected,
    );
  }
}
