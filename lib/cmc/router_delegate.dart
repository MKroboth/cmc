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
import 'package:cmc/data/login_info.dart';
import 'package:cmc/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CMCRouterDelegate extends RouterDelegate<CMCPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CMCPath> {
  final GlobalKey<NavigatorState> navigatorKey;

  CMCPath _currentPath = CMCPath.home();

  CMCRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  CMCPath get currentConfiguration => _currentPath;
  late CMCLoginInfo loginState;

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<CMCLoginInfo>(context, listen: true);

    return Navigator(
      key: navigatorKey,
      pages: [
        LoadingPage(),
        if (!loginState.isLoggedIn && currentConfiguration.isLogin)
          LoginPage()
        else if (!loginState.isLoggedIn)
          DeniedPage()
        else if (loginState.isLoggedIn && currentConfiguration.isHome)
          HomePage()
        else if (loginState.isLoggedIn && currentConfiguration.isChatOverview)
          ChatPage()
        else if (loginState.isLoggedIn && currentConfiguration.isGroupOverview)
          GroupsPage()
        else if (loginState.isLoggedIn &&
            currentConfiguration.isSettings &&
            currentConfiguration.id != null)
          SettingsPage(currentConfiguration.id!)
        else if (loginState.isLoggedIn &&
            currentConfiguration.isOpenChat &&
            currentConfiguration.id != null)
          OpenChatPage(currentConfiguration.id!)
        else if (loginState.isLoggedIn &&
            currentConfiguration.isOpenGroup &&
            currentConfiguration.id != null)
          OpenGroupPage(currentConfiguration.id!)
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(CMCPath configuration) async {
    if (loginState.isLoggedIn) {
      _currentPath = configuration;
    } else {
      _currentPath = CMCPath.login();
    }
    notifyListeners();
  }
}