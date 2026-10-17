import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const NakhlanApp());

const forest = Color(0xFF063B25);
const gold = Color(0xFFE6B84F);
const cream = Color(0xFFFFFBF1);
const shopEitaa = 'https://eitaa.com/NakhlanDates';
const managerEitaa = 'https://eitaa.com/Svelayat_z';
const instagram = 'https://www.instagram.com/nakhlandates?vrfl=MW5vMG5yN256a2J1OA==';
const shopAddress = 'قم، خیابان آذر، بعد از کوچه ۶۹ (پامنار)، داخل گاراژ سبزی، سرای خرمای نخلان';

Future<void> openExternal(String value) async {
  await launchUrl(Uri.parse(value), mode: LaunchMode.externalApplication);
}

class Product {
  final String name, category, weight, image;
  final int price;
  const Product(this.name, this.category, this.price, this.weight, this.image);
}

const products = <Product>[
  Product('خرمای مضافتی', 'خرما', 125000, '۱ کیلوگرم', 'https://images.unsplash.com/photo-1596591606975-97ee5cef3a1e?w=700&q=85'),
  Product('خرمای پیارم', 'خرما', 185000, '۱ کیلوگرم', 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=700&q=85'),
  Product('خرمای کبکاب', 'خرما', 95000, '۱ کیلوگرم', 'https://images.unsplash.com/photo-1577234286642-fc512a5f8f11?w=700&q=85'),
  Product('خرمای زاهدی', 'خرما', 78000, '۱ کیلوگرم', 'https://images.unsplash.com/photo-1604495772376-9657f0035eb5?w=700&q=85'),
  Product('خرمای خاصویی', 'خرما', 145000, '۱ کیلوگرم', 'https://images.unsplash.com/photo-1596591606975-97ee5cef3a1e?w=700&q=85'),
  Product('خرمای استعمران', 'خرما', 88000, '۱ کیلوگرم', 'https://images.unsplash.com/photo-1577234286642-fc512a5f8f11?w=700&q=85'),
  Product('جعبه هدیه نخلان', 'هدیه و بسته‌بندی', 320000, '۱ بسته', 'https://images.unsplash.com/photo-1513201099705-a9746e1e201f?w=700&q=85'),
  Product('شیره خرما', 'محصولات جانبی', 115000, '۷۰۰ گرم', 'https://images.unsplash.com/photo-1587049352851-8d4e89133924?w=700&q=85'),
];

class NakhlanApp extends StatelessWidget {
  const NakhlanApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false, title: 'سرای خرمای نخلان',
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(seedColor: forest, primary: forest, secondary: gold)),
    home: const Store(),
  );
}

class Store extends StatefulWidget {
  const Store({super.key});
  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  int tab = 0;
  String category = 'همه', query = '';
  final Map<Product, int> cart = {};
  int get totalCount => cart.values.fold(0, (a, b) => a + b);
  int get totalPrice => cart.entries.fold(0, (a, e) => a + e.key.price * e.value);
  List<Product> get filtered => products.where((p) =>
    (category == 'همه' || p.category == category) && p.name.contains(query)).toList();

  @override
  Widget build(BuildContext context) => Directionality(textDirection: TextDirection.rtl, child: Scaffold(
    appBar: AppBar(backgroundColor: forest, foregroundColor: Colors.white,
      title: Row(children: [
        Image.asset('assets/nakhlan_logo.png', width: 42, height: 42, fit: BoxFit.contain),
        const SizedBox(width: 8), const Expanded(child: Text('سرای خرمای نخلان', style: TextStyle(color: gold, fontWeight: FontWeight.bold))),
      ]),
      actions: [IconButton(onPressed: () => setState(() => tab = 2),
        icon: Badge(label: Text('$totalCount'), child: const Icon(Icons.shopping_cart_outlined)))],
    ),
    body: [home(), catalog(), basket(), contact()][tab],
    bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: (v) => setState(() => tab = v),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'خانه'),
        NavigationDestination(icon: Icon(Icons.grid_view), label: 'محصولات'),
        NavigationDestination(icon: Icon(Icons.shopping_bag_outlined), label: 'سبد خرید'),
        NavigationDestination(icon: Icon(Icons.contact_phone_outlined), label: 'ارتباط با ما'),
      ]),
  ));

  Widget home() => ListView(padding: const EdgeInsets.all(14), children: [
    Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(
      color: forest, borderRadius: BorderRadius.circular(22)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('خرما؛ هدیه طبیعت', style: TextStyle(color: gold, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8), const Text('انتخابی اصیل از نخلستان برای خانه و کسب‌وکار شما',
          style: TextStyle(color: Colors.white, height: 1.7)),
        const SizedBox(height: 12), FilledButton(onPressed: () => setState(() => tab = 1),
          child: const Text('مشاهده محصولات')),
      ])),
    const SizedBox(height: 18), const Text('محصولات منتخب', style: TextStyle(fontSize: 20, color: forest, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8), ...products.take(4).map(productTile),
    const Card(child: ListTile(leading: Icon(Icons.verified_outlined), title: Text('کیفیت منتخب'), subtitle: Text('مناسب خرید خرده و عمده'))),
  ]);

  Widget catalog() => ListView(padding: const EdgeInsets.all(14), children: [
    TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'جست‌وجوی محصولات'),
      onChanged: (v) => setState(() => query = v)),
    const SizedBox(height: 10),
    Wrap(spacing: 6, children: ['همه', 'خرما', 'هدیه و بسته‌بندی', 'محصولات جانبی'].map((c) =>
      ChoiceChip(label: Text(c), selected: category == c, onSelected: (_) => setState(() => category = c)).toList()),
    const SizedBox(height: 10), ...filtered.map(productTile),
  ]);

  Widget productTile(Product p) => Card(margin: const EdgeInsets.only(bottom: 10), child: Padding(
    padding: const EdgeInsets.all(10), child: Row(children: [
      ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(p.image, width: 82, height: 82, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(width: 82, height: 82, color: const Color(0xFFF4E8C9),
          child: const Icon(Icons.photo_outlined, color: forest)))),
      const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(p.weight, style: const TextStyle(color: Colors.black54)),
        Text('${money(p.price)} تومان', style: const TextStyle(color: forest, fontWeight: FontWeight.bold)),
      ])),
      IconButton(onPressed: () => setState(() => cart[p] = (cart[p] ?? 0) + 1),
        icon: const Icon(Icons.add_shopping_cart, color: forest)),
    ])));

  Widget basket() => cart.isEmpty ? const Center(child: Text('سبد خرید شما خالی است')) :
    ListView(padding: const EdgeInsets.all(14), children: [
      const Text('سبد خرید شما', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: forest)),
      ...cart.entries.map((e) => ListTile(title: Text(e.key.name),
        subtitle: Text('${money(e.key.price)} تومان'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(onPressed: () => setState(() { if (e.value <= 1) { cart.remove(e.key); } else { cart[e.key] = e.value - 1; } }),
            icon: const Icon(Icons.remove_circle_outline)),
          Text('${e.value}'),
          IconButton(onPressed: () => setState(() => cart[e.key] = e.value + 1), icon: const Icon(Icons.add_circle_outline)),
        ]))),
      Text('جمع کالاها: ${money(totalPrice)} تومان', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 12), FilledButton(onPressed: orderDialog, child: const Text('هماهنگی سفارش در ایتا')),
      const Text('قیمت‌ها از نسخه قبلی گرفته شده‌اند و باید پیش از انتشار تأیید شوند. سفارش خودکار در سرور ثبت نمی‌شود.',
        style: TextStyle(fontSize: 12, color: Colors.black54)),
    ]);

  Widget contact() => ListView(padding: const EdgeInsets.all(14), children: [
    const Text('سرای خرمای نخلان', style: TextStyle(fontSize: 23, color: forest, fontWeight: FontWeight.bold)),
    const SizedBox(height: 8), const Text('درصدد تأمین بهترین خرماهای دنیا با بهترین کیفیت و نازل‌ترین قیمت برای مشتریان خرده‌فروشی، عمده‌فروشی و سازمان‌هاست.'),
    const SizedBox(height: 14), const Text('راه‌های ارتباطی', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
    ListTile(leading: const Icon(Icons.phone), title: const Text('۰۲۵۳۷۷۲۰۲۷۷'), onTap: () => openExternal('tel:02537720277')),
    ListTile(leading: const Icon(Icons.phone_android), title: const Text('۰۹۱۹۰۴۱۴۷۷۹'), onTap: () => openExternal('tel:09190414779')),
    ListTile(leading: const Icon(Icons.phone_android), title: const Text('۰۹۱۲۷۴۷۳۳۸۵'), onTap: () => openExternal('tel:09127473385')),
    const ListTile(leading: Icon(Icons.location_on_outlined), title: Text('نشانی فروشگاه'), subtitle: Text(shopAddress)),
    ListTile(leading: const Icon(Icons.send), title: const Text('ایتا | صفحه فروشگاه'), onTap: () => openExternal(shopEitaa)),
    ListTile(leading: const Icon(Icons.chat), title: const Text('ارتباط مستقیم با مدیریت در ایتا'), onTap: () => openExternal(managerEitaa)),
    ListTile(leading: const Icon(Icons.camera_alt_outlined), title: const Text('اینستاگرام نخلان'), onTap: () => openExternal(instagram)),
  ]);

  void orderDialog() {
    final name = TextEditingController(), phone = TextEditingController(), address = TextEditingController();
    final summary = cart.entries.map((e) => '${e.key.name} × ${e.value}').join('\n');
    final message = 'سلام، برای سفارش از سرای خرمای نخلان:\n$summary\nجمع کالاها: ${money(totalPrice)} تومان';
    showDialog(context: context, builder: (ctx) => Directionality(textDirection: TextDirection.rtl, child: AlertDialog(
      title: const Text('اطلاعات سفارش'),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: name, decoration: const InputDecoration(labelText: 'نام و نام خانوادگی')),
        TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'شماره تماس')),
        TextField(controller: address, maxLines: 2, decoration: const InputDecoration(labelText: 'نشانی تحویل')),
        const SizedBox(height: 8), const Text('ایتا باز می‌شود؛ برای ارسال، متن سفارش را در گفت‌وگو وارد کنید.', style: TextStyle(fontSize: 12)),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('بازگشت')),
        FilledButton(onPressed: () async {
          if (name.text.trim().isEmpty || phone.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('نام و شماره تماس را وارد کنید.')));
            return;
          }
          Navigator.pop(ctx);
          await openExternal(managerEitaa);
          if (!mounted) return;
          showDialog(context: context, builder: (c) => Directionality(textDirection: TextDirection.rtl,
            child: AlertDialog(title: const Text('متن سفارش برای ارسال'), content: SelectableText(
              '$message\nنام: ${name.text}\nتلفن: ${phone.text}\nنشانی: ${address.text}'),
              actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('بستن'))])));
        }, child: const Text('باز کردن ایتا')),
      ],
    )));
  }
}

String money(int n) => n.toString().replaceAllMapped(RegExp(r'\\B(?=(\\d{3})+(?!\\d))'), (_) => ',');
    
