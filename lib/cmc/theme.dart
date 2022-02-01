/*
 * Copyright (c) 2022 by Maximilian Kroboth.
 *
 * This file is part of Cactis CMC.
 *
 * Cactis CMC is free software: you can redistribute it and/or modify it
 * under the terms of the GNU Affero General Public License as published
 *  by the Free Software Foundation,  version 3 of the License.
 *
 * Cactis CMC is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY;  without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License along
 *  with Cactis CMC. If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';

abstract class CMCTheme with ChangeNotifier {
  ThemeData asThemeData();

  factory CMCTheme.loadDefault() => _CMCThemeImpl(_CMCThemeImpl._defaultTheme);
}

class _CMCThemeImpl with ChangeNotifier implements CMCTheme {
  static ThemeData _defaultTheme = ThemeData(
    primarySwatch: Colors.green,
  );

  _CMCThemeImpl(ThemeData initialValue) : _value = initialValue;

  ThemeData _value;

  @override
  ThemeData asThemeData() => _value;
}
