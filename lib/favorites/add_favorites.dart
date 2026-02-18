import 'package:flutter/material.dart';

class AddFavorites extends StatefulWidget {
  const AddFavorites({super.key});

  @override
  State<StatefulWidget> createState() => _AddFavoritesState();
}

class _AddFavoritesState extends State<AddFavorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Add favorites')));
  }
}
