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
import 'package:cmc/screens/chat_screen.dart';
import 'package:cmc/screens/groups_screen.dart';
import 'package:cmc/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

extension OrOffstage<T> on AsyncSnapshot<T> {
  Widget orOffstage(BuildContext ctx, Widget? Function(BuildContext, T) builder,
      [Widget Function(BuildContext, Object)? onError]) {
    if (this.hasData)
      return builder(ctx, this.data!) ?? Offstage();
    else if (this.hasError)
      return (onError != null) ? onError(ctx, this.error!) : Offstage();
    else
      return Offstage();
  }
}

extension StreamBuilderOrElse<T> on Stream<T> {
  Widget newBuilder(
          {required Widget Function(BuildContext, T data) onSuccess,
          T? initialData,
          Widget? Function(BuildContext, Object)? onError,
          Widget defaultWidget = const Offstage()}) =>
      StreamBuilder<T>(
        initialData: initialData,
        builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
          if (snapshot.hasError) {
            if (onError == null)
              return defaultWidget;
            else
              return onError(context, snapshot.error!) ?? defaultWidget;
          } else if (snapshot.hasData)
            return onSuccess(context, snapshot.data!);
          else
            return defaultWidget;
        },
        stream: this,
      );
}

extension AddDismissible on List<Widget> {
  Dismissible addDismissible(BuildContext context,
      {required Widget Function(BuildContext, UniqueKey) build,
      required void Function(VoidCallback) setState,
      required void Function() dismiss}) {
    final key = UniqueKey();
    this.clear();
    final widget = Dismissible(
      key: key,
      onDismissed: (_) {
        setState(() {
          this.removeWhere((element) => element.key == key);
          dismiss();
        });
      },
      child: build(context, key),
    );

    setState(() => this.add(widget));
    return widget;
  }
}

class HomeScreen extends StatelessWidget {
  final int selectedTab;

  const HomeScreen({required this.selectedTab});

  @override
  Widget build(BuildContext context) => Consumer<CMCLoginInfo>(
        builder: (context, final CMCLoginInfo value, _) =>
            _HomeScreenWithClient(initialTab: selectedTab, loginInfo: value),
      );
}

class _HomeScreenWithClient extends StatefulWidget {
  final CMCLoginInfo loginInfo;
  final int initialTab;

  const _HomeScreenWithClient(
      {required this.loginInfo, required this.initialTab});

  @override
  State<StatefulWidget> createState() => _HomeScreenWithClientState();
}

class _HomeScreenWithClientState extends State<_HomeScreenWithClient> {
  final topNotifications = <Widget>[];

  Widget _buildSyncStatusIndicator(
      BuildContext context, SyncStatusUpdate statusUpdate) {
    if (statusUpdate.status == SyncStatus.processing) {
      return LinearProgressIndicator(
        value: statusUpdate.progress,
      );
    } else
      return Offstage();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.loginInfo.isLoggedIn) {
      return CircularProgressIndicator();
    }

    final Client client = widget.loginInfo.loginStatus!.client;
    client.onKeyVerificationRequest.stream.listen((event) {
      event.onUpdate = () => Future.delayed(Duration.zero, () async {
            print(
                "KeyVerificationRequest: ${event.state}, onUpdate: ${event.onUpdate}");
            switch (event.state) {
              case KeyVerificationState.askAccept:
                topNotifications.addDismissible(context,
                    build: _buildVerificationAcceptRequestCard(
                        event.acceptVerification),
                    setState: setState,
                    dismiss: () => event.cancel("m.user"));

                break;
              case KeyVerificationState.askSSSS:
                // TODO: Handle this case.
                break;
              case KeyVerificationState.waitingAccept:
                // TODO: Handle this case.
                break;
              case KeyVerificationState.askSas:
                showDialog(
                    context: context,
                    builder: _verifySas(event.sasNumbers, event.sasEmojis,
                        event.acceptSas, event.rejectSas));
                // TODO: Handle this case.
                break;
              case KeyVerificationState.waitingSas:
                break;
              case KeyVerificationState.done:
                // TODO: Handle this case.
                setState(() {
                  topNotifications.clear();
                });
                break;
              case KeyVerificationState.error:
                setState(() {
                  topNotifications.clear();
                });
                break;
            }
          });
      event.onUpdate!();
    });
    client.onSyncStatus.stream.listen((event) {
      setState(() {});
    });

    return DefaultTabController(
      initialIndex: widget.initialTab,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.applicationTitle),
        ),
        body: Column(
          children: [
            client.onSyncStatus.stream
                .newBuilder(onSuccess: _buildSyncStatusIndicator),
            ListView.builder(
              itemBuilder: (context, index) => topNotifications[index],
              shrinkWrap: true,
              itemCount: topNotifications.length,
            ),
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
                  icon: Icon(Icons.chat),
                )
              ],
              onTap: (index) {
                Provider.of<AppPath>(context, listen: false).path =
                    [CMCPath.chatOverview(), CMCPath.groupOverview()][index];
              },
            ),
          ],
        ),
        drawer: Drawer(
            child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text(
                  context.l10n.settings,
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(context.l10n.about),
              ),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Animate button expansion to fullscreen;
          },
          child: Text("+"),
        ),
      ),
    );
  }

  Widget Function(BuildContext, UniqueKey) _buildVerificationAcceptRequestCard(
          VoidCallback accept) =>
      (BuildContext context, UniqueKey key) => Card(
            child: ListTile(
              title: Text("Accept verification"),
              trailing: OutlinedButton(
                child: Text("Accept"),
                onPressed: () {
                  accept();
                },
              ),
            ),
          );

  Widget Function(BuildContext) _verifySas(
          List<int> sasNumbers,
          List<KeyVerificationEmoji> sasEmojis,
          Future<void> Function() acceptSas,
          Future<void> Function() rejectSas) =>
      (context) {
        return AlertDialog(
          title: Text(sasEmojis.isNotEmpty
              ? "SAS Emoji Verification"
              : "SAS Numbers Verification"),
          content: (sasEmojis.isEmpty
              ? Row(
                  children: sasNumbers.map((e) => Text("$e")).toList(),
                )
              : Row(
                  children: sasEmojis
                      .map((e) => Column(
                            children: [
                              Text(e.emoji),
                              Text(e.name),
                            ],
                          ))
                      .toList())),
          actions: [
            OutlinedButton(
                onPressed: rejectSas, child: Text("They don't match")),
            OutlinedButton(onPressed: acceptSas, child: Text("They match"))
          ],
        );
      };
}
