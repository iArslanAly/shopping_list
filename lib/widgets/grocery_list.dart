import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'shop-list-4ce40-default-rtdb.firebaseio.com', 'shoppinh-list.json');
    final response = await http.get(url);
    print('Response status: ${response.statusCode}');
  }

  final List<GroceryItem> _groceryItem = [];

  void _addNewItem() async {
    await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    _loadItems();
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItem.removeWhere((item) => item.id == item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet!'));
    if (_groceryItem.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItem.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem;
          },
          key: ValueKey(_groceryItem[index].id),
          child: ListTile(
            title: Text(_groceryItem[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItem[index].category.color,
            ),
            trailing: Text(
              _groceryItem[index].quantity.toString(),
            ),
          ),
        ),
      );
    } else {
      content = const Center(child: Text('No items added yet!'));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Your Groceries'), actions: [
        IconButton(
          onPressed: () => _addNewItem(),
          icon: const Icon(Icons.add),
        ),
      ]),
      body: content,
    );
  }
}
