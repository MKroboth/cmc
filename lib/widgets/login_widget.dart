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

import 'package:cmc/cmc/cmc_path.dart';
import 'package:cmc/cmc/navigator.dart';
import 'package:cmc/data/login_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final login = FlutterLogin(
      hideForgotPasswordButton: true,
      onRecoverPassword: (str) async {
        return null;
      },
      onLogin: (LoginData loginData) async {
        return Provider.of<CMCLoginInfo>(context, listen: false)
            .login(loginData.name, loginData.password);
      },
      messages: LoginMessages(userHint: "Matrix ID"),
      userType: LoginUserType.name,
      onSubmitAnimationCompleted: () {
        Future.delayed(
            Duration.zero,
            () =>
                RouteNavigator.of(context).navigateTo(CMCPath.chatOverview()));
      },
      userValidator: (input) {
        if (input == null) return "Empty Matrix ID";

        if (input.startsWith("@"))
          return null;
        else
          return "Invalid Matrix ID";
      },
    );

    return login;
  }
}
