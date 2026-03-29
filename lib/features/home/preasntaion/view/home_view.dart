import 'package:drever_warr/features/home/preasntaion/view/menew.dart';
import 'package:drever_warr/features/home/preasntaion/widget/header_home_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // إعدادات الخريطة الأولية (مثلاً مدينة اللاذقية كما في الصورة)
  // static const CameraPosition _kLatakia = CameraPosition(
  //   target: LatLng(35.5112, 35.7908),
  //   zoom: 14.4746,
  // );

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        drawerScrimColor: Colors.transparent,
        key: _scaffoldKey, // ربط المفتاح هنا
        drawer: const MenueView(), // نضع صفحة المنيو كـ Drawer
        body: Column(
          children: [
            HeaderHomeView(
              onMenuTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),

            Expanded(
              child: Stack(
                children: [
                  // const GoogleMap(
                  //   initialCameraPosition: _kLatakia,
                  //   mapType: MapType.normal,
                  //   zoomControlsEnabled: false,
                  //   myLocationButtonEnabled: false,
                  // ),

                  // أيقونة السيارة (كمثال توضيحي فوق الخريطة)

                  // زر الطوارئ (المثلث الأحمر) في الأسفل
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
