import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caseapp/view/component/product_card.dart';
import 'package:caseapp/model/sorting_option.dart';
import 'package:caseapp/view_model/products_view_model.dart';

class ProductsPage extends StatefulWidget {
  final String category;

  ProductsPage({Key? key, this.category = 'All'}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _selectedCategory = 'All';
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category;
    Future.microtask(() =>
      Provider.of<ProductsViewModel>(context, listen: false).filterFlowersByCategory(_selectedCategory)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('P R O D U C T S'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
            child: _buildSearchBar(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSortButton(),
              _buildFilterButton(),
            ],
          ),
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchText = value;
        });
        if (_searchText.isNotEmpty) {
          Provider.of<ProductsViewModel>(context, listen: false).searchFlowers(_searchText);
        } else {
          Provider.of<ProductsViewModel>(context, listen: false).resetFilters();
        }
      },
      decoration: InputDecoration(
        hintText: 'Arama...',
        prefixIcon: Icon(Icons.search),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }

  Widget _buildSortButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      icon: Icon(
        Icons.sort,
        color: Color.fromARGB(255, 110, 19, 13),
      ),
      label: Text(
        "Sort",
        style: TextStyle(
          color: Color.fromARGB(255, 110, 19, 13),
        ),
      ),
      onPressed: () => _showSortingOptions(),
    );
  }

  Widget _buildFilterButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
      ),
      icon: Icon(
        Icons.filter_list,
        color: Color.fromARGB(255, 110, 19, 13),
      ),
      label: Text(
        "Fılter",
        style: TextStyle(
          color: Color.fromARGB(255, 110, 19, 13),
        ),
      ),
      onPressed: () => _showFilteringOptions(),
    );
  }

  void _showSortingOptions() {
    final viewModel = Provider.of<ProductsViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sorting Options"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(title: Text("alphabetical"), onTap: () => _updateSortingOption(SortingOption.alphabetical)),
              ListTile(title: Text("increasing price"), onTap: () => _updateSortingOption(SortingOption.priceLowToHigh)),
              ListTile(title: Text("decreasing price"), onTap: () => _updateSortingOption(SortingOption.priceHighToLow)),
            ],
          ),
        );
      },
    );
  }

  void _updateSortingOption(SortingOption option) {
    final viewModel = Provider.of<ProductsViewModel>(context, listen: false);
    viewModel.setSortingOption(option);
    Navigator.of(context).pop();
  }

  void _showFilteringOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Filter Options"),
          content: SingleChildScrollView(
            child: ListBody(
              children: ['All', 'Roses', 'Tulips', 'Orchids', 'Daisies', 'Irises', 'Sunflowers', 'Herbs', 'Lilies', 'Specials', 'Carnations']
                  .map((String category) => ListTile(
                        title: Text(category),
                        onTap: () => _updateFilterCategory(category),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  void _updateFilterCategory(String category) {
    setState(() {
      _selectedCategory = category;
      Provider.of<ProductsViewModel>(context, listen: false).filterFlowersByCategory(category);
      Navigator.of(context).pop();
    });
  }

  Widget _buildProductList() {
    final viewModel = Provider.of<ProductsViewModel>(context);
    return Consumer<ProductsViewModel>(
      builder: (context, viewModel, child) {
        final flowers = viewModel.filteredFlowers.isNotEmpty ? viewModel.filteredFlowers : viewModel.flowers;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: flowers.length,
          itemBuilder: (context, index) {
            final flower = flowers[index];
            return ProductCard(flower: flower);
          },
        );
      },
    );
  }
}
