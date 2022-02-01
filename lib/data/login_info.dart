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

import 'package:flutter/cupertino.dart';

class CMCLoginInfo with ChangeNotifier {
  bool get isLoggedIn => _loggedIn;

  String get username => _username;

  bool _loggedIn = false;
  String _username = "";

  String? login(String username, String password) {
    // TODO Login.
    _loggedIn = true;

    if (_loggedIn) {
      _username = username;
      notifyListeners();
      return null;
    } else
      return "Unknown Error";
  }
}
