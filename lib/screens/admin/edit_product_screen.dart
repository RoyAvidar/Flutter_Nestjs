import 'package:flutter/material.dart';
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

  Future _takePicture() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.camera);
    _image = new MultipartFile.fromBytes(
      'file',
      await image!.readAsBytes(),
      filename: image.name,
    );
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
              DropdownButton<int>(
                icon: const Icon(Icons.arrow_downward),
                iconSize: 20,
                elevation: 16,
                style: const TextStyle(color: Colors.lightBlue),
                underline: Container(
                  height: 2,
                  color: Colors.blue,
                ),
                onChanged: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    name: _editedProduct.name,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    categoryId: value,
                  );
                  setState(() {});
                },
                items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("image"),
                  IconButton(
                    color: Colors.greenAccent[300],
                    onPressed: _takePicture,
                    icon: Icon(Icons.image_search),
                  ),
                ],
              ),
              Divider(),
              IconButton(
                onPressed: _saveForm,
                icon: Icon(Icons.save),
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
