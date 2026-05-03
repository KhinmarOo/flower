import 'package:flutter/material.dart';
import 'screens/order.dart';
import 'dart:math' as math;
import 'package:supabase_flutter/supabase_flutter.dart';
import './services/supabase_service.dart';
import './models/product.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Async အလုပ်လုပ်ဖို့ အရင်ဆုံး Flutter binding ကို initialize လုပ်
  await Supabase.initialize(
    url: 'https://rvcsmnkwpfxljspxwkmm.supabase.co',
    anonKey: 'sb_publishable_ZGHLHAOeSJupL1QIy9CU0w_0mZlCOlI',
  );
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  int cartCount =0;
  void _showAddtoCartDialog(){
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Added to Cart"),
          content: Text("The item has been added to your cart?"),
          actions: [
            TextButton(
              // Cancel button
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: Text("Cancel")
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cartCount++;
                });
                Navigator.of(context).pop(); // box ပိတ်
              },
              child: Text("Add") 
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final SupabaseService service = SupabaseService();

    return Scaffold(
      appBar: AppBar(
        title: Text("Bloom and Joy"),
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text("Contact"),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                label: Text("Search"),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 200,
              color: Colors.pink.shade100,
              child: Row(
                children: [

                  Transform.rotate(
                    angle: math.pi / 12,
                    child: Image.asset(
                      "assets/images/flower1.png",
                      width: 100,  
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(child: 
                    Text(
                      "Each bouquet hand-crafted with love, care, and timeless elegance.",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  
                  Transform.rotate(
                      angle: -math.pi / 4,
                      child: Image.asset(
                        "assets/images/flower1.png",
                        fit: BoxFit.contain, // ပုံမပြတ်သွားအောင် contain သုံး
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Expanded(
              child: FutureBuilder<List<Product>>(
              future: service.fetchProducts(), // Supabase ကနေ data ခေါ်မယ်
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No products found"));
                }

                final products = snapshot.data!;
              return GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75, // Grid card လေးတွေ ရှည်ရှည်လေးဖြစ်အောင်
                ), 
                itemBuilder: (context,index){
                  final product = products[index];
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10), // အပေါ်ကနေ နည်းနည်းခွာမယ်
                          width: 130,  // ဒီမှာ width ကို ၁၀၀ လို့ သတ်မှတ်ပါ
                          height: 170, // height ကိုလည်း ၁၀၀ လို့ သတ်မှတ်ပါ
                          // child: ClipRRect(
                          //   borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product.image_url,
                              fit: BoxFit.cover, // ပုံကို box ထဲ ကွက်တိဝင်အောင် ညှိပေးတယ်
                            ),
                          // ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 7),
                              Text("${product.price} MMK"),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _showAddtoCartDialog,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink.shade50, // အရောင်နုနုလေးပြောင်းလိုက်ရင် ပိုလှပါတယ်
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: Text("Add", style: TextStyle(color: Colors.pink.shade400, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        // Expanded(
                        //   flex: 1, // စာသားနဲ့ button ကို နေရာ ၂ ပုံ ပေးမယ်
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Text(
                        //           product.name,
                                  
                        //           maxLines: 1,
                        //           overflow: TextOverflow.ellipsis, // နာမည်ရှည်ရင် ... နဲ့ ဖြတ်မယ်
                        //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        //         ),
                        //         Text(
                        //           "\$ ${product.price} ",
                        //           style: TextStyle(color: Colors.pink.shade400, fontWeight: FontWeight.w600),
                        //         ),
                        //         SizedBox(
                        //           width: double.infinity,
                        //           height: 30,
                        //           child: ElevatedButton(
                        //             onPressed: _showAddtoCartDialog,
                        //             style: ElevatedButton.styleFrom(
                        //               backgroundColor: Colors.pink.shade50, // အရောင်နုနုလေးပြောင်းလိုက်ရင် ပိုလှပါတယ်
                        //               elevation: 0,
                        //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        //             ),
                        //             child: Text("Add", style: TextStyle(color: Colors.pink.shade400, fontSize: 12)),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ]
                    ),
                  );
                },
              );
              },
            ),
            ),
          ],
        ),
      ),
          // Shopping Cart Icon နဲ့ အရေအတွက်ပြတဲ့နေရာ
      floatingActionButton: Stack(
        alignment: Alignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartOrder(),
                )
              );
            },
            backgroundColor: Colors.pink.shade100,
            child: Icon(Icons.shopping_cart),
          ),
          if (cartCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  '$cartCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


