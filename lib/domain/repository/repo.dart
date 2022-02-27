import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solution_challenge/domain/models/activities.dart';
import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/repository/remote_source.dart';

abstract class ProductRepositoryAbs{
Future getParkList();
Future setRating(String parkname,var uid,double rating);
Future<double> getRating(String parkname);
Future<double> getUserRating(String parkname,var uid);
Future setActiviy(idenfitier,state);
Future<List<Activity>> getActivites();
Future saveUser({activity_uid,user_uid});
Future saveUid({activity_uid,user_uid});

}

class ProductRepository implements ProductRepositoryAbs{
  Remote _remote=Remote();

  @override
  Future<List<Parks>> getParkList({List<String> filterlist}) async{
   try{

     List<Parks> parkList=await _remote.getParkList(filterList: filterlist);

    print("product repo: "+ parkList[0].photo);


  return parkList;

   } catch(e){
   print(e.toString());

   List<Parks> parkList=[Parks(description: '', coords1: '', title: '', photo: '',coords2:'',),];
   return parkList;
    }
  }

  Future setRating(String parkname,var uid,double rating) async{
    try{
      await _remote.setRating(parkname, uid, rating);


    } catch(e){
      print(e.toString());

    }
  }

  Future<double> getRating(String parkname) async{
    try{
      var d= await _remote.getRating(parkname);
      print(d);
      return d;

    } catch(e){
      print(e.toString());
      return 0.0;
    }
  }

  Future<double> getUserRating(String parkname,var uid) async{
    try{
      var d= await _remote.getuUserRating(parkname,uid);
      print(d);
      return d;

    } catch(e){
      print(e.toString());
      return 0.0;

    }
  }

  @override
  Future setActiviy(idenfitier,state) async{
    await _remote.setActiviy(idenfitier, state);
  }

  @override
  Future<List<Activity>> getActivites() async{
    List<Activity> d =[];
  d=  await _remote.getActivities();
  return d;
  }

  @override
  Future saveUser({activity_uid,user_uid}) async {
   await _remote.saveUser( activity_uid: activity_uid,user_uid: user_uid);
  }
  Future saveUid({activity_uid,user_uid}) async {
    await _remote.saveUid( activity_uid: activity_uid,user_uid: user_uid);
  }

  Future<List<subscribers>> getSubscribesUid({activity_uid}) async {
   return await _remote.getSubscribesUid( activity_uid: activity_uid);
  }

}