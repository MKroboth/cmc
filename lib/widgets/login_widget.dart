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

import 'dart:async';

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
        return await _loginManager
            .login(loginData.name, loginData.password)
            .then<String?>((value) {
              Provider.of<CMCLoginInfo>(context, listen: false).loginStatus =
                  value;
              return null;
            })
            .timeout(Duration(seconds: 30))
            .onError<TimeoutException>((error, stackTrace) => error.toString())
            .onError<LoginError>((error, stackTrace) => error.message);
      },
      messages: LoginMessages(userHint: "Matrix ID"),
      userType: LoginUserType.name,
      onSubmitAnimationCompleted: () {
        Navigator.popUntil(context, (_) => !Navigator.canPop(context));
        Provider.of<AppPath>(context, listen: false).path = CMCPath.home();
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
