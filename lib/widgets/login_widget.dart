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

import 'package:cmc/cmc/app_path.dart';
import 'package:cmc/cmc/cmc_path.dart';
import 'package:cmc/data/login_info.dart';
import 'package:cmc/logic/login_error.dart';
import 'package:cmc/logic/login_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatelessWidget {
  LoginManager _loginManager = LoginManager();

  @override
  Widget build(BuildContext context) {
    final login = FlutterLogin(
      hideForgotPasswordButton: true,
      onRecoverPassword: (str) async {
        return null;
      },
      onLogin: (LoginData loginData) async {
        try {
          final status =
              await _loginManager.login(loginData.name, loginData.password);
          Provider.of<CMCLoginInfo>(context, listen: false).loginStatus =
              status;
        } on LoginError catch (e) {
          return e.error();
        }
        return null;
      },
      messages: LoginMessages(userHint: "Matrix ID"),
      userType: LoginUserType.name,
      onSubmitAnimationCompleted: () {
        Navigator.pop(context);
        Provider.of<AppPath>(context, listen: false).path =
            CMCPath.chatOverview();
      },
      userValidator: (input) {
        try {
          _loginManager.validateUsername(input);
        } on LoginError catch (e) {
          return e.message;
        }
        return null;
      },
    );

    return login;
  }
}
