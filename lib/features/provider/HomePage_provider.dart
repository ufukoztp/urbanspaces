import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';
import 'package:solution_challenge/domain/repository/repo.dart';
import 'package:solution_challenge/features/widgets/appexpansion.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui' as ui;
//import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;


abstract class HomePageProviderAbs{
  onMapCreated(controller);
  getParkList();
  setRating(String parkname,var uid ,double rating);
  moveCamera();
}

class HomePageProvider with ChangeNotifier implements HomePageProviderAbs{
  GlobalKey<AppExpansionTileState> _appExpansionTileState = GlobalKey<AppExpansionTileState>();

  GlobalKey<AppExpansionTileState> get appExpansionTileState => _appExpansionTileState;

  List<bool> _expansionChange=[];

  List<bool> get expansionChange => _expansionChange;

  int _selectId;

  bool _commentVisible=false;

  bool get commentVisible => _commentVisible;

  set commentVisible(bool value) {
    _commentVisible = value;
    notifyListeners();
  }

  int get selectId => _selectId;

  set selectId(int value) {
    _selectId = value;
    notifyListeners();
  }

  set expansionChange(List<bool> value) {
    _expansionChange = value;
    notifyListeners();
  }

  List<GlobalKey<AppExpansionTileState>> _expansionTileList2=[];

  List<GlobalKey<AppExpansionTileState>> get expansionTileList2 =>
      _expansionTileList2;

  set expansionTileList2(List<GlobalKey<AppExpansionTileState>> value) {
    _expansionTileList2 = value;
    notifyListeners();
  }

  set appExpansionTileState( GlobalKey<AppExpansionTileState> value) {
    _appExpansionTileState = value;
    notifyListeners();
  }

  GoogleMapController _controller;
     PageController _pageController;
   PanelController _panelController=PanelController() ;
   List<String> _filterList=[];

     ValueNotifier<bool> _isDialOpen = ValueNotifier(false);


     ValueNotifier<bool> get isDialOpen => _isDialOpen;

  set isDialOpen(ValueNotifier<bool> value) {
    _isDialOpen = value;
    notifyListeners();
  }

  List<String> get filterList => _filterList;

  set filterList(List<String> value) {
    _filterList = value;
    notifyListeners();
  }

  /*
   bg.Location _nowLocation;

  bg.Location get nowLocation => _nowLocation;

  set nowLocation(bg.Location value) {
    _nowLocation = value;
    notifyListeners();
  }

    */

  PanelController get panelController => _panelController;

  set panelController(PanelController value) {
    _panelController = value;
    notifyListeners();
  }

  PageController get pageController => _pageController;


   GlobalKey<AppExpansionTileState> _expansionTileList=GlobalKey<AppExpansionTileState>();


  GlobalKey<AppExpansionTileState> get expansionTileList => _expansionTileList;



      PageController minscrollExtend;
   List<Marker> _markers=[];

   List<String> filter=[];



  List<Marker> get markers => _markers;


   List<Parks> _parkList=[];
   List<Parks> _park=[];

  List<Parks> get park => _park;

  set park(List<Parks> value) {
    _park = value;
    notifyListeners();
  }

  int _parkListPosition=0;
     int _preview;
  double _draggablePadding=6.0.h;


  double get draggablePadding => _draggablePadding;

  set draggablePadding(double value) {
    _draggablePadding = value;
  }

  bool _isLocationState=false;

  bool get isLocationState => _isLocationState;

  set isLocationState(bool value) {
    _isLocationState = value;
    notifyListeners();
  }

  bool _isLoading=true;
  bool _spor=false;
  bool _engellidostu=false;
  bool _yemek=false;
  bool _wc=false;
  bool _kultureloge=false;
  bool _otopark=false;
  bool _oturmaalani=false;
  bool _basketboll=false;

  bool get basketboll => _basketboll;

  set basketboll(bool value) {
    _basketboll = value;
    notifyListeners();
  }

  bool _sports_fields=false;
  bool _bicycle_path=false;
  bool _running_track=false;
  bool _wifi=false;
  bool _expansionState=false;


  bool get panelCheck => _panelCheck;

  set panelCheck(bool value) {
    _panelCheck = value;
    notifyListeners();
  }

  bool _panelCheck=false;

  bool get expansionState => _expansionState;



     double _ortRating;
  double _userRating=1;

  double get userRating => _userRating;

  set userRating(double value) {
    _userRating = value;
    notifyListeners();
  }

  double get ortRating => _ortRating;

  set ortRating(double value) {
    _ortRating = value;
    notifyListeners();
  }

  bool get spor => _spor;

  set spor(bool value) {
    _spor = value;
    notifyListeners();
  }


  set expansionState(bool value) {
    _expansionState = value;
    notifyListeners();
  }

  ProductRepository _productRepository=   ProductRepository();



  bool _detailvisiblity=false;


  double _opacity=0.1;

  bool get detailvisiblity => _detailvisiblity;

  double get opacity => _opacity;

  int get parkListPosition => _parkListPosition;

  bool get isLoading => _isLoading;

  List<Parks> get parkList => _parkList;

  int get preview => _preview;




  GoogleMapController get controller => _controller;

  bool get engellidostu => _engellidostu;

  set engellidostu(bool value) {
    _engellidostu = value;
    notifyListeners();
  }

  bool get yemek => _yemek;

  set yemek(bool value) {
    _yemek = value;
    notifyListeners();
  }

  bool get wc => _wc;

  set wc(bool value) {
    _wc = value;
    notifyListeners();
  }

  bool get kultureloge => _kultureloge;

  set kultureloge(bool value) {
    _kultureloge = value;
    notifyListeners();
  }

  bool get otopark => _otopark;

  set otopark(bool value) {
    _otopark = value;
    notifyListeners();
  }

  bool get oturmaalani => _oturmaalani;

  set oturmaalani(bool value) {
    _oturmaalani = value;
    notifyListeners();
  }

  set controller(GoogleMapController value) {
    _controller = value;
    notifyListeners();
  }

  set parkListPosition(int value) {
    _parkListPosition = value;
  }

  set preview(int value) {
    _preview = value;
    notifyListeners();
  }


  set markers(List<Marker> value) {
    _markers = value;
    notifyListeners();
  }

  set expansionTileList(GlobalKey<AppExpansionTileState> value) {
    _expansionTileList = value;
    notifyListeners();
  }

  set pageController(PageController value) {
    _pageController = value;
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set detailvisiblity(bool value) {
    _detailvisiblity = value;
    notifyListeners();
  }



  set opacity(double value) {
    _opacity = value;
    notifyListeners();
  }


  set parkList(List<Parks> value) {
    _parkList = value;
    notifyListeners();
  }

  setActivity(idenfitier,state){
    _productRepository.setActiviy(idenfitier, state);
    notifyListeners();


  }

  onMapCreated(controller)async{
      BitmapDescriptor  mapMarker;
      await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(40, 40,),devicePixelRatio: 10), "asset/markeragac.png").then((value) {
      mapMarker=value;
    });
    _controller=controller;
    List.generate(parkList.length, (index) async{
      LatLng coords=LatLng(double.parse(parkList[index].coords1),double.parse(parkList[index].coords2));
      markers.add(Marker(

          icon: mapMarker,
          markerId: MarkerId(parkList[index].title),
          infoWindow: InfoWindow(onTap: ()async{
            await panelController.open();

          },title: parkList[index].title, snippet: parkList[index].description),
          position:coords));

    });




        notifyListeners();
  }

  moveCamera()async {
   controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target:LatLng(double.parse(park[parkListPosition].coords1),double.parse(park[parkListPosition].coords2)),
            zoom: 14,bearing: 45,tilt: 45
        )));

  }

  moveCameraWithMarker(cords1,cords2) {
    controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
            target:LatLng(cords1,cords2),
            zoom: 14,bearing: 45,tilt: 45
        )));
  }

 Future getParkList()async{

   await _productRepository.getParkList(filterlist: filterList).then((value) {
      print('parklist sonuç : '+value.length.toString());
      park.clear();

      park=(value);
    if(park!=null){
      isLoading=false;
    }


   });
    notifyListeners();
  }

  Future setRating(String parkname,var uid ,double rating)async{
    await _productRepository.setRating(parkname, uid, rating);
  }
  Future getRating(String parkname)async{

    var d=await _productRepository.getRating(parkname);
    ortRating=d.isNaN==true?1:d;
    print(ortRating.toString()+"provider");

    notifyListeners();

  }

  Future getUserRating(String parkname,var uid)async{
     double d= await _productRepository.getUserRating(parkname, uid);
   print(d.toString()+"user provider");
   if(d!=null){
     userRating=d;
   }

notifyListeners();

  }


  scroll()async{
    if(pageController.page.toInt()!=preview){
      preview=pageController.page.toInt();
      moveCameraWithMarker(double.parse(park[pageController.page.toInt()].coords1), double.parse(park[pageController.page.toInt()].coords2));
      await controller.showMarkerInfoWindow(MarkerId(park[pageController.page.toInt()].title));

      notifyListeners();
    }

  }

  checkMenuVisibility(){
     if(panelCheck==true){
       return false;
    } else{
      return true;
    }
    notifyListeners();
  }

  checkFilter3() {
    Set<Map> filters =Set<Map>();




    park.clear();

    park.addAll(parkList.where((element) => element.otopark==otopark&&element.tuvalet==wc&&element.kultureloge==kultureloge&&element.engellidostu==engellidostu&&element.oturmaalani==oturmaalani&&element.yemeicme==yemek));

    if(park.isNotEmpty){
      park.addAll(parkList);

    }

    if(park.isEmpty){
      park.addAll(parkList);
    }

    print(park.length);

    notifyListeners();

  }

  Future checkFilter2()async {
    filterList.clear();



    if(otopark== true){
      filterList.add("otopark");
    }if(wc== true){
      filterList.add("tuvalet");
    }if(kultureloge== true){
      filterList.add("kultureloge");
    }if(engellidostu==true){
      filterList.add("engellidostu");
    }if(oturmaalani==true){
      filterList.add("oturmaalani");
    }if(yemek==true){
      filterList.add("yemeicme");
    }if(basketboll==true){
      filterList.add("basketball");
    }if(sports_fields==true){
      filterList.add("sporalani");
    }if(bicycle_path==true){
      filterList.add("bisikletyolu");
    }if(_running_track==true){
      filterList.add("kosuparkuru");
    }if(wifi==true){
      filterList.add("wifi");
    }

   await getParkList();

print(filterList.toString());

    /*
    park.addAll(parkList.where((element){

      ///true mu false mu dönüyor bak
       return (otopark== true?element.otopark==true?true:false:true&&wc== true?element.tuvalet == true?true:false:true&&
          kultureloge== true?element.kultureloge == true?true:false:true&&engellidostu==true? element.engellidostu == true?true:false:true&& oturmaalani==true?element.oturmaalani == oturmaalani?true:false:true
          && yemek==true?element.yemeicme == true?true:false:true&&basketboll==true?element.basketbol == basketboll?true:false:true
          &&sports_fields==true?element.sporalani == sports_fields?true:false:true&&bicycle_path==true?element.bisikletyolu == true?true:false:true&&_running_track==true?element.kosuparkuru == true?true:false:true&&wifi==true?element.wifi == true?true:false:true);
    }));


     */


    print(park.toString());
/*
    park.addAll(parkList.where((element) {
    return otopark==true? element.otopark == otopark :true&& wc==true? element.tuvalet == wc:true &&
        kultureloge==true?  element.kultureloge == kultureloge :true&&
         engellidostu==true? element.engellidostu == engellidostu :true&&
         oturmaalani==true? element.oturmaalani == oturmaalani:true&& yemek==true?element.yemeicme == yemek :true;
    }));


    if(park.isNotEmpty){
      print(park[0].otopark);
      park.addAll(parkList);

    }
 */

    if(park.isEmpty){
      print("çalıştı empty");
      park.addAll(parkList);
    }

    print(park.length);
    print("çalıştı");

    notifyListeners();

  }

  checkFilter(){
    parkList.clear();
    ///eğer tüm koşullar true ise

 if(otopark==true||oturmaalani==true||engellidostu==true||kultureloge==true||spor==true||wc==true||yemek==true){
  if(otopark==true){
    List.generate(park.length, (index) {
      if(park[index].sporalani==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }  if(oturmaalani==true){
    List.generate(park.length, (index) {
      if(park[index].oturmaalani==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }  if(engellidostu==true){
    List.generate(park.length, (index) {
      if(park[index].engellidostu==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }if(kultureloge==true){
    List.generate(park.length, (index) {
      if(park[index].kultureloge==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }if(spor==true){
    List.generate(park.length, (index) {
      if(park[index].sporalani==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }if(wc==true){
    List.generate(park.length, (index) {
      if(park[index].tuvalet==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }
  if(yemek==true){
    List.generate(park.length, (index) {
      if(park[index].yemeicme==true){
        parkList.add(park[index]);
        notifyListeners();
      }
    });
  }
} else{
      List.generate(park.length, (index) {
          parkList.add(park[index]);
      });
    }


    notifyListeners();
  }

  bool get sports_fields => _sports_fields;

  set sports_fields(bool value) {
    _sports_fields = value;
    notifyListeners();

  }

  bool get bicycle_path => _bicycle_path;

  set bicycle_path(bool value) {
    _bicycle_path = value;
    notifyListeners();

  }

  bool get running_track => _running_track;

  set running_track(bool value) {
    _running_track = value;
    notifyListeners();

  }

  bool get wifi => _wifi;

  set wifi(bool value) {
    _wifi = value;
    notifyListeners();
  }

  ProductRepository get productRepository => _productRepository;

  set productRepository(ProductRepository value) {
    _productRepository = value;
  }
  filterIsClear(){
    if(otopark== true){
      otopark=false;
    }if(wc== true){
     wc=false;
    }if(kultureloge== true){
      kultureloge=false;
    }if(engellidostu==true){
      engellidostu=false;
    }if(oturmaalani==true){
      oturmaalani=false;
    }if(yemek==true){
      yemek=false;
    }if(basketboll==true){
      basketboll=false;
    }if(sports_fields==true){
      sports_fields=false;
    }if(bicycle_path==true){
      bicycle_path=false;
    }if(running_track==true){
      running_track=false;
    }if(wifi==true){
      wifi=false;
    }
    notifyListeners();

  }
}