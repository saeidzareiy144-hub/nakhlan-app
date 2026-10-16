import 'package:flutter/material.dart';

void main() => runApp(const NakhlanApp());

const forest = Color(0xFF063B25);
const deepForest = Color(0xFF032719);
const gold = Color(0xFFE6B84F);
const cream = Color(0xFFFFFBF1);

class Product {
  final String name;
  final String category;
  final int price;
  final String weight;
  final String emoji;
  final bool ownBrand;
  const Product(this.name, this.category, this.price, this.weight, this.emoji,
      {this.ownBrand = true});
}

const products = <Product>[
  Product('خرمای مضافتی', 'خرما', 125000, '۱ کیلوگرم', '🌑'),
  Product('خرمای پیارم', 'خرما', 185000, '۱ کیلوگرم', '🟤'),
  Product('خرمای کبکاب', 'خرما', 95000, '۱ کیلوگرم', '🟠'),
  Product('خرمای زاهدی', 'خرما', 78000, '۱ کیلوگرم', '🟡'),
  Product('خرمای خاصویی', 'خرما', 145000, '۱ کیلوگرم', '🟤'),
  Product('خرمای استعمران', 'خرما', 88000, '۱ کیلوگرم', '🟤', ownBrand: false),
  Product('جعبه هدیه نخلان', 'هدیه و بسته‌بندی', 320000, '۱ بسته', '🎁'),
  Product('شیره خرما', 'محصولات جانبی', 115000, '۷۰۰ گرم', '🍯', ownBrand: false),
];

class NakhlanApp extends StatelessWidget {
  const NakhlanApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'نخلان | طعم اصالت',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: cream,
          colorScheme: ColorScheme.fromSeed(seedColor: forest, primary: forest, secondary: gold),
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(backgroundColor: forest, foregroundColor: Colors.white),
        ),
        home: const StoreShell(),
      );
}

class StoreShell extends StatefulWidget {
  const StoreShell({super.key});
  @override
  State<StoreShell> createState() => _StoreShellState();
}

class _StoreShellState extends State<StoreShell> {
  int tab = 0;
  final Map<Product, int> cart = {};
  String query = '';
  String category = 'همه';

  int get cartCount => cart.values.fold(0, (a, b) => a + b);
  void add(Product p) => setState(() => cart[p] = (cart[p] ?? 0) + 1);
  void changeQty(Product p, int delta) => setState(() {
        final next = (cart[p] ?? 0) + delta;
        if (next <= 0) { cart.remove(p); } else { cart[p] = next; }
      });

  @override
  Widget build(BuildContext context) {
    final pages = [
      homePage(),
      categoryPage(),
      cartPage(),
      accountPage(),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Image.asset('assets/nakhlan_logo.png', height: 42, width: 48, fit: BoxFit.contain),
            const SizedBox(width: 8),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('نخلان', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: gold)),
              Text('طعم اصالت، از دل نخلستان', style: TextStyle(fontSize: 10, color: Colors.white70)),
            ]),
          ]),
          actions: [IconButton(onPressed: () => setState(() => tab = 2), icon: Badge(label: Text('$cartCount'), child: const Icon(Icons.shopping_cart_outlined)) )],
        ),
        body: pages[tab],
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          indicatorColor: gold.withOpacity(.25),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'خانه'),
            NavigationDestination(icon: Icon(Icons.grid_view_outlined), label: 'دسته‌بندی'),
            NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'سبد خرید'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'حساب کاربری'),
          ],
        ),
      ),
    );
  }

  Widget homePage() {
    final filtered = filteredProducts();
    return ListView(padding: const EdgeInsets.all(14), children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(colors: [deepForest, forest], begin: Alignment.topRight, end: Alignment.bottomLeft),
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('خیرما؛ هدیه طبیعت', style: TextStyle(color: gold, fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('انتخابی اصیل از نخلستان برای خانه و کسب‌وکار شما', style: TextStyle(color: Colors.white, height: 1.6)),
            const SizedBox(height: 14),
            FilledButton.icon(onPressed: () => setState(() => tab = 1), icon: const Icon(Icons.arrow_back), label: const Text('مشاهده محصولات'), style: FilledButton.styleFrom(backgroundColor: gold, foregroundColor: deepForest)),
          ])),
          const SizedBox(width: 8),
          const Text('🌴\n🧺', textAlign: TextAlign.center, style: TextStyle(fontSize: 48)),
        ]),
      ),
      const SizedBox(height: 14),
      const Row(children: [Expanded(child: Feature(icon: Icons.local_shipping_outlined, title: 'ارسال سراسری', subtitle: 'در سراسر ایران')), SizedBox(width: 8), Expanded(child: Feature(icon: Icons.verified_outlined, title: 'کیفیت منتخب', subtitle: 'با دقت انتخاب‌شده'))]),
      const SizedBox(height: 20),
      const SectionTitle('دسته‌بندی محصولات'),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: ['همه', 'خرما', 'هدیه و بسته‌بندی', 'محصولات جانبی'].map((c) => ChoiceChip(label: Text(c), selected: category == c, onSelected: (_) => setState(() { category = c; tab = 1; })).toList()),
      const SizedBox(height: 20),
      const SectionTitle('محصولات منتخب'),
      const SizedBox(height: 8),
      if (filtered.isEmpty) const Text('محصولی پیدا نشد.'),
      ...filtered.take(6).map(productCard),
      const SizedBox(height: 10),
      Card(color: forest, child: ListTile(leading: const Icon(Icons.storefront, color: gold, size: 34), title: const Text('خرید عمده و همکاری', style: TextStyle(color: gold, fontWeight: FontWeight.bold)), subtitle: const Text('برای دریافت قیمت ویژه عمده درخواست خود را ثبت کنید.', style: TextStyle(color: Colors.white)), trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white), onTap: wholesaleDialog)),
    ]);
  }

  Widget categoryPage() => ListView(padding: const EdgeInsets.all(14), children: [
    TextField(decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'جست‌وجوی محصولات نخلان...', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none)), onChanged: (v) => setState(() => query = v)),
    const SizedBox(height: 12),
    Wrap(spacing: 8, children: ['همه', 'خرما', 'هدیه و بسته‌بندی', 'محصولات جانبی'].map((c) => ChoiceChip(label: Text(c), selected: category == c, onSelected: (_) => setState(() => category = c)).toList()),
    const SizedBox(height: 12),
    ...filteredProducts().map(productCard),
  ]);

  List<Product> filteredProducts() => products.where((p) => (category == 'همه' || p.category == category) && p.name.contains(query)).toList();

  Widget productCard(Product p) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    elevation: 1,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
      Container(width: 76, height: 76, alignment: Alignment.center, decoration: BoxDecoration(color: const Color(0xFFF4E8C9), borderRadius: BorderRadius.circular(13)), child: Text(p.emoji, style: const TextStyle(fontSize: 39))),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text('${p.weight} • ${p.ownBrand ? 'محصول نخلان' : 'تأمین‌کننده منتخب'}', style: const TextStyle(color: Colors.black54, fontSize: 12)), const SizedBox(height: 6), Text('${money(p.price)} تومان', style: const TextStyle(color: forest, fontWeight: FontWeight.bold))])),
      IconButton.filled(onPressed: () { add(p); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} به سبد خرید اضافه شد'), duration: const Duration(seconds: 1))); }, icon: const Icon(Icons.add_shopping_cart), style: IconButton.styleFrom(backgroundColor: gold, foregroundColor: deepForest)),
    ])),
  );

  Widget cartPage() {
    final entries = cart.entries.toList();
    final total = entries.fold<int>(0, (sum, e) => sum + e.key.price * e.value);
    if (entries.isEmpty) return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.shopping_cart_outlined, size: 64, color: forest), SizedBox(height: 12), Text('سبد خرید شما خالی است') ]));
    return ListView(padding: const EdgeInsets.all(14), children: [
      const SectionTitle('سبد خرید شما'), const SizedBox(height: 10),
      ...entries.map((e) => Card(child: ListTile(leading: Text(e.key.emoji, style: const TextStyle(fontSize: 30)), title: Text(e.key.name), subtitle: Text('${money(e.key.price)} تومان'), trailing: Row(mainAxisSize: MainAxisSize.min, children: [IconButton(onPressed: () => changeQty(e.key, -1), icon: const Icon(Icons.remove_circle_outline)), Text('${e.value}'), IconButton(onPressed: () => changeQty(e.key, 1), icon: const Icon(Icons.add_circle_outline))])))),
      const SizedBox(height: 12),
      Text('جمع کالاها: ${money(total)} تومان', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      FilledButton(onPressed: checkoutDialog, style: FilledButton.styleFrom(backgroundColor: forest, padding: const EdgeInsets.all(15)), child: const Text('ثبت سفارش')),
      const Text('این نسخه نمایشی است؛ سفارش‌ها هنوز به سرور ارسال نمی‌شوند.', style: TextStyle(color: Colors.black54, fontSize: 12)),
    ]);
  }

  Widget accountPage() => ListView(padding: const EdgeInsets.all(14), children: [
    Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: forest, borderRadius: BorderRadius.circular(18)), child: const Column(children: [Icon(Icons.account_circle_outlined, size: 58, color: gold), SizedBox(height: 8), Text('به فروشگاه نخلان خوش آمدید', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), Text('برای سفارش عمده یا پیگیری خرید با ما در ارتباط باشید.', style: TextStyle(color: Colors.white70), textAlign: TextAlign.center)])),
    const SizedBox(height: 12),
    ListTile(leading: const Icon(Icons.storefront, color: forest), title: const Text('درخواست خرید عمده'), trailing: const Icon(Icons.chevron_left), onTap: wholesaleDialog),
    ListTile(leading: const Icon(Icons.phone, color: forest), title: const Text('تماس با نخلان'), subtitle: const Text('شماره تماس بعداً در تنظیمات فروشگاه اضافه می‌شود.')),
    ListTile(leading: const Icon(Icons.info_outline, color: forest), title: const Text('درباره نخلان'), subtitle: const Text('طعم اصالت، از دل نخلستان')),
  ]);

  void wholesaleDialog() {
    final name = TextEditingController(); final phone = TextEditingController(); final company = TextEditingController();
    showDialog(context: context, builder: (_) => Directionality(textDirection: TextDirection.rtl, child: AlertDialog(title: const Text('درخواست خرید عمده'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('اطلاعات زیر در این نسخه فقط برای نمایش فرم است.'), const SizedBox(height: 10), TextField(controller: name, decoration: const InputDecoration(labelText: 'نام و نام خانوادگی')), TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'شماره تماس')), TextField(controller: company, decoration: const InputDecoration(labelText: 'نام فروشگاه یا شرکت (اختیاری'))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('بستن')), FilledButton(onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('فرم نمایشی است و هنوز ارسال واقعی فعال نیست.'))); }, child: const Text('ثبت درخواست'))])));
  }

  void checkoutDialog() {
    final name = TextEditingController(); final phone = TextEditingController(); final address = TextEditingController();
    showDialog(context: context, builder: (_) => Directionality(textDirection: TextDirection.rtl, child: AlertDialog(title: const Text('اطلاعات سفارش'), content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: name, decoration: const InputDecoration(labelText: 'نام و نام خانوادگی')), TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'شماره تماس')), TextField(controller: address, maxLines: 2, decoration: const InputDecoration(labelText: 'نشانی تحویل'))])), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('بازگشت')), FilledButton(onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ثبت آنلاین سفارش در نسخه بعدی فعال می‌شود.'))); }, child: const Text('ادامه'))])));
  }
}

class Feature extends StatelessWidget {
  final IconData icon; final String title; final String subtitle;
  const Feature({super.key, required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Row(children: [Icon(icon, color: forest, size: 27), const SizedBox(width: 8), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)), Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.black54))]))]));
}

class SectionTitle extends StatelessWidget {
  final String title; const SectionTitle(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: forest));
}

String money(int n) => n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
