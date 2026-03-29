import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/widget/UrgentOrdersCard.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/widget/header_order.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/widget/order_card.dart'; // الكود القديم (المجدولة)
import 'package:drever_warr/features/my_tripe/preasntaion/view/start_tripe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drever_warr/core/constant/app_colors.dart';

enum OrderButtonStatus { accept, accepted }

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // تعريف 2 تبويب، والبدء بتبويب "الفورية" (Index 0)
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    // إضافة مستمع (Listener) لتحديث الواجهة عند تغيير التبويب يدوياً
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // الهيدر العلوي
            HeaderOrder(onMenuTap: () {}, con: true),

            SizedBox(height: 20.h),

            // التبويبات (Tabs)
            _buildTabs(),

            SizedBox(height: 10.h),

            // محتوى القوائم بناءً على التبويب المختار
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // 1. قائمة الطلبات الفورية (التي صممناها للتو)
                  _buildUrgentOrdersList(),

                  // 2. قائمة الطلبات المجدولة (الكود القديم الخاص بك)
                  _buildScheduledOrdersList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent, // نلغي المؤشر الافتراضي
          dividerColor: Colors.transparent,
          labelColor: AppColors.main1,
          unselectedLabelColor: Colors.black,
          tabs: [
            _buildTab(title: "urgent_orders", index: 0),
            _buildTab(title: "scheduled_orders", index: 1),
          ],
        ),
      ],
    );
  }

  Widget _buildTab({required String title, required int index}) {
    final bool isSelected = _tabController.index == index;

    return Tab(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(title, type: AppTextType.titleSmall),
          const SizedBox(height: 6),

          // الخط (رمادي + بنفسجي بنفس المكان)
          Stack(
            alignment: Alignment.center,
            children: [
              // الخط الرمادي (دائم)
              Container(
                height: 4,
                width: 80.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // الخط البنفسجي (فقط عند التحديد)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 4,
                width: isSelected ? 80.w : 0,
                decoration: BoxDecoration(
                  color: AppColors.main1,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // قائمة الطلبات الفورية
  Widget _buildUrgentOrdersList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      physics: const BouncingScrollPhysics(),
      itemCount: 5, // عدد تجريبي
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LiveTripScreen()),
            );
          },
          child: UrgentOrdersCard(
            buttonStatus: index == 0
                ? OrderButtonStatus.accept
                : OrderButtonStatus.accepted,
          ),
        );
      },
    );
  }

  // قائمة الطلبات المجدولة
  Widget _buildScheduledOrdersList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      physics: const BouncingScrollPhysics(),
      itemCount: 3, // عدد تجريبي
      itemBuilder: (context, index) {
        return OrderCard(buttonStatus: OrderButtonStatus.accepted);
      },
    );
  }
}
