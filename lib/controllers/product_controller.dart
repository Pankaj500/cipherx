import 'package:cipherx/models/makeup_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product_model.dart';

final productlistprovider = StateProvider<List<Product>>((ref) => []);

final makeuplistprovider = StateProvider<List<Makup>>((ref) => []);
