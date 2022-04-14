import 'package:flutter/material.dart';
import 'package:flutter_main/models/category.dart';
import 'package:flutter_main/providers/category_provider.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/products_provider.dart';
import '../../models/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/admin-edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  //allow me to interact with the state behind the Form widget.
  final _form = GlobalKey<FormState>();
  var _dropdownValue = null;
  List<Category> categories = [];
  var _editedProduct = Product(
    id: null,
    name: '',
    description: '',
    price: 0,
    imageUrl: '',
    categoryId: 0,
  );
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'category': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _image;

  Future<List<Category>> getCategories() async {
    final cat = await Provider.of<CategoryProvider>(context, listen: false)
        .getCategories;
    setState(() {
      categories = cat;
    });
    return categories;
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    //editing
    if (_editedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id!, _editedProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Product Edited Successfuly!',
            textAlign: TextAlign.left,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct, _image);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Product Added Successfuly!',
            textAlign: TextAlign.left,
          ),
          duration: Duration(seconds: 2),
        ),
      );
    }
    Navigator.of(context).pop();
  }

  Future _getCameraImage() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.camera);
    _image = new MultipartFile.fromBytes(
      'file',
      await image!.readAsBytes(),
      filename: image.name,
    );
  }

  Future<bool> _getGalleryImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    _image = new MultipartFile.fromBytes(
      'file',
      await image!.readAsBytes(),
      filename: image.name,
    );
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getCategories();
  }

  //extract data from admin_product_item.
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId as String);
        _initValues = {
          'title': _editedProduct.name!,
          'description': _editedProduct.description!,
          'price': _editedProduct.price!.toString(),
          'category': _editedProduct.categoryId!.toString(),
          'imageUrl': _editedProduct.imageUrl!
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add/Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    name: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    categoryId: _editedProduct.categoryId,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    name: _editedProduct.name,
                    price: double.parse(value!),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    categoryId: _editedProduct.categoryId,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value.';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    name: _editedProduct.name,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    categoryId: _editedProduct.categoryId,
                  );
                },
              ),
              SizedBox(height: 5),
              DropdownButton<Category>(
                iconSize: 30,
                iconEnabledColor: Colors.black,
                isExpanded: true,
                elevation: 16,
                style: Theme.of(context).textTheme.bodyText1,
                value: _dropdownValue,
                underline: Container(
                  height: 1,
                  color: Colors.black,
                ),
                onChanged: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    name: _editedProduct.name,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    // categoryId: value!.name!.contains("Sandwich")
                    //     ? 1
                    //     : value.name!.contains("Salad")
                    //         ? 2
                    //         : 3,
                    categoryId: int.parse(value!.id!),
                  );
                  setState(() {
                    _dropdownValue = value;
                  });
                },
                items: categories.map<DropdownMenuItem<Category>>(
                  (Category value) {
                    return DropdownMenuItem<Category>(
                      value: value,
                      child: Text(value.name!),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Take a photo:",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  IconButton(
                    color: Colors.greenAccent[300],
                    onPressed: _getCameraImage,
                    icon: Icon(Icons.camera_alt_outlined),
                  ),
                  Text(
                    "Pick an Image:",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  IconButton(
                    color: Colors.greenAccent[300],
                    onPressed: _getGalleryImage,
                    icon: Icon(Icons.image_search),
                  ),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Save Product:"),
                  IconButton(
                    onPressed: _saveForm,
                    icon: Icon(Icons.save),
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
