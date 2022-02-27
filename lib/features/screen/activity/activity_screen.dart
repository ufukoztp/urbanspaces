import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:solution_challenge/features/provider/activity_provider.dart';

class Activity_Screen extends StatefulWidget {
  @override
  _Activity_ScreenState createState() => _Activity_ScreenState();
}

class _Activity_ScreenState extends State<Activity_Screen> with AfterLayoutMixin<Activity_Screen> {
  ActivityProvider _activityProvider;
  @override
  Widget build(BuildContext context) {
    _activityProvider=Provider.of<ActivityProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left:6.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Etkinlikler",style: TextStyle(fontSize: 23.sp,fontWeight: FontWeight.w700),),
            SizedBox(height: 4.h,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  activity_type_button(id: 0,name: "Hepsi",iconName: "asset/ehepsi.png",onpressed: (){
                    _activityProvider.selecteId=0;
                    _activityProvider.select_type="hepsi";
                  },selectedId: _activityProvider.selecteId,),
                  SizedBox(width: 4.w,),
                  activity_type_button(id:1,name: "Spor",iconName: "asset/espor.png",
                  onpressed: (){
                    _activityProvider.selecteId=1;
                    _activityProvider.select_type="spor";

                  },
                      selectedId: _activityProvider.selecteId ),
                  SizedBox(width: 4.w,),
                  activity_type_button(id:2,name: "Müzik",iconName: "asset/emuzik.png",
                    onpressed: (){
                      _activityProvider.selecteId=2;
                      _activityProvider.select_type="müzik";


                    },selectedId: _activityProvider.selecteId),
                  SizedBox(width: 4.w,),
                  activity_type_button(id:3,name: "Sanat",iconName: "asset/esanat.png",
                    onpressed: (){
                      _activityProvider.selecteId=3;
                      _activityProvider.select_type="sanat";


                    },selectedId: _activityProvider.selecteId),
                ],
              ),
            ),
            SizedBox(height: 4.h,),
            Text("Senin için etkinlikler",style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w700),),
            SizedBox(height: 2.h,),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:List.generate(_activityProvider.activities.length, (index) {

                  if(_activityProvider.select_type=="hepsi"){
                    return Activity_Info(index: index,activity_uid: _activityProvider.activities[index].activity_uid ,activityProvider: _activityProvider,activity_name: _activityProvider.activities[index].activity_name,image_url:_activityProvider.activities[index].image,activity_date:_activityProvider.activities[index].date ,activity_lead: _activityProvider.activities[index].lead,
                      now_person: _activityProvider.activities[index].now,total_person: _activityProvider.activities[index].total,activity_description: _activityProvider.activities[index].description,
                      lead_photo:_activityProvider.activities[index].lead_photo ,

                    );
                  }else{
                    if(_activityProvider.select_type==_activityProvider.activities[index].type){
                      return Activity_Info(index: index,activity_uid:  _activityProvider.activities[index].activity_uid,activityProvider: _activityProvider,activity_name: _activityProvider.activities[index].activity_name,image_url:_activityProvider.activities[index].image,activity_date:_activityProvider.activities[index].date ,activity_lead: _activityProvider.activities[index].lead,
                        now_person: _activityProvider.activities[index].now,total_person: _activityProvider.activities[index].total,activity_description: _activityProvider.activities[index].description,
                        lead_photo:_activityProvider.activities[index].lead_photo ,

                      );
                    }else{
                      return Container();
                    }

                  }

                })
                )
              ),


          ],
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async{
  await _activityProvider.getActivities();
  }
}

class Activity_Info extends StatefulWidget {



   Activity_Info({
    Key key,this.image_url,this.activity_date,this.activity_lead,this.now_person,this.total_person,this.activity_description,this.activity_name,this.activityProvider,this.activity_uid,this.index, this.lead_photo
  }) : super(key: key);

  final String image_url;
  final String activity_date;
  final String activity_lead;
  final String activity_uid;
  final String activity_description;
  final String activity_name;
  final String lead_photo;
  final int total_person;
  final int index;
  final ActivityProvider activityProvider;
  int now_person;

  @override
  State<Activity_Info> createState() => _Activity_InfoState();
}

class _Activity_InfoState extends State<Activity_Info> {
  FirebaseAuth _auth ;
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
    super.initState();
    _auth=FirebaseAuth.instance;
  }
  @override
  Widget build(BuildContext context) {
    var activity_description_split;

    activity_description_split=widget.activity_description.split(" ");
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
        new BoxShadow(
        color: Colors.grey.shade50,
        blurRadius: 10.0,
          offset:Offset(0,10)
      ),],),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        shadowColor: Colors.black,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///image
            Container(
              width: 70.w,
              height: 40.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  image: DecorationImage(fit: BoxFit.cover,image: NetworkImage(widget.image_url))
              ),
            ),
            SizedBox(height:4.w),
            Padding(
              padding:  EdgeInsets.only(left:10.0.sp),
              child: Column(
                children: [
                  Text(widget.activity_date,style: TextStyle(color: Colors.grey,fontSize: 12.sp),),
                  SizedBox(height:3.w),
                  Container(
                    width: 65.w,
                    child: Row(children: [
                      Text(widget.activity_name,style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w700),),
                      SizedBox(width: 20.sp,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.activity_lead,style: TextStyle(fontSize: 12.sp),),
                          Text("Düzenleyen",style: TextStyle(color: Colors.grey,fontSize: 7.sp),),
                        ],
                      ),
                      SizedBox(width: 6.sp,),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(100)
                        ,image: DecorationImage(
                          image: NetworkImage(widget.lead_photo)
                        )
                        ),

                        width: 28.sp,
                        height: 28.sp,
                      )
                    ],),
                  ),
                  SizedBox(height:3.w),
                  Container(
                    width: 65.w,
                    child: Row(children: [
                      Text("${widget.now_person}/${widget.total_person} katlımcı",style: TextStyle(fontSize: 10.sp,color: Colors.grey),),
                      SizedBox(width: 34.sp,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on),
                          SizedBox(width: 4.sp,),

                          Text( activity_description_split[0] +"\n"+activity_description_split[1] ,style: TextStyle(color: Colors.black54,fontSize: 9.sp),),
                        ],
                      ),],),
                  ),
                  SizedBox(height:6.w),
                  Container(
                    width: 65.w,
                    child: Row(children: [
                      Container(
                        child: Center(child: Text("İncele",style: TextStyle(color:Color(0xff00524E) ,fontWeight: FontWeight.w700),)),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xff00524E) ),
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        width: 28.w,
                        height: 9.w,
                      ),
                      SizedBox(width: 20.sp,),

                      InkWell(
                        onTap:()async{
                          if(_auth.currentUser ==null){
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

                            bool isJoin=false;
                            for(var x in widget.activityProvider.activities[widget.index].subscribersUid){
                              if(widget.activityProvider.auth.currentUser.uid==x){
                                isJoin=true;
                              }

                            }
                            if(isJoin==false){
                              await widget.activityProvider.saveUser(activity_uid: widget.activity_uid);
                              //  await widget.activityProvider.saveUid(activity_uid: widget.activity_uid);
                              widget.now_person+=1;
                              setState(() {

                              });
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0.sp),
                                    ),
                                    title: Center(child: Text('Kaydınız alınmıştır')),
                                    content: Icon(Icons.check,color: Color(0xff00524E),size: 130.sp,),
                                    actions: [
                                      InkWell(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: Center(
                                          child: Container(
                                            child: Center(child: Text("Kapat",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)),
                                            decoration: BoxDecoration(
                                                color:Color(0xff00524E) ,
                                                borderRadius: BorderRadius.circular(15)
                                            ),
                                            width: 45.w,
                                            height: 9.w,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              );
                            }else{
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    shape:  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0.sp),
                                    ),
                                    content: Text('Bu etkinlikte zaten kaydınız bulunmaktadır.',style: TextStyle(fontWeight: FontWeight.w800),),
                                    actions: [
                                      InkWell(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: Center(
                                          child: Container(
                                            child: Center(child: Text("Kapat",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)),
                                            decoration: BoxDecoration(
                                                color:Color(0xff00524E) ,
                                                borderRadius: BorderRadius.circular(15)
                                            ),
                                            width: 45.w,
                                            height: 9.w,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              );
                            }
                          }
                        },
                        child: Container(
                          child: Center(child: Text("Katıl",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)),
                          decoration: BoxDecoration(
                            color:Color(0xff00524E) ,
                            borderRadius: BorderRadius.circular(15)
                          ),
                          width: 28.w,
                          height: 9.w,
                        ),
                      ),

                    ],),
                  ),
                  SizedBox(height:6.w),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class activity_type_button extends StatelessWidget {
  const activity_type_button({
    Key key,this.name,this.iconName,this.onpressed,this.id,this.selectedId
  }) : super(key: key);

  final String name;
  final String iconName;
  final int id;
  final int selectedId;
  final VoidCallback onpressed;

  @override Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: Container(
        decoration: BoxDecoration(
            color: selectedId!=id?Colors.grey.shade200:Color(0xff00524E),
            borderRadius: BorderRadius.circular(50.sp)
        ),
        width: 23.w,
        height: 18.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:  EdgeInsets.only(top:4.0.w),
              child: Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                    borderRadius: BorderRadius.circular(100)

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(iconName)),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(0)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.w,),
            Expanded(child: Text(name,style: TextStyle(color: selectedId!=id?Colors.black:Colors.white,fontSize: 8.sp,fontWeight: FontWeight.w700),)),

          ],
        ),
      ),
    );
  }
}
