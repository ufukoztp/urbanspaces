import 'dart:ui';


import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';
import 'package:solution_challenge/features/provider/HomePage_provider.dart';
import 'package:solution_challenge/features/widgets/appexpansion.dart';
import 'package:solution_challenge/features/widgets/comment_widget.dart';
import 'package:solution_challenge/utils/Routes.dart';
import 'package:solution_challenge/utils/app_localizations.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:sizer/sizer.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;


class HomePageWidget extends StatefulWidget {
     final HomePageProvider homePageProvider;

  HomePageWidget({   this.homePageProvider}):super();

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}
class parkList {
   final String name;
   final String avatar;
  parkList({   this.name,    this.avatar});
}
class _HomePageWidgetState extends State<HomePageWidget> with AfterLayoutMixin {
     HomePageProvider _homePageProvider;
     BitmapDescriptor mapMarker;
     FirebaseAuth _auth =FirebaseAuth.instance;
     double ratingValue;
     bool expansionState;
     User user;
     bool userState;
     GoogleSignIn _googleSignIn=GoogleSignIn();


  Future signIn()async{


    GoogleSignInAccount googleUser=await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth =await googleUser.authentication;

    AuthCredential credential =GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken: googleAuth.accessToken);

    await _auth.signInWithCredential(credential);
  }


  @override
  void initState() {
    // TODO: implement initState
    expansionState=false;

    ///initail variable
     _homePageProvider=widget.homePageProvider;

    _homePageProvider.pageController = PageController(initialPage: 1, viewportFraction: 0.8)..addListener(()async{

      print(_homePageProvider.pageController.page.toInt().toString()+"listener");

      int a =_homePageProvider.pageController.page.toInt();

      try{
        _homePageProvider.parkListPosition =  a;
      }catch(e){
        print(e.toString());
        _homePageProvider.parkListPosition = a;
      }
      _homePageProvider.scroll();
      await _homePageProvider.getRating(_homePageProvider.park[_homePageProvider.parkListPosition].title);
/*
      await _homePageProvider.getUserRating(_homePageProvider.park[_homePageProvider.parkListPosition].title,user.uid).then((value) {
        print("user");
      });
 */

    }
    );
    _homePageProvider.filter.add(AppLocalizations.getString('sit_field'));
    _homePageProvider.filter.add(AppLocalizations.getString('accessible'));
    _homePageProvider.filter.add(AppLocalizations.getString('eat'));
    _homePageProvider.filter.add(AppLocalizations.getString('wc'));
    _homePageProvider.filter.add(AppLocalizations.getString('culture'));
    _homePageProvider.filter.add(AppLocalizations.getString('car_park'));
    _homePageProvider.filter.add(AppLocalizations.getString('basketball'));
    _homePageProvider.filter.add(AppLocalizations.getString('sports_field'));
    _homePageProvider.filter.add(AppLocalizations.getString('bicycle_path'));
    _homePageProvider.filter.add(AppLocalizations.getString('running_track'));
    _homePageProvider.filter.add(AppLocalizations.getString('wifi'));
/*
    bg.BackgroundGeolocation.addGeofences(List.generate(_homePageProvider.park.length, (index)
    {

    return  bg.Geofence(
          identifier: _homePageProvider.park[index].title,
          radius: 700,
          latitude: double.parse(_homePageProvider.park[index].coords1),
          longitude: double.parse(_homePageProvider.park[index].coords2),
          notifyOnExit: true,
          notifyOnEntry: true
      );


    })).then((bool success) {
      print('[addGeofences] success');
    }).catchError((dynamic error) => {
      print('[addGeofences] FAILURE: $error')
    });

    // Fired whenever a location is recorded
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[gelen location]1234  $location');
    });

    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print('[motionchange] - $location');
    });

    // Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      print('[providerchange] - $event');
    });


    ////
    // 2.  Configure the plugin
    //
    bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,

        distanceFilter: 10.0,
        stopOnTerminate: false,
        isMoving: true,
        autoSync: true,
        forceReloadOnMotionChange: true,

        backgroundPermissionRationale: bg.PermissionRationale(
            title: "Allow {applicationName} to access this device's location even when the app is closed or not in use.",
            message: "This app collects location data to enable recording your trips to work and calculate distance-travelled.",
            positiveAction: 'Change to "{backgroundPermissionOptionLabel}"',
            negativeAction: 'Cancel'
        ),

        startOnBoot: true,
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE
    )).then((bg.State state) {
      if (!state.enabled) {
        ////
        // 3.  Start the plugin.
        //
        bg.BackgroundGeolocation.start();

      }
    });



    bg.BackgroundGeolocation.onGeofence((z) async{
     await _homePageProvider.setActivity(z.identifier, z.action);
     print(z.identifier+'  gelen geofence  '+z.action+" : geofence actions");
    });



 */

    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(visible:_homePageProvider.isLoading,child: Center(child: CircularProgressIndicator(backgroundColor:Color(0xff00524E) ,))),
        Visibility(
          visible: !_homePageProvider.isLoading,
          child: Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                trafficEnabled: false,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                 mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                markers: Set.from(_homePageProvider.markers),
                onMapCreated: _homePageProvider.onMapCreated,
                initialCameraPosition: CameraPosition(target: LatLng( 41.060701, 29.037435 ),zoom: 12),
              ),
            ),
             Padding(
              padding:  EdgeInsets.only(top:6.5.h,left: 2.0.w),
              child: Visibility(
                  visible: _homePageProvider.checkMenuVisibility(),
                  child: Stack(
                    children: [
                      InkWell(
                          onTap: (){
                            if(_homePageProvider.expansionState==false){
                              _homePageProvider.expansionTileList.currentState.expand();
                            }else{
                              _homePageProvider.expansionTileList.currentState.collapse();

                            }
                          },
                          child: filterBar()),

                      ///menü bar
                      Padding(
                        padding:  EdgeInsets.only(top:0.8.h,left:4.0.w,right: 0),
                        child: RotationTransition(
                          turns: new AlwaysStoppedAnimation(-180 / 360),
                          child: SpeedDial(
                            child: Icon(Icons.menu),
                            closedForegroundColor:Colors.black,
                            openForegroundColor: Colors.white,
                            closedBackgroundColor: Colors.white,
                            openBackgroundColor: Color(0xff00524E),
                            speedDialChildren: <SpeedDialChild>[
                              SpeedDialChild(
                                child: RotationTransition(
                                    turns: new AlwaysStoppedAnimation(-180 / 360),
                                    child: Icon(Icons.person)),
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  if(userState==false){
                                    showDialog(context: context,
                                        builder: (context){
                                          return AlertDialog(
                                             backgroundColor: Colors.transparent,
                                            content: Container(
                                              color: Colors.white,
                                              height: 270,
                                              width: 200,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(bottom:150.0,left: 10,right: 10),
                                                    child: Text("Lütfen önce giriş yapınız.",style: TextStyle(fontWeight: FontWeight.w700),),
                                                  ),
                                                  InkWell(
                                                    onTap: ()async{
                                                      signIn().then((value) => Navigator.of(context).pop());

                                                    },
                                                    child: Container(
                                                      child:Center(child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Container(
                                                              height: 30,
                                                              width: 30,
                                                              child: Image.asset("asset/google_icon.png")),

                                                          Text("GİRİŞ YAP",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20),),
                                                        ],
                                                      )),
                                                      width: MediaQuery.of(context).size.width,
                                                      height: 60,
                                                      color: Colors.green.shade700,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    );
                                  }else{
                                    Navigator.pushNamed(context, AppRoutes.profil);
                                  }
                                },
                                closeSpeedDialOnPressed: false,
                              ),
                              SpeedDialChild(
                                child: RotationTransition(
                                    turns: new AlwaysStoppedAnimation(-180 / 360),

                                    child: Icon(Icons.park)),
                                foregroundColor: Color(0xff00524E),
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, "/allparks").then((value)
                                  {
                                    setState(() {});
                                    _homePageProvider.moveCamera();
                                  });

                                },
                              ),
                              SpeedDialChild(
                                child: RotationTransition(
                                    turns: new AlwaysStoppedAnimation(-180 / 360),
                                    child: Icon(Icons.calendar_today)),
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, "/activity").then((value)
                                  {
                                    setState(() {});
                                    _homePageProvider.moveCamera();
                                  });

                                },
                              ),
                              //  Your other SpeeDialChildren go here.
                            ],
                          ),
                        ),
                      ),

                    ],
                  )),
            ),
            ///slide panel
            Opacity(
              opacity: _homePageProvider.checkMenuVisibility()==false?1:0.8,
              child: Visibility(
                visible: expansionState==true?false:true,
                 child:_homePageProvider.park[_homePageProvider.parkListPosition].title!=null?
                  SlidingUpPanel(
                   borderRadius: BorderRadius.circular(30),
                  onPanelOpened: (){
                    _homePageProvider.panelCheck=true;
                   },
                  onPanelClosed: (){
                    _homePageProvider.panelCheck=false;

                  },
                  controller:_homePageProvider.panelController ,
               minHeight: 32.0.h,
               maxHeight: 85.0.h,
                  collapsed: Container(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding:   EdgeInsets.only(top:3.0.h),
                        child: Column(
                          mainAxisAlignment:MainAxisAlignment.start,
                          children: [
                            Container(
                              height:0.6.w,
                              width: 13.w,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 2.w,),
                            Text('Ayrıntılar için yukarı kaydırınız',style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w500),),
                          ],
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top:Radius.circular(30))
                    ),
                  ),
                  panelBuilder: (scrollCntrl){
                    print(scrollCntrl.initialScrollOffset);
                    return  _homePageProvider.park[_homePageProvider.parkListPosition].title!=null?

                    SingleChildScrollView(
                        controller: scrollCntrl,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                )
                            ),
                            height:1770,
                            child:
                            Column(
                              children: [
                                InkWell(
                                  onTap: (){

                                    if( _homePageProvider.detailvisiblity==true){
                                      _homePageProvider.detailvisiblity=false;
                                      _homePageProvider.opacity=0.6;
                                    }
                                    else{
                                      _homePageProvider.opacity=1;
                                      _homePageProvider.detailvisiblity=true;
                                    }
                                  },
                                  child: Column(children: [

                                    Visibility(
                                      visible: true,
                                      child: Column(children: [
                                        ///header
                                        detailInfo( _homePageProvider.parkListPosition),
                                        Padding(
                                          padding:  EdgeInsets.all(8.0),
                                          child: Divider(color: Colors.black45,indent: 30,endIndent: 30,),
                                        ),
                                        SingleChildScrollView(
                                          ///content
                                          child: Stack(
                                            children: [
                                              Visibility(
                                                  visible:_homePageProvider.commentVisible,
                                                  child: Comment()),
                                              Visibility(
                                                  visible:!_homePageProvider.commentVisible,
                                                  child: infoCard()),
                                            ],
                                          ),
                                        ),

                                      ],),
                                    ),



                                  ],),

                                ),

                              ],
                            ) ,


                          ),
                        ),




                    ):Container();

                  },
                )

                 :Container()
              ),
            ),

             ///park card
             Visibility(
              visible: _homePageProvider.checkMenuVisibility(),
              child: Positioned(
                  bottom: 5.0.h,
                  child: Container(
                    height: 39.0.w,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      key: PageStorageKey('index'),
                      itemCount:_homePageProvider.park.length,
                      itemBuilder: (context, position) {

                        return parkListCard(position);
                      },
                      controller: _homePageProvider.pageController,
                    ),
                  )),
            ),



            Positioned(
              top:34,
              left: 100,
              right: 10,
              child:  InkWell(
                onTap: (){
                  setState(() {
                    _homePageProvider.expansionTileList.currentState.collapse();
                    setState(() {});
                  });
                },
                child: Container()
              )

            ),



            Visibility(
              visible: expansionState==true?false:true,
              child: Visibility(
                  visible: _homePageProvider.checkMenuVisibility(),
                  child: zoomButtons()),
            ),


          ],),
        ),
      ],
    );
  }

  Column infoCard() {
    return Column(children: [
                                          detailCard(title: AppLocalizations.getString('accessible'),icon: Icons.accessible,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].engellidostu,content: AppLocalizations.getString('accessible_content')),
                                          SizedBox(height: 30,),
                                          detailCard(title:  AppLocalizations.getString('sport_field'),icon: Icons.fitness_center,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].sporalani,content:AppLocalizations.getString('Spor_Alani_content') ),
                                          SizedBox(height: 30,),
                                          detailCard(title:  AppLocalizations.getString('eat'),icon: Icons.free_breakfast,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].yemeicme,content:AppLocalizations.getString('eat_content') ),
                                          SizedBox(height: 30,),
                                          detailCard(title:  AppLocalizations.getString('wc'),icon: Icons.wc,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].tuvalet,content: AppLocalizations.getString('wc_content')),
                                          SizedBox(height: 30,),
                                          detailCard(title:  AppLocalizations.getString('culture'),icon: Icons.museum,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].kultureloge,content: AppLocalizations.getString('culture_content') ),
                                          SizedBox(height: 30,),
                                          detailCard(title:  AppLocalizations.getString('car_park'),icon: Icons.directions_car,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].otopark, content: 'Otopark'),
                                          SizedBox(height: 30,),
                                          detailCard(title:  AppLocalizations.getString('sit_field'),icon: Icons.airline_seat_recline_normal,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].oturmaalani,content: AppLocalizations.getString('sit_fields_content') ),
                                          SizedBox(height: 30,),
                                          detailCard(title:  AppLocalizations.getString('basketball'),icon: Icons.sports_basketball_rounded,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].basketbol,content: AppLocalizations.getString('Basketbol_content') ),
                                          SizedBox(height: 30,),
                                          detailCard(title:  AppLocalizations.getString('sports_field'),icon: Icons.sports_mma_sharp,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].sporalani,content: AppLocalizations.getString('Spor_Alani_content') ),
                                          SizedBox(height: 30,),
                                          detailCard(title:  AppLocalizations.getString('bicycle_path'),icon: Icons.directions_bike_outlined,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].bisikletyolu,content: AppLocalizations.getString('Bisiklet_Yolu_content') ),
                                          SizedBox(height: 30,),
                                          detailCard(title:  AppLocalizations.getString('running_track'),icon: Icons.directions_run,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].kosuparkuru,content: AppLocalizations.getString('Kosu_Parkuru_content') ),
                                          SizedBox(height: 30,),
                                          detailCard(title:  AppLocalizations.getString('wifi'),icon: Icons.wifi,enabled: _homePageProvider.park[_homePageProvider.parkListPosition].wifi,content: AppLocalizations.getString('Wifi_content') ),
                                        ],);
  }

  Widget parkListCard(int position) {
    return AnimatedBuilder(
      animation: _homePageProvider.pageController,
      builder: (context,  widget) {
        double value = 1;
        if (_homePageProvider.pageController.position.haveDimensions) {
          value = (_homePageProvider.pageController.page - position);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);

        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 250.0.h,
            width: Curves.easeInOut.transform(value) * 450.0.h,
            child: widget,
          ),
        );

      },
      child: InkWell(
        onTap: () async{
         await _homePageProvider.moveCamera();
         await _homePageProvider.panelController.open();

        },
        child:

        _homePageProvider.park[0].title!=""?
        Stack(
          children: [

            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                height: 405.0.h,
                width: 80.0.w,

                child: Container(
                  width: 90.0.w,

                  decoration:
                  BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(-3,3),blurRadius: 20)],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                    children: [
                 Icon(Icons.chevron_left,color: Colors.grey,),
                      Padding(
                        padding:  EdgeInsets.all(3.0.w),
                        child: Container(
                          height: 90,
                          width: 22.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                 20),
                              image: DecorationImage(
                                  image: NetworkImage(  _homePageProvider.park[_homePageProvider.parkListPosition].photo!=""?_homePageProvider.park[_homePageProvider.parkListPosition].photo:"https://firebasestorage.googleapis.com/v0/b/yesil-ea967.appspot.com/o/yildiz-parki-1.jpg?alt=media&token=09388921-6388-428c-8c73-fffa6e603749"),
                                  fit: BoxFit.cover)),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _homePageProvider.park[_homePageProvider.parkListPosition].title.toUpperCase(),
                            style: TextStyle(
                                fontSize:8.0, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star,color: Colors.orange,size: 18,),
                              Text(_homePageProvider.ortRating!=null?_homePageProvider.ortRating.ceilToDouble().toString():'null',style: TextStyle(fontSize: 12,color: Colors.grey),),

                            ],
                          ),
                          Container(
                            width: 35.0.w,
                            height: 4.0.h,
                            child: Wrap(
                              children: [
                                Visibility(
                                  visible: _homePageProvider.park[_homePageProvider.parkListPosition].engellidostu==true?true:false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.accessible,color:Color(0xff00524E),size: 15,),
                                  ),
                                ),

                                Visibility(
                                  visible: _homePageProvider.park[_homePageProvider.parkListPosition].tuvalet==true?true:false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.wc,color:Color(0xff00524E),size: 15),
                                  ),
                                ),
                                Visibility(
                                  visible:_homePageProvider.park[_homePageProvider.parkListPosition].yemeicme==true?true:false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.free_breakfast,color:Color(0xff00524E),size: 15),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.park[_homePageProvider.parkListPosition].kultureloge==true?true:false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.museum,color:Color(0xff00524E),size: 15),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.park[_homePageProvider.parkListPosition].otopark==true?true:false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.directions_car,color:Color(0xff00524E),size: 15),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.park[_homePageProvider.parkListPosition].oturmaalani==true?true:false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.airline_seat_recline_normal,color:Color(0xff00524E),size: 15),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.park[_homePageProvider.parkListPosition].basketbol==true?true:false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.sports_basketball_rounded,color:Color(0xff00524E),size: 15),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.park[_homePageProvider.parkListPosition].sporalani==true?true:false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.sports_mma_sharp,color:Color(0xff00524E),size: 15),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.park[_homePageProvider.parkListPosition].bisikletyolu==true?true:false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.directions_bike_outlined,color:Color(0xff00524E),size: 15),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.park[_homePageProvider.parkListPosition].kosuparkuru==true?true:false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.directions_run_outlined,color:Color(0xff00524E),size: 15),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.park[_homePageProvider.parkListPosition].wifi==true?true:false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.wifi,color:Color(0xff00524E),size: 15),
                                  ),
                                ),
                              ],),
                          ),
                          Wrap(
                            children: [
                              Icon(Icons.location_on,size: 17,),
                              Container(
                                width: 30.0.w,

                                child: Text(
                                  _homePageProvider.park[_homePageProvider.parkListPosition].description.toUpperCase(),
                                  style: TextStyle(
                                      fontSize:8.0, fontWeight: FontWeight.w500,color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(child: Icon(Icons.chevron_right,color: Colors.grey,)),


                    ],
                  ),
                ),
              ),
            )


          ],
        ): Stack(
          children: [
            Center(
              child: InkWell(
                onTap: ()async{
                  _homePageProvider.filterIsClear();

                 await _homePageProvider.checkFilter2();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  height: 405.0.h,
                  width: 90.0.w,

                  child: Container(
                    decoration:
                    BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(-3,3),blurRadius: 20)],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)),
                    child:Container(
                      child: Center(child: Text(' Bu özellikleri barındıran bir park bulunamadı \n Filtre seçeneklerini sıfırlamak için tıklayınız.',style: TextStyle(color: Colors.grey),)),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget  filterBar(){
    return   Padding(
      padding:  EdgeInsets.only(left:22.0.w,right: 5.0.w),
      child: expansionState==false?Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
        elevation: 20,
        child: SizedBox(
          height:15.0.w,
          child: Stack(
            children: [
              AppExpansionTile(
                onExpansionChanged: (value){
                  setState(() {
                    expansionState=value;
                  });
                },
                key: _homePageProvider.expansionTileList,
                backgroundColor: Colors.transparent,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0.sp)
                      ),
                      height: 40.0.h,
                      width: 250.0.w,
                      child:SingleChildScrollView(
                        child: Column(
                          children: [
                            Divider(color: Colors.black38,),
                            Column(
                              children: [


                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.airline_seat_recline_normal,index: 0,homePageProvider: _homePageProvider,select: _homePageProvider.oturmaalani,name1: _homePageProvider.filter[0],),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:5.0,top:16),
                                  child: FilterButton(icon: Icons.accessible,index: 1,select: _homePageProvider.engellidostu,name1: _homePageProvider.filter[1],homePageProvider: _homePageProvider,),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.free_breakfast,index:2,select: _homePageProvider.yemek,name1: _homePageProvider.filter[2],homePageProvider: _homePageProvider,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:5.0,top:16),
                                  child: FilterButton(icon:Icons.wc,select: _homePageProvider.wc,name1: _homePageProvider.filter[3],index: 3,homePageProvider: _homePageProvider,),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.museum,select: _homePageProvider.kultureloge,name1: _homePageProvider.filter[4],index: 4,homePageProvider: _homePageProvider,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:5.0,top:16),
                                  child: FilterButton(icon: Icons.directions_car,select: _homePageProvider.otopark,name1: _homePageProvider.filter[5],index: 5,homePageProvider: _homePageProvider,),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.sports_basketball_rounded,select: _homePageProvider.basketboll,name1: _homePageProvider.filter[6],index: 6,homePageProvider: _homePageProvider,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:5.0,top:16),
                                  child: FilterButton(icon: Icons.sports_mma_sharp,select: _homePageProvider.sports_fields,name1: _homePageProvider.filter[7],index: 7,homePageProvider: _homePageProvider,),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.directions_bike_outlined,select: _homePageProvider.bicycle_path,name1: _homePageProvider.filter[8],index: 8,homePageProvider: _homePageProvider,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:5.0,top:16),
                                  child: FilterButton(icon: Icons.directions_run,select: _homePageProvider.running_track,name1: _homePageProvider.filter[9],index: 9,homePageProvider: _homePageProvider,),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.wifi,select: _homePageProvider.wifi,name1: _homePageProvider.filter[10],index: 10,homePageProvider: _homePageProvider,),
                                ),

                              ],
                            ),

                          ],
                        ),
                      )
                  )
                ],
              ),
              Padding(
                padding:  EdgeInsets.only(left: 4.0.w,right: 4.0.w,top:0.0.w,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(left: 4.0.w,right: 4.0.w,top:5.6.w,),
                          child: Text(AppLocalizations.getString('filter'),style:TextStyle(color:_homePageProvider.oturmaalani==true||
                              _homePageProvider.otopark==true||
                              _homePageProvider.kultureloge==true||
                              _homePageProvider.yemek==true||_homePageProvider.wc==true||
                              _homePageProvider.engellidostu==true||
                              _homePageProvider.spor==true||_homePageProvider.basketboll==true ||_homePageProvider.sports_fields==true||_homePageProvider.bicycle_path==true||_homePageProvider.running_track==true||_homePageProvider.wifi==true?Colors.white:Colors.grey),),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(left:8.0,top:2.0.w),
                          child: Container(
                            height: 5.0.h,
                            width: 49.0.w,
                            child: SingleChildScrollView(
                              scrollDirection:Axis.horizontal,
                              child: Row(
                                children: [
                                  Visibility(
                                    visible: _homePageProvider.engellidostu,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.accessible,color:Color(0xff00524E)),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _homePageProvider.spor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.fitness_center,color:Color(0xff00524E)),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _homePageProvider.wc,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.wc,color:Color(0xff00524E)),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _homePageProvider.yemek,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.free_breakfast,color:Color(0xff00524E)),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _homePageProvider.kultureloge,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.museum,color:Color(0xff00524E)),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _homePageProvider.otopark,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.directions_car,color:Color(0xff00524E)),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _homePageProvider.oturmaalani,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.airline_seat_recline_normal,color:Color(0xff00524E),),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _homePageProvider.basketboll,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.sports_basketball_rounded,color:Color(0xff00524E),),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _homePageProvider.sports_fields,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.sports_mma_sharp,color:Color(0xff00524E),),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _homePageProvider.bicycle_path,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.directions_bike_outlined,color:Color(0xff00524E),),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _homePageProvider.running_track,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.directions_run_outlined,color:Color(0xff00524E),),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _homePageProvider.wifi,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Icon(Icons.wifi,color:Color(0xff00524E),),
                                    ),
                                  ),
                                ],),
                            ),
                          ),
                        ),

                      ],
                    ),
                    Row(children: [
                      Padding(
                        padding:  EdgeInsets.only(top:3.0.w),
                        child: Container(height: 5.0.h,width: 1,color: Colors.grey.shade400,),
                      ),
                      SizedBox(width: 2.0.w,),
                      Padding(
                        padding:  EdgeInsets.only(top:3.0.w),
                        child: Icon(Icons.filter_list,color: Color(0xff545857),),
                      ),
                    ],)
                ],
                ),
              ),
              Visibility(
                visible: expansionState==true?true:false,
                child: Padding(
                  padding:  EdgeInsets.only(top:47.0.h),
                  child: InkWell(
                    onTap: ()async{
                      _homePageProvider.expansionTileList.currentState.collapse();
                      await _homePageProvider.checkFilter2();
                      setState(() {

                      });

                    },
                    child: Container(
                      child: Center(child: Text("UYGULA",style: TextStyle(color: Colors.green.shade700,fontWeight: FontWeight.w700,fontSize: 18.0.sp),)),
                      width: 80.0.w,
                      height: 7.0.h,
                      decoration: BoxDecoration(
                          color: Colors.transparent,

                          borderRadius: BorderRadius.only()
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ):Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
        elevation: 20,
        child: Stack(
          children: [
            Positioned(
              child: AppExpansionTile(
                onExpansionChanged: (value){
                  setState(() {
                    expansionState=value;
                  });
                },
                key: _homePageProvider.expansionTileList,
                backgroundColor: Colors.transparent,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0.sp)
                      ),
                      height: 40.0.h,
                      width: 250.0.w,
                      child:SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 3.0.h,),
                            Divider(color: Colors.black38,),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.airline_seat_recline_normal,index: 0,homePageProvider: _homePageProvider,select: _homePageProvider.oturmaalani,name1: _homePageProvider.filter[0],),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:5.0,top:16),
                                  child: FilterButton(icon: Icons.accessible,index: 1,select: _homePageProvider.engellidostu,name1: _homePageProvider.filter[1],homePageProvider: _homePageProvider,),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.free_breakfast,index:2,select: _homePageProvider.yemek,name1: _homePageProvider.filter[2],homePageProvider: _homePageProvider,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:5.0,top:16),
                                  child: FilterButton(icon:Icons.wc,select: _homePageProvider.wc,name1: _homePageProvider.filter[3],index: 3,homePageProvider: _homePageProvider,),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.museum,select: _homePageProvider.kultureloge,name1: _homePageProvider.filter[4],index: 4,homePageProvider: _homePageProvider,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:5.0,top:16),
                                  child: FilterButton(icon: Icons.directions_car,select: _homePageProvider.otopark,name1: _homePageProvider.filter[5],index: 5,homePageProvider: _homePageProvider,),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.sports_basketball_rounded,select: _homePageProvider.basketboll,name1: _homePageProvider.filter[6],index: 6,homePageProvider: _homePageProvider,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:5.0,top:16),
                                  child: FilterButton(icon: Icons.sports_mma_sharp,select: _homePageProvider.sports_fields,name1: _homePageProvider.filter[7],index: 7,homePageProvider: _homePageProvider,),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.directions_bike_outlined,select: _homePageProvider.bicycle_path,name1: _homePageProvider.filter[8],index: 8,homePageProvider: _homePageProvider,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:5.0,top:16),
                                  child: FilterButton(icon: Icons.directions_run,select: _homePageProvider.running_track,name1: _homePageProvider.filter[9],index: 9,homePageProvider: _homePageProvider,),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:16.0,left:2),
                                  child: FilterButton(icon: Icons.wifi,select: _homePageProvider.wifi,name1: _homePageProvider.filter[10],index: 10,homePageProvider: _homePageProvider,),
                                ),

                              ],
                            ),
                          ],
                        ),
                      )
                  )
                ],
              ),
            ),

            Padding(
              padding:  EdgeInsets.only(left: 4.0.w,right: 4.0.w,top:3.0.w,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Stack(
                    children: [
                      Text(AppLocalizations.getString('filter'),
                        style: TextStyle(color:_homePageProvider.oturmaalani==true||
                            _homePageProvider.otopark==true||
                            _homePageProvider.kultureloge==true||
                            _homePageProvider.yemek==true||_homePageProvider.wc==true||
                            _homePageProvider.engellidostu==true||
                            _homePageProvider.spor==true||_homePageProvider.basketboll==true ||_homePageProvider.sports_fields==true||_homePageProvider.bicycle_path==true||_homePageProvider.running_track==true||_homePageProvider.wifi==true?Colors.white:Colors.grey),),
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,top:0),
                        child: Container(
                          height: 5.0.h,
                          width: 49.0.w,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(

                              children: [
                                Visibility(
                                  visible: _homePageProvider.engellidostu,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.accessible,color:Color(0xff00524E)),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.spor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.fitness_center,color:Color(0xff00524E)),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.wc,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.wc,color:Color(0xff00524E)),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.yemek,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.free_breakfast,color:Color(0xff00524E)),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.kultureloge,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.museum,color:Color(0xff00524E)),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.otopark,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.directions_car,color:Color(0xff00524E)),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.oturmaalani,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.airline_seat_recline_normal,color:Color(0xff00524E),),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.basketboll,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.sports_basketball_rounded,color:Color(0xff00524E),),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.sports_fields,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.sports_mma_sharp,color:Color(0xff00524E),),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.bicycle_path,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.directions_bike_outlined,color:Color(0xff00524E),),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.running_track,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.directions_run_outlined,color:Color(0xff00524E),),
                                  ),
                                ),
                                Visibility(
                                  visible: _homePageProvider.wifi,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(Icons.wifi,color:Color(0xff00524E),),
                                  ),
                                ),
                              ],),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(children: [
                    Container(height: 5.0.h,width: 1,color: Colors.grey.shade400,),
                    SizedBox(width: 2.0.w,),
                    Icon(Icons.filter_list,color: Color(0xff545857),),
                  ],)
                ],
              ),
            ),
            Visibility(
              visible: expansionState==true?true:false,
              child: Padding(
                padding:  EdgeInsets.only(top:47.0.h),
                child: InkWell(
                  onTap: ()async{
                    _homePageProvider.expansionTileList.currentState.collapse();
                   await _homePageProvider.checkFilter2();
                    setState(() {

                    });

                  },
                  child: Container(
                    child: Center(child: Text("UYGULA",style: TextStyle(color: Colors.green.shade700,fontWeight: FontWeight.w700,fontSize: 18.0.sp),)),
                    width: 80.0.w,
                    height: 10.0.h,
                    decoration: BoxDecoration(
                        color: Colors.transparent,

                        borderRadius: BorderRadius.only()
                    ),
                  ),
                ),
              ),
            ),


          ],
        ),
      )
    );

  }

  Widget zoomButtons(){

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding:  EdgeInsets.all(4.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap:()async{
                double screenWidth = MediaQuery.of(context).size.width *
                    MediaQuery.of(context).devicePixelRatio;
                double screenHeight = MediaQuery.of(context).size.height *
                    MediaQuery.of(context).devicePixelRatio;

                double middleX = screenWidth / 2;
                double middleY = screenHeight / 2;

                ScreenCoordinate screenCoordinate = ScreenCoordinate(x: middleX.round(), y: middleY.round());


                var zoomLevel= await _homePageProvider.controller.getZoomLevel();
                zoomLevel +=0.5;
                var d=    await _homePageProvider.controller.getLatLng(screenCoordinate);
                _homePageProvider.controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(zoom: zoomLevel,target:d )
                    )

                );
              },
              child: Container(
                child: Icon(Icons.add),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.yellow.shade700,
                    borderRadius: BorderRadius.circular(50)
                ),
              ),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: ()async{
                double screenWidth = MediaQuery.of(context).size.width *
                    MediaQuery.of(context).devicePixelRatio;
                double screenHeight = MediaQuery.of(context).size.height *
                    MediaQuery.of(context).devicePixelRatio;

                double middleX = screenWidth / 2;
                double middleY = screenHeight / 2;

                ScreenCoordinate screenCoordinate = ScreenCoordinate(x: middleX.round(), y: middleY.round());


                var zoomLevel= await _homePageProvider.controller.getZoomLevel();
                zoomLevel -=0.5;
                var d=    await _homePageProvider.controller.getLatLng(screenCoordinate);
                _homePageProvider.controller.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(zoom: zoomLevel,target:d )
                    )

                );
              },
              child: Container(
                child: Icon(Icons.remove),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.yellow.shade700,
                    borderRadius: BorderRadius.circular(50)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailInfo(int posinited){
    return Row(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child:   Padding(
            padding: EdgeInsets.only(top:6.0.h),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:NetworkImage(_homePageProvider.park[_homePageProvider.parkListPosition].photo!=""?_homePageProvider.park[_homePageProvider.parkListPosition].photo:"https://firebasestorage.googleapis.com/v0/b/yesil-ea967.appspot.com/o/yildiz-parki-1.jpg?alt=media&token=09388921-6388-428c-8c73-fffa6e603749"),
                      fit: BoxFit.cover
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50)
                  )
              ),
              height: 25.0.h,
              width: 39.0.w,
            ),
          ),
        ),
        SizedBox(width: 1.0.w,),
        Expanded(
          child: Padding(
            padding:  EdgeInsets.only(top:6.0.h),
            child: Column(
              children: [
                Text(_homePageProvider.park[_homePageProvider.parkListPosition].title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),),
                Padding(
                  padding:  EdgeInsets.only(left:0.0),
                  child:Column(
                    children: [
                      ///rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GFRating(
                            value: _homePageProvider.userRating,
                            onChanged: (value)async{
                              if(userState==false){
                                showDialog(context: context,
                                    builder:(context){
                                  return AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    content: Container(
                                      color: Colors.white,
                                      height: 270,
                                      width: 200,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom:150.0,left: 10,right: 10),
                                            child: Text("Lütfen önce giriş yapınız.",style: TextStyle(fontWeight: FontWeight.w700),),
                                          ),
                                          InkWell(
                                            onTap: ()async{
                                              signIn();

                                            },
                                            child: Container(
                                              child:Center(child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                      height: 30,
                                                      width: 30,
                                                      child: Image.asset("asset/google_icon.png")),

                                                  Text("GİRİŞ YAP",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 20),),
                                                ],
                                              )),
                                              width: MediaQuery.of(context).size.width,
                                              height: 60,
                                              color: Colors.green.shade700,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                    }
                                );
                              }else{

                                setState(() {
                                  _homePageProvider.userRating=value;

                                });
                                _homePageProvider.userRating=value;


                                await _homePageProvider.setRating(_homePageProvider.park[_homePageProvider.parkListPosition].title, user.uid, value).then((value) =>print("başarılı"));

                                await _homePageProvider.getRating(_homePageProvider.park[_homePageProvider.parkListPosition].title);
                                await _homePageProvider.getUserRating(_homePageProvider.park[_homePageProvider.parkListPosition].title,user.uid);
                                ratingValue= _homePageProvider.userRating;

                              }




    },
                            borderColor: Colors.orange,
                            color: Colors.orange,
                            size: 27,
                          ),
                          SizedBox(width: 2.w,),
                          _homePageProvider.ortRating!=null?
                          Text(_homePageProvider.ortRating.ceilToDouble().toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),)
                        :Text("Henüz puanı yok")
                        ],
                      ),

                    ],
                  )
                ),
                Text("Puan ve yorum için buraya tıkla",style: TextStyle(color: Colors.grey,fontSize: 8.sp),),
                InkWell(
                  onTap: (){
                    widget.homePageProvider.commentVisible = !widget.homePageProvider.commentVisible;
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(left:11.0.w,top: 2.w),
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                        ),
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 10)],
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Center(child: Icon(Icons.person,color: Colors.grey,),),
                        ),
                        Positioned(
                          left: 6.w,
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 10)],
                                borderRadius: BorderRadius.circular(100)
                            ),
                            child: Center(child: Icon(Icons.person,color: Colors.grey,),),
                          ),
                        ),
                        Positioned(
                          left: 12.w,
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 10)],
                                borderRadius: BorderRadius.circular(100)
                            ),
                            child: Center(child: Icon(Icons.person,color: Colors.grey,),),
                          ),

                        ),
                        Positioned(
                          left: 18.w,
                          child:Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 10)],
                                borderRadius: BorderRadius.circular(100)
                            ),
                            child: Center(child: Icon(Icons.person,color: Colors.grey,),),
                          ),

                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    print(double.parse(_homePageProvider.park[_homePageProvider.parkListPosition].coords1));
                    MapsLauncher.launchCoordinates(
                    double.parse(_homePageProvider.park[_homePageProvider.parkListPosition].coords1),double.parse(_homePageProvider.park[_homePageProvider.parkListPosition].coords2),_homePageProvider.park[_homePageProvider.parkListPosition].title );

                  },
                  child: Padding(
                    padding:  EdgeInsets.only(right:3.h),
                    child: Container(
                      child: Center(child: Text(AppLocalizations.getString('take_me_here'),style: TextStyle(color: Colors.white),)),
                      decoration: BoxDecoration(
                          color: Color(0xff00524E),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      height: 5.5.h,
                      width: 32.w,
                    ),
                  ),
                )
              ],
            ),
          ),
        )

      ],
    );
  }

  Widget detailCard({   String title,  IconData icon,  bool enabled,  String content}){
   return Padding(
     padding:  EdgeInsets.only(left:5.0.w,right: 5.0.w),
     child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black45,offset: Offset(-2,4),blurRadius: 10)]
        ),
        height: 10.0.h,
        width: 410.0.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 4.0.w,),
            Icon(icon,color: enabled==false?Colors.grey: Color(0xff00524E),size: 26.0.sp,),
            SizedBox(width: 4.0.w,),
            Expanded(child: Text(title,style: TextStyle(fontSize: 15.0.sp,fontWeight: FontWeight.w500,color: enabled==false?Colors.grey: Color(0xff00524E)),)),
            Padding(
              padding:  EdgeInsets.only(bottom:5.0.h,left: 10.0.w,right: 5.0.w),
              child: InkWell(
                onTap: ()async{
               await   showDialog(context: context,
                      builder:(context){
                 return AlertDialog(
                   backgroundColor: Colors.transparent,
                   content: Container(
                     color: Colors.white,
                     height: 300,
                     width: 200,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(bottom:150.0,left: 10,right: 10),
                           child: Text(content !=null?content:title,style: TextStyle(fontWeight: FontWeight.w700),),
                         ),

                       ],
                     ),
                   ),
                 );
                      }
                  );
                },
                child: Container(
                  child: Icon(Icons.info_outline,color: Colors.white,),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  height: 24,
                  width: 24,
                ),
              ),
            )

          ],),

      ),
   );
  }

  @override
  void afterFirstLayout(BuildContext context) async{
    _auth.authStateChanges().listen((event)async {
      if(event!=null){
        user= event;
        userState=true;
        await  _homePageProvider.getUserRating(_homePageProvider.park[_homePageProvider.parkListPosition].title,user.uid);
      }else{
        userState=false;
        print('kullanıcı yok');
      }
    });
    await _homePageProvider.getRating(_homePageProvider.park[_homePageProvider.parkListPosition].title);


  }

}

class FilterButton extends StatefulWidget {
   FilterButton({
         this.select,   this.name1,   this.homePageProvider,  this.index,  this.icon,
  });

    final String name1;
    final HomePageProvider homePageProvider;
    final int index;
    final IconData icon;
      bool select;


   @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        switch(widget.index){
          case 0:
            widget.homePageProvider.oturmaalani==false?widget.homePageProvider.oturmaalani=true:widget.homePageProvider.oturmaalani=false;
            break;
          case 1:
            widget.homePageProvider.engellidostu==false?widget.homePageProvider.engellidostu=true:widget.homePageProvider.engellidostu=false;
            break;
          case 2:
            widget.homePageProvider.yemek==false?widget.homePageProvider.yemek=true:widget.homePageProvider.yemek=false;
            break;
          case 3:
            widget.homePageProvider.wc==false?widget.homePageProvider.wc=true:widget.homePageProvider.wc=false;
            break;
          case 4:
            widget.homePageProvider.kultureloge==false?widget.homePageProvider.kultureloge=true:widget.homePageProvider.kultureloge=false;
            break;
          case 5:
            widget.homePageProvider.otopark==false?widget.homePageProvider.otopark=true:widget.homePageProvider.otopark=false;
            break;
          case 6:
            widget.homePageProvider.basketboll==false?widget.homePageProvider.basketboll=true:widget.homePageProvider.basketboll=false;
            break;
          case 7:
            widget.homePageProvider.sports_fields==false?widget.homePageProvider.sports_fields=true:widget.homePageProvider.sports_fields=false;
            break;
          case 8:
            widget.homePageProvider.bicycle_path==false?widget.homePageProvider.bicycle_path=true:widget.homePageProvider.bicycle_path=false;
            break;
          case 9:
            widget.homePageProvider.running_track==false?widget.homePageProvider.running_track=true:widget.homePageProvider.running_track=false;
            break;

          case 10:
            widget.homePageProvider.wifi==false?widget.homePageProvider.wifi=true:widget.homePageProvider.wifi=false;
            break;
        }

        setState(() {

        });

      },
      child: Container(
        decoration: BoxDecoration(
            border:widget.select==true? Border.all(color: Colors.green): Border.all(color: Colors.white),
            boxShadow: [BoxShadow(color: Colors.black26,offset: Offset(2,2),blurRadius: 10)],
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
        ),
        height: 50,
        width: 240,
        child:  Center(child: Padding(
          padding: const EdgeInsets.only(left:16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Visibility(
                  visible: widget.select==true?true:false,
                  child: Icon(Icons.check,color: Colors.green)),
              Text(widget.name1,style: TextStyle(fontSize: 10),),
              Container(
                  height: 40,
                  width: 40,
                  child: Icon(widget.icon,color: widget.select==false?Colors.grey:Color(0xff00524E),))
            ],
          ),
        )),
      ),
    );
  }
}


