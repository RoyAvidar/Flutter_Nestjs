import 'dart:ffi';

import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });
}
