import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(const MyApp());

List<Map<String, dynamic>> cartItems = [];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UAS Mobile Programming',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

// --- 1. HALAMAN LOGIN ---
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_app.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.shopping_bag, size: 100, color: Colors.green),
              ),
              const SizedBox(height: 20),
              const Text(
                "Selamat Datang",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Silakan login untuk belanja",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 50),
              TextField(
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  ),
                  child: const Text("MASUK", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Belum punya akun? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("Pindah ke halaman daftar");
                    },
                    child: const Text(
                      "Daftar sekarang",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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

// --- 2. HALAMAN UTAMA ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<String> categories = ["Laptop", "Handphone", "Headset", "Charger", "Jam Tangan"];

  Future<List<Map<String, String>>> loadXmlData() async {
    final rawData = await rootBundle.loadString('assets/items.xml');
    final document = xml.XmlDocument.parse(rawData);
    return document.findAllElements('item').map((node) {
      return {
        'id': node.findElements('id').first.innerText,
        'nama': node.findElements('nama').first.innerText,
        'harga': node.findElements('harga').first.innerText,
        'image': 'assets/produk${node.findElements('id').first.innerText}.jpg',
        'deskripsi': node.findElements('deskripsi').isNotEmpty
            ? node.findElements('deskripsi').first.innerText
            : "Tidak ada deskripsi",
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentBody;
    switch (_selectedIndex) {
      case 2:
        currentBody = const CartPage();
        break;
      default:
        currentBody = buildMainHome();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.favorite_border, size: 22), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person_outline, size: 22), onPressed: () {}),
        ],
      ),
      body: currentBody,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF1E1E1E),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Activity"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        ],
      ),
    );
  }

  Widget buildMainHome() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade800, Colors.grey.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("UAS Mobile Programming",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 5),
                  Text("Fazar Rizwanul Ikhlas - e-commerce gadget",
                      style: TextStyle(fontSize: 12, color: Colors.white70)),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Kategori", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
                        child: Icon(getIcon(categories[index]), color: Colors.green),
                      ),
                      const SizedBox(height: 4),
                      Text(categories[index], style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("Produk Pilihan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          FutureBuilder(
            future: loadXmlData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final data = snapshot.data as List<Map<String, String>>;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailPage(item: data[index])),
                    ),
                    child: Card(
                      color: Colors.grey[900],
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              color: Colors.white10,
                              child: Image.asset(
                                data[index]['image']!,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(Icons.image, color: Colors.grey),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index]['nama']!,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rp ${data[index]['harga']}",
                                  style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  IconData getIcon(String category) {
    switch (category) {
      case "Laptop": return Icons.laptop;
      case "Handphone": return Icons.phone_android;
      case "Headset": return Icons.headset;
      case "Charger": return Icons.electrical_services;
      case "Jam Tangan": return Icons.watch;
      default: return Icons.category;
    }
  }
}

// --- 3. HALAMAN DETAIL ---
class DetailPage extends StatefulWidget {
  final Map<String, String> item;
  const DetailPage({super.key, required this.item});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String selectedColor = "Hitam";
  bool isFavorite = false;

  void addToCart() {
    setState(() {
      int index = cartItems.indexWhere((i) => i['nama'] == widget.item['nama'] && i['variasi'] == selectedColor);
      if (index != -1) {
        cartItems[index]['qty']++;
      } else {
        cartItems.add({
          'nama': widget.item['nama'],
          'harga': int.parse(widget.item['harga']!.replaceAll('.', '')),
          'image': widget.item['image'],
          'qty': 1,
          'variasi': selectedColor,
        });
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Masuk keranjang!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.white),
            onPressed: () => setState(() => isFavorite = !isFavorite),
          )
        ],
      ),
      body: Column(
        children: [
          Image.asset(widget.item['image']!, height: 250, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image, size: 100)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.item['nama']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text("Rp ${widget.item['harga']}", style: const TextStyle(fontSize: 20, color: Colors.green)),
                const SizedBox(height: 15),
                const Text("Variasi Warna:"),
                Row(
                  children: ["Hitam", "Silver", "Blue"].map((c) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: selectedColor == c,
                      onSelected: (s) => setState(() => selectedColor = c),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 15),
                Text(widget.item['deskripsi']!),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: addToCart, child: const Text("Keranjang"))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white), onPressed: addToCart, child: const Text("Beli"))),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// --- 4. HALAMAN KERANJANG ---
class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    int total = cartItems.fold(0, (sum, item) => sum + (item['harga'] as int) * (item['qty'] as int));
    return Scaffold(
      body: cartItems.isEmpty
          ? const Center(child: Text("Keranjang masih kosong"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var item = cartItems[index];
                return ListTile(
                  leading: Image.asset(item['image'], width: 50, errorBuilder: (c, e, s) => const Icon(Icons.image)),
                  title: Text(item['nama']),
                  subtitle: Text("${item['variasi']} | Rp ${item['harga']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => setState(() {
                            if (item['qty'] > 1) item['qty']--;
                            else cartItems.removeAt(index);
                          })),
                      Text("${item['qty']}"),
                      IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () => setState(() => item['qty']++)),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey[900],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total: Rp $total",
                    style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () {
                    if (cartItems.isEmpty) return;

                    showDialog(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text("Sukses"),
                        content: const Text("Pembelian Berhasil!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                cartItems.clear();
                              });
                              Navigator.pop(c);
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Checkout"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}