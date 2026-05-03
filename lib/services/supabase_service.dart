import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  // ပန်းစာရင်းကို ဆွဲထုတ်ပြီး Product list အဖြစ် ပြန်ပေးမယ့် function
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await supabase.from('flower_products').select();
      // response ကလာတဲ့ data တွေကို model အဖြစ်ပြောင်းမယ်
      final List<dynamic> data = response;
      return data.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}