import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customTextFieldsearch.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:drever_warr/features/preasntaion/widhets/regster.dart';
import 'package:drever_warr/features/preasntaion/widhets/row_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  State<AddLocation> createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  GoogleMapController? mapController;
  TextEditingController searchController = TextEditingController();

  
  LatLng _currentCameraPosition = const LatLng(37.0500, 41.2200);
  List<dynamic> _predictions = [];
  final String apiKey = "AIzaSyA-ACPNj6bCMyZjFLj-wSCWBOFH4ueB1FI";

  String _currentFullAddress = "جاري تحديد الموقع...";
  double? _lat;
  double? _lng;

  // 1. جلب العنوان من الإحداثيات (Reverse Geocoding)
  Future<void> _getAddressFromLatLng(LatLng position) async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'latlng': '${position.latitude},${position.longitude}',
          'key': apiKey,
          'language': 'ar',
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        var results = response.data['results'] as List;
        setState(() {
          _currentFullAddress = results[0]['formatted_address'];
          _lat = position.latitude;
          _lng = position.longitude;
        });
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
    }
  }

  
  Future<void> _getAutocompleteSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() => _predictions = []);
      return;
    }
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://maps.googleapis.com/api/place/autocomplete/json',
        queryParameters: {
          'input': input,
          'key': apiKey,
          'language': 'ar',
          'types': 'geocode',
        },
      );
      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        setState(() => _predictions = response.data['predictions']);
      }
    } catch (e) {
      debugPrint("Autocomplete Error: $e");
    }
  }

  
  Future<void> _searchAndNavigate([String? customAddress]) async {
    String address = customAddress ?? searchController.text.trim();
    if (address.isEmpty) return;

    final dio = Dio();
    try {
      final response = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {'address': address, 'key': apiKey, 'language': 'ar'},
      );
      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final location = response.data['results'][0]['geometry']['location'];
        LatLng target = LatLng(location['lat'], location['lng']);

        mapController?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));

        setState(() {
          _currentCameraPosition = target;
          _predictions = [];
          searchController.clear();
          _currentFullAddress =
              response.data['results'][0]['formatted_address'];
          _lat = target.latitude;
          _lng = target.longitude;
        });
        FocusScope.of(context).unfocus();
      }
    } catch (e) {
      debugPrint("Search Error: $e");
    }
  }

  
  void _onMapTap(LatLng tappedPoint) {
    setState(() {
      _currentCameraPosition = tappedPoint;
      _predictions = [];  
    });
    mapController?.animateCamera(CameraUpdate.newLatLng(tappedPoint));
    _getAddressFromLatLng(tappedPoint);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
 
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentCameraPosition,
              zoom: 14,
            ),
            onMapCreated: (controller) => mapController = controller,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onTap: _onMapTap,  
            onCameraMove: (position) =>
                _currentCameraPosition = position.target,
            onCameraIdle: () => _getAddressFromLatLng(_currentCameraPosition),
          ),

         
          Column(
            children: [
              SizedBox(height: 45.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: IconBak(image: IconsAssets.close),
                ),
              ),
              SizedBox(height: AppSpacing.x45.h),

             
              Container(
                height: 70.h,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.main1.withOpacity(0.5),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFieldsearch(
                        hintText: _currentFullAddress == "جاري تحديد الموقع..."
                            ? "ابحث عن موقعك أو انقر على الخريطة"
                            : _currentFullAddress,
                        controller: searchController,
                        onChanged: _getAutocompleteSuggestions,
                        onSubmitted: (_) => _searchAndNavigate(),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _searchAndNavigate(),
                      child: SvgPicture.asset(
                        IconsAssets.locationsearch,
                        color: AppColors.main1,
                        height: 24.h,
                      ),
                    ),
                  ],
                ),
              ),

            
              if (_predictions.isNotEmpty)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
                  constraints: BoxConstraints(maxHeight: 250.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _predictions.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: AppColors.main1,
                        size: 20.sp,
                      ),
                      title: Text(
                        _predictions[index]['description'],
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      onTap: () => _searchAndNavigate(
                        _predictions[index]['description'],
                      ),
                    ),
                  ),
                ),
              const RowSearch(),
            ],
          ),

       
          IgnorePointer(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 35.h),
                child: Icon(
                  Icons.location_on,
                  size: 48.sp,
                  color: AppColors.main1,
                ),
              ),
            ),
          ),

           
          Positioned(
            bottom: 30.h,
            left: 50.w,
            right: 50.w,
            child: ElevatedButton(
              onPressed: () {
                if (_lat == null || _lng == null) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Regsterview(
                      initialAddress: _currentFullAddress,
                      lat: _lat!,
                      lng: _lng!,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main1,
                minimumSize: Size(double.infinity, 55.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 5,
              ),
              child: Text(
                "تأكيد الموقع ومتابعة التسجيل",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
