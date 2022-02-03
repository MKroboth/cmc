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
import 'package:cmc/screens/chat_screen.dart';
import 'package:cmc/screens/groups_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final int initialTab;

  HomeScreen(this.initialTab);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        initialIndex: initialTab,
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("CMC"),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    ChatScreen(embed: true),
                    GroupsScreen(embed: true),
                  ],
                ),
              ),
              TabBar(
                labelColor: Theme.of(context).primaryColor,
                tabs: [
                  Tab(
                    icon: Icon(Icons.chat),
                  ),
                  Tab(
                    icon: Icon(Icons.group),
                  )
                ],
                onTap: (index) {
                  Provider.of<AppPath>(context, listen: false).path =
                      [CMCPath.chatOverview(), CMCPath.groupOverview()][index];
                },
              ),
            ],
          ),
          drawer: Drawer(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: Animate button expansion to fullscreen;
            },
            child: Text("+"),
          ),
        ),
      );
}
