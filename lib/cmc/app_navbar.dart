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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppNavbar extends StatelessWidget {
  final int selectedIndex;

  AppNavbar({required this.selectedIndex});

  @override
  Widget build(BuildContext context) => NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.chat), label: "Chat"),
          NavigationDestination(icon: Icon(Icons.group), label: "Groups"),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (destination) {
          Provider.of<AppPath>(context, listen: false).path =
              [CMCPath.chatOverview(), CMCPath.groupOverview()][destination];
        },
      );
}
