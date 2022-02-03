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
import 'package:cmc/cmc/transition_delegate.dart';
import 'package:cmc/data/login_info.dart';
import 'package:cmc/pages/pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CMCRouterDelegate extends RouterDelegate<CMCPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CMCPath> {
  final GlobalKey<NavigatorState> navigatorKey;

  // AppPath _currentPath = AppPath(CMCPath.home());

  CMCRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  CMCPath _currentPath = CMCPath.home();

  CMCPath get currentConfiguration => _currentPath;
  late CMCLoginInfo loginState;

  final simplePages = <CMCPathType, Page>{
    CMCPathType.Home: HomePage(HomePage.chat),
    CMCPathType.Login: LoginPage(),
    CMCPathType.ChatOverview: HomePage(HomePage.chat),
    CMCPathType.GroupOverview: HomePage(HomePage.room),
    CMCPathType.Unknown: UnknownPage()
  };

  final complexPages = <CMCPathType, Page Function(String)>{
    CMCPathType.Settings: (id) => SettingsPage(id),
    CMCPathType.OpenChat: (id) => OpenChatPage(id),
    CMCPathType.OpenGroup: (id) => OpenGroupPage(id),
  };

  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<CMCLoginInfo>(context, listen: false);
    Provider.of<AppPath>(context, listen: false).addListener(() {
      _currentPath = Provider.of<AppPath>(context, listen: false).path;
      notifyListeners();
    });

    return Navigator(
      key: navigatorKey,
      transitionDelegate: CMCTransitionDelegate(),
      pages: [
        LoadingPage(),
        if (currentConfiguration.isSimple)
          simplePages[currentConfiguration.pathType]!
        else
          complexPages[currentConfiguration.pathType]!(currentConfiguration.id!)
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
  SynchronousFuture<void> setNewRoutePath(CMCPath configuration) {
    CMCPath oldPath = _currentPath;

    if (loginState.isLoggedIn) {
      _currentPath = configuration;
    } else {
      _currentPath = CMCPath.login();
    }

    if (!((oldPath.isChatOverview ||
            oldPath.isGroupOverview ||
            oldPath.isHome) &&
        (_currentPath.isHome ||
            _currentPath.isGroupOverview ||
            currentConfiguration.isChatOverview))) {
      notifyListeners();
    }
    return SynchronousFuture<void>(null);
  }
}
