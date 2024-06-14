import 'package:flutter/material.dart';
import 'package:rest_api_example/models/product.dart';
import 'package:rest_api_example/services/api_service.dart';
import 'package:rest_api_example/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _productList = [];
  final ApiServices apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    try {
      final products = await apiServices.getData();
      setState(() {
        _productList = products;
      });
    } catch (error) {
      MyUtils.SnackBarError(context, 'Failed to fetch products');
    }
  }

  void _showAddProductDialog() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newProduct = Product(
                  title: titleController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  description: descriptionController.text,
                  image: imageController.text,
                  category: categoryController.text,
                );

                apiServices.addProduct(newProduct).then((addedProduct) {
                  MyUtils.SnackBarSucess(context, 'Product added successfully');
                  setState(() {
                    _productList.add(addedProduct);
                  });
                  Navigator.of(context).pop();
                }).catchError((error) {
                  MyUtils.SnackBarError(context, 'Failed to add product');
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int productId, int index) {
    apiServices.deleteProduct(productId).then((_) {
      MyUtils.SnackBarSucess(context, "Product deleted");
      setState(() {
        _productList.removeAt(index);
      });
    }).catchError((error) {
      MyUtils.SnackBarError(context, "Failed to delete product");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REST API HOME"),
        centerTitle: true,
        elevation: 3.0,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: _showAddProductDialog,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _productList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _productList.length,
              itemBuilder: (context, index) {
                Product product = _productList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    child: Card(
                      color: Colors.grey.shade300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(product.image),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("Price: \$${product.price}"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _deleteProduct(product.id!, index);
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
