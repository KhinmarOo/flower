
import 'package:flutter/material.dart';

class CartOrder extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems; // ပစ္စည်းစာရင်းကို HomePage ကနေ လှမ်းယူမယ်
  const CartOrder({super.key, required this.cartItems});

  @override
  State<CartOrder> createState() => _CartOrderState();
}

class _CartOrderState extends State<CartOrder> {
  int getTotalAmount() {
    int total = 0;
    for (var item in widget.cartItems) {
      total += (item['price'] as int) * (item['qty'] as int);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
      ),
      body: widget.cartItems.isEmpty
        ? const Center(child: Text("Your cart is empty!")) 
        : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(item['image'], width: 70, height: 70, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 5),
                              Text("\$ ${item['price']}", style: TextStyle(color: Colors.pink.shade400)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            _buildQtyBtn(Icons.remove, () {
                              setState(() {
                                if (item['qty'] > 1) {
                                  item['qty']--;
                                } else {
                                  // ၁ ဖြစ်နေချိန် ထပ်နှိပ်ရင် list ထဲက ဖျက်မယ်
                                  widget.cartItems.removeAt(index);
                                }
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
                    Text("\$ ${getTotalAmount()}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Order Done Alert Box ပြမယ်
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Success"),
                          content: const Text("Order Done! Your flowers will be delivered soon."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  widget.cartItems.clear(); // Cart ထဲက ပစ္စည်းတွေ အကုန်ဖျက်မယ်
                                });
                                Navigator.pop(context); // Dialog ပိတ်မယ်
                                // Navigator.pop(context); // Home ကို ပြန်သွားမယ်
                              }, 
                              child: const Text("OK")
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("Order", style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.pink.shade100, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, size: 18, color: Colors.pink.shade700),
      ),
    );
  }
}