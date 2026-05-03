import 'package:flutter/material.dart';

class CartOrder extends StatefulWidget {
  const CartOrder({super.key});

  @override
  State<CartOrder> createState() => _CartOrderState();
}

class _CartOrderState extends State<CartOrder> {

  // နမူနာ Cart ပစ္စည်းစာရင်း (တကယ့် App မှာဆိုရင်တော့ ဒါက Database ကလာမှာပါ)
  final List<Map<String, dynamic>> cartItems = [
    {"name": "Pink Rose Bouquet", "price": 30000, "qty": 2, "image": "assets/images/flower1.png"},
    {"name": "Sunny Sunflower Mix", "price": 25000, "qty": 1, "image": "assets/images/flower1.png"},
    {"name": "White Lily Arrangement", "price": 40000, "qty": 1, "image": "assets/images/flower1.png"},
  ];

  // စုစုပေါင်းကျသင့်ငွေကို တွက်တဲ့ function
  int getTotalAmount() {
    int total = 0;
    for (var item in cartItems) {
      total += (item['price'] as int) * (item['qty'] as int);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Shopping Cart"),
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ၁။ ပစ္စည်းစာရင်းပြမယ့်အပိုင်း (ListView)
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        // ပန်းပုံ
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(item['image'], width: 70, height: 70, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 15),
                        // နာမည်နဲ့ ဈေးနှုန်း
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 5),
                              Text("${item['price']} MMK", style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                        // အတိုးအလျှော့ခလုတ်များ
                        Row(
                          children: [
                            _buildQtyBtn(Icons.remove, () {
                              setState(() {
                                if (item['qty'] > 1) item['qty']--;
                              });
                            }),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text("${item['qty']}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                            _buildQtyBtn(Icons.add, () {
                              setState(() {
                                item['qty']++;
                              });
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ၂။ အောက်ခြေ Total နဲ့ Checkout အပိုင်း
          Container(
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Amount:", style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Text("${getTotalAmount()} MMK", 
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Checkout logic ဒီမှာရေးမယ်
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("Checkout", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    
  }
}



Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.pink.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: Colors.pink.shade700),
    ),
  );
}
