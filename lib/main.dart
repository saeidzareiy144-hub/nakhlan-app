
import 'package:flutter/material.dart';

void main() {
  runApp(const NakhlanApp());
}

const Color darkGreen = Color(0xFF123D30);
const Color green = Color(0xFF1D6049);
const Color gold = Color(0xFFD6AD55);
const Color pageColor = Color(0xFFF5F6F2);
const Color textColor = Color(0xFF26352E);

class NakhlanApp extends StatelessWidget {
  const NakhlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مدیریت نخلان',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pageColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: darkGreen,
          primary: darkGreen,
          secondary: gold,
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const ManagementHome(),
    );
  }
}

class ManagementHome extends StatefulWidget {
  const ManagementHome({super.key});

  @override
  State<ManagementHome> createState() => _ManagementHomeState();
}

class _ManagementHomeState extends State<ManagementHome> {
  int selectedPage = 0;
  String selectedRole = 'مدیر کل';

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'داشبورد مدیریت', 'icon': Icons.dashboard_outlined},
    {'title': 'مدیریت ویزیتورها', 'icon': Icons.groups_outlined},
    {'title': 'مدیریت مشتریان', 'icon': Icons.people_outline},
    {'title': 'مدیریت سفارش‌ها', 'icon': Icons.shopping_bag_outlined},
    {'title': 'مدیریت انبار', 'icon': Icons.warehouse_outlined},
    {'title': 'امور مالی', 'icon': Icons.account_balance_wallet_outlined},
    {'title': 'پورسانت و عملکرد', 'icon': Icons.trending_up},
    {'title': 'گزارش‌های مدیریتی', 'icon': Icons.bar_chart},
  ];

  void changePage(int index) {
    setState(() => selectedPage = index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.spa, color: gold, size: 27),
            const SizedBox(width: 9),
            const Text(
              'سرای خرمای نخلان',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle_outlined),
            onSelected: (value) {
              setState(() => selectedRole = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'مدیر کل',
                child: Text('مدیر کل'),
              ),
              const PopupMenuItem(
                value: 'انباردار',
                child: Text('انباردار'),
              ),
              const PopupMenuItem(
                value: 'ویزیتور',
                child: Text('ویزیتور'),
              ),
            ],
          ),
          const SizedBox(width: 5),
        ],
      ),
      drawer: buildDrawer(),
      body: SafeArea(
        child: IndexedStack(
          index: selectedPage,
          children: [
            DashboardPage(onNavigate: (i) {
              setState(() => selectedPage = i);
            }),
            const VisitorsPage(),
            const CustomersPage(),
            const OrdersPage(),
            const InventoryPage(),
            const FinancePage(),
            const CommissionPage(),
            const ReportsPage(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPage <= 4 ? selectedPage : 0,
        onDestinationSelected: (index) {
          setState(() => selectedPage = index);
        },
        backgroundColor: Colors.white,
        indicatorColor: gold.withOpacity(0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'خانه',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            label: 'ویزیتورها',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'مشتریان',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'سفارش‌ها',
          ),
          NavigationDestination(
            icon: Icon(Icons.warehouse_outlined),
            label: 'انبار',
          ),
        ],
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 45, 20, 25),
            decoration: const BoxDecoration(
              color: darkGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: gold,
                  child: Icon(
                    Icons.spa,
                    color: darkGreen,
                    size: 38,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'سرای خرمای نخلان',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'سامانه جامع مدیریت کسب‌وکار',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                final selected = selectedPage == index;

                return ListTile(
                  selected: selected,
                  selectedTileColor: gold.withOpacity(0.15),
                  leading: Icon(
                    item['icon'] as IconData,
                    color: selected ? darkGreen : Colors.grey.shade700,
                  ),
                  title: Text(
                    item['title'] as String,
                    style: TextStyle(
                      color: selected ? darkGreen : textColor,
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  onTap: () => changePage(index),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'نسخه اولیه سامانه نخلان',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final ValueChanged<int> onNavigate;

  const DashboardPage({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [darkGreen, green],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'به سامانه مدیریت نخلان خوش آمدید',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              SizedBox(height: 10),
              Text(
                'مدیریت یکپارچه کسب‌وکار',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.verified_user, color: gold, size: 17),
                  SizedBox(width: 6),
                  Text(
                    'پنل مدیریت',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const SectionTitle(title: 'نمای کلی کسب‌وکار'),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.45,
          children: const [
            StatCard(
              title: 'ویزیتورها',
              value: '۵ نفر',
              icon: Icons.groups,
              color: green,
            ),
            StatCard(
              title: 'مشتریان',
              value: '۵۰۰ نفر',
              icon: Icons.people,
              color: Colors.blueGrey,
            ),
            StatCard(
              title: 'سفارش‌های امروز',
              value: '۰',
              icon: Icons.shopping_bag,
              color: Colors.deepOrange,
            ),
            StatCard(
              title: 'موجودی انبار',
              value: 'نیازمند اتصال',
              icon: Icons.warehouse,
              color: Colors.teal,
            ),
          ],
        ),
        const SizedBox(height: 22),
        const SectionTitle(title: 'دسترسی سریع'),
        const SizedBox(height: 12),
        QuickAction(
          title: 'مدیریت ویزیتورها',
          subtitle: 'مشاهده و مدیریت اعضای تیم فروش',
          icon: Icons.groups_outlined,
          onTap: () => onNavigate(1),
        ),
        QuickAction(
          title: 'مدیریت مشتریان',
          subtitle: 'اطلاعات و سوابق مشتریان',
          icon: Icons.people_outline,
          onTap: () => onNavigate(2),
        ),
        QuickAction(
          title: 'سفارش‌ها',
          subtitle: 'بررسی و پیگیری سفارش‌های ثبت‌شده',
          icon: Icons.shopping_bag_outlined,
          onTap: () => onNavigate(3),
        ),
        QuickAction(
          title: 'انبار و موجودی',
          subtitle: 'مدیریت کالاها و وضعیت موجودی',
          icon: Icons.warehouse_outlined,
          onTap: () => onNavigate(4),
        ),
        QuickAction(
          title: 'امور مالی',
          subtitle: 'دریافت‌ها، بدهی‌ها و حساب مشتریان',
          icon: Icons.account_balance_wallet_outlined,
          onTap: () => onNavigate(5),
        ),
        QuickAction(
          title: 'پورسانت و عملکرد',
          subtitle: 'محاسبه کمیسیون و ارزیابی فروش',
          icon: Icons.trending_up,
          onTap: () => onNavigate(6),
        ),
        const SizedBox(height: 16),
        const Text(
          'توجه: اعداد و اطلاعات این نسخه نمایشی هستند و هنوز به سرور مرکزی متصل نشده‌اند.',
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: darkGreen,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 25),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: darkGreen,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class QuickAction extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const QuickAction({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: gold.withOpacity(0.17),
          child: Icon(icon, color: darkGreen),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: darkGreen,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11),
        ),
        trailing: const Icon(Icons.chevron_left, color: gold),
        onTap: onTap,
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<String> features;

  const SimplePage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: darkGreen,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(icon, color: gold, size: 38),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const SectionTitle(title: 'امکانات این بخش'),
        const SizedBox(height: 12),
        ...features.map(
          (feature) => Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 9),
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline, color: green),
              title: Text(
                feature,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: gold.withOpacity(0.13),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'این بخش در مرحله بعد به فرم‌ها، اطلاعات واقعی و پایگاه داده مرکزی متصل خواهد شد.',
            style: TextStyle(fontSize: 12, color: darkGreen),
          ),
        ),
      ],
    );
  }
}

class VisitorsPage extends StatelessWidget {
  const VisitorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'مدیریت ویزیتورها',
      description: 'مدیریت تیم فروش نخلان',
      icon: Icons.groups,
      features: [
        'تعریف و ثبت حساب کاربری ویزیتورها',
        'تخصیص مشتری به هر ویزیتور',
        'مشاهده سفارش‌های هر ویزیتور',
        'ثبت گزارش ملاقات و پیگیری مشتری',
        'بررسی عملکرد و رتبه‌بندی تیم فروش',
        'مدیریت سطح دسترسی کاربران',
      ],
    );
  }
}

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'مدیریت مشتریان',
      description: 'بانک اطلاعات مشتریان نخلان',
      icon: Icons.people,
      features: [
        'ثبت نام و اطلاعات تماس مشتری',
        'ثبت نشانی و موقعیت مشتری',
        'تعیین ویزیتور مسئول مشتری',
        'مشاهده تاریخچه سفارش‌ها',
        'ثبت بدهی و اعتبار مشتری',
        'ثبت یادداشت و زمان پیگیری بعدی',
      ],
    );
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'مدیریت سفارش‌ها',
      description: 'کنترل سفارش از ثبت تا تحویل',
      icon: Icons.shopping_bag,
      features: [
        'ثبت سفارش چندقلمی',
        'بررسی و تأیید سفارش توسط مدیر',
        'ارسال سفارش تأییدشده به انبار',
        'ثبت وضعیت آماده‌سازی و ارسال',
        'مدیریت تخفیف و سفارش اعتباری',
        'ثبت مرجوعی و اصلاح سفارش',
      ],
    );
  }
}

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'مدیریت انبار',
      description: 'کنترل موجودی و گردش کالا',
      icon: Icons.warehouse,
      features: [
        'تعریف کالا و کد محصول',
        'ثبت ورود و خروج کالا',
        'نمایش موجودی قابل سفارش',
        'ثبت رزرو کالا برای سفارش‌ها',
        'هشدار کمبود موجودی',
        'گزارش گردش و موجودی انبار',
      ],
    );
  }
}

class FinancePage extends StatelessWidget {
  const FinancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'امور مالی',
      description: 'مدیریت دریافت‌ها و حساب‌ها',
      icon: Icons.account_balance_wallet,
      features: [
        'ثبت دریافت نقدی و واریز بانکی',
        'ثبت فروش اعتباری',
        'مدیریت بدهی مشتریان',
        'ثبت پرداخت و تسویه حساب',
        'ثبت تخفیف با سطح مجوز مشخص',
        'گزارش فروش و مطالبات',
      ],
    );
  }
}

class CommissionPage extends StatelessWidget {
  const CommissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'پورسانت و عملکرد',
      description: 'ارزیابی و محاسبه کمیسیون فروش',
      icon: Icons.trending_up,
      features: [
        'تعریف جدول پورسانت پلکانی',
        'محاسبه پورسانت بر اساس فروش وصول‌شده',
        'تعیین هدف فروش ماهانه',
        'رتبه‌بندی ویزیتورها',
        'مقایسه عملکرد اعضای تیم',
        'گزارش پورسانت قابل پرداخت',
      ],
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimplePage(
      title: 'گزارش‌های مدیریتی',
      description: 'گزارش یکپارچه کسب‌وکار',
      icon: Icons.bar_chart,
      features: [
        'گزارش فروش روزانه و ماهانه',
        'گزارش عملکرد ویزیتورها',
        'گزارش موجودی و گردش انبار',
        'گزارش مشتریان فعال و غیرفعال',
        'گزارش بدهی‌ها و وصول مطالبات',
        'گزارش سود و پورسانت',
      ],
    );
  }
}
