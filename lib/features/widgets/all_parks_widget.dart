import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';
import 'package:solution_challenge/features/provider/HomePage_provider.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:solution_challenge/features/screen/activity/activity_screen.dart';
import 'package:solution_challenge/features/widgets/appexpansion.dart';
import 'package:solution_challenge/utils/app_localizations.dart';
import 'package:sizer/sizer.dart';

class AllParkWidget extends StatefulWidget {
  HomePageProvider homePageProvider;
  AllParkWidget({this.homePageProvider});
  @override
  _AllParkWidgetState createState() => _AllParkWidgetState();
}

class _AllParkWidgetState extends State<AllParkWidget> {
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


  Widget detailInfo(int posinited,BuildContext context){
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
                        _homePageProvider.ortRating!=null?
                        Padding(
                          padding:  EdgeInsets.all(2.0.w),
                          child: Text("Park Puanı: "+_homePageProvider.ortRating.ceilToDouble().toString(),style: TextStyle(color: Colors.grey),),
                        ):Text("Henüz puanı yok")
                      ],
                    )
                ),
                Padding(
                  padding:  EdgeInsets.only(left:16.0.w),
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      Expanded(child: Text(_homePageProvider.park[_homePageProvider.parkListPosition].description,style: TextStyle(color: Colors.grey,fontSize: 12),))
                    ],
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
                    padding:  EdgeInsets.only(right:1.0.h),
                    child: Container(
                      child: Center(child: Text("Götür",style: TextStyle(color: Colors.white),)),
                      decoration: BoxDecoration(
                          color: Color(0xff00524E),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      height: 40,
                      width: 140,
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

  String all="Hepsi";
  String engelli="Engelli Dostu";
  String fitness="Fitness Alanı";
  String eating="Yeme İçme";
  String wc="WC";
  String culture="Kültürel Öğe";
  String car_park="Otopark";
  String basketboll="Basketbol";
  String sports="Spor Alanı";
  String bicycle="Bisiklet Alanı";
  String running="Koşu Alanı";
  String wi_fi="Wi-Fi";

List titles=[];
  @override
  void initState() {
    // TODO: implement initState
    _homePageProvider=widget.homePageProvider;
    titles.add(all);
    titles.add(engelli);
    titles.add(fitness);
    titles.add(eating);
    titles.add(wc);
    titles.add(culture);
    titles.add(car_park);
    titles.add(basketboll);
    titles.add(sports);
    titles.add(bicycle);
    titles.add(running);
    titles.add(wi_fi);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        Padding(
          padding:  EdgeInsets.only(left:4.w,bottom: 4.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:List.generate(titles.length, (index) => Padding(
                padding:  EdgeInsets.all(3.0.w),
                child: activity_type_button(
                    id:index,name: titles[index],iconName: "asset/ehepsi.png",
                    onpressed: (){
                      _homePageProvider.selectId=index;
                    },
                  selectedId: _homePageProvider.selectId,
                ),
              ),)
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left:7.0.w,bottom: 2.w,top:2.w),
              child: Text("Yakından Uzağa",style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold),),
            ),
            Column(
              children: List.generate(_homePageProvider.park.length, (index) {
                return  InkWell(
                    onTap: () async{
                      //   await _homePageProvider.moveCamera();
                      /*

                        await _homePageProvider.panelController.open();

                         */

                    },
                    child:
                    Stack(
                      children: [

                        Center(
                          child: Padding(
                            padding:  EdgeInsets.only(top:4.w,bottom:5.w),
                            child: Container(
                              width: 90.0.w,
                              decoration:
                              BoxDecoration(
                                  boxShadow: [BoxShadow(color: Colors.black38,offset: Offset(-3,3),blurRadius: 10)],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Column(
                                children: [
                                  Row(

                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.all(3.0.w),
                                        child: Container(
                                          height: 90,
                                          width: 22.w,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  20),
                                              image: DecorationImage(
                                                  image: NetworkImage(  _homePageProvider.park[index].photo!=""?_homePageProvider.park[index].photo:"https://firebasestorage.googleapis.com/v0/b/yesil-ea967.appspot.com/o/yildiz-parki-1.jpg?alt=media&token=09388921-6388-428c-8c73-fffa6e603749"),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _homePageProvider.park[index].title.toUpperCase(),
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
                                                  visible: _homePageProvider.park[index].engellidostu==true?true:false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Icon(Icons.accessible,color:Color(0xff00524E),size: 15,),
                                                  ),
                                                ),

                                                Visibility(
                                                  visible: _homePageProvider.park[index].tuvalet==true?true:false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Icon(Icons.wc,color:Color(0xff00524E),size: 15),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible:_homePageProvider.park[index].yemeicme==true?true:false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Icon(Icons.free_breakfast,color:Color(0xff00524E),size: 15),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _homePageProvider.park[index].kultureloge==true?true:false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Icon(Icons.museum,color:Color(0xff00524E),size: 15),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _homePageProvider.park[index].otopark==true?true:false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Icon(Icons.directions_car,color:Color(0xff00524E),size: 15),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _homePageProvider.park[index].oturmaalani==true?true:false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Icon(Icons.airline_seat_recline_normal,color:Color(0xff00524E),size: 15),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _homePageProvider.park[index].basketbol==true?true:false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Icon(Icons.sports_basketball_rounded,color:Color(0xff00524E),size: 15),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _homePageProvider.park[index].sporalani==true?true:false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Icon(Icons.sports_mma_sharp,color:Color(0xff00524E),size: 15),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _homePageProvider.park[index].bisikletyolu==true?true:false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Icon(Icons.directions_bike_outlined,color:Color(0xff00524E),size: 15),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _homePageProvider.park[index].kosuparkuru==true?true:false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(2.0),
                                                    child: Icon(Icons.directions_run_outlined,color:Color(0xff00524E),size: 15),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: _homePageProvider.park[index].wifi==true?true:false,
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
                                                  _homePageProvider.park[index].description.toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize:8.0, fontWeight: FontWeight.w500,color: Colors.grey),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),


                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        )


                      ],
                    )
                );


              }),
            ),
          ],
        )
      ],
    );
  }
}
Widget detailCard({   String title,  IconData icon,  bool enabled,  String content,BuildContext context}){
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
