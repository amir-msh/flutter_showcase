import 'package:flutter/material.dart';
import 'package:flutter_showcase/utils/showcase_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageSwitchDuration = const Duration(milliseconds: 500);
  final _pageSwitchCurve = Curves.decelerate;
  final _pageIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _pageIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<int>(
          valueListenable: _pageIndexNotifier,
          builder: (context, index, child) {
            return Text(
              showcaseItemsList[index].name,
            );
          },
        ),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _pageIndexNotifier,
        builder: (context, index, child) {
          return AnimatedSwitcher(
            duration: _pageSwitchDuration,
            reverseDuration: _pageSwitchDuration,
            switchInCurve: _pageSwitchCurve,
            switchOutCurve: _pageSwitchCurve,
            child: Builder(
              key: ValueKey(index),
              builder: (context) {
                return showcaseItemsList[index].pageBuilder(context);
              },
            ),
          );
        },
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: showcaseItemsList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(showcaseItemsList[index].name),
              onTap: () {
                _pageIndexNotifier.value = index;
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}
