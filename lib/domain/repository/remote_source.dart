import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solution_challenge/domain/models/activities.dart';
import 'package:solution_challenge/domain/models/parks.dart';
import 'package:solution_challenge/domain/models/tasks.dart';

abstract class Remote_abs{
  Future<List<Parks>> getParkList({List<String> filterList});
  Future<List<Tasks>> getTaskPhoto();
  Future<bool> getTaskState({taskName, uid});
  Future setRating(String parkname,var uid,double rating);
  Future setNote(var rating);
  Future<double> getRating(String parkname);
  Future<double> getuUserRating(String parkname,var uid);
  Future setTaskState({uid,   bool state, taskName});
  Future setLevel({uid,level});
  Future<int> getLevel({uid,level});
  Future setActiviy(idenfitier,state);
  Future getActivities();
  Future saveUser({activity_uid,user_uid});
  Future saveUid({activity_uid,user_uid});

}
class Remote implements Remote_abs{
  Query query =
  FirebaseFirestore.instance.collection('parklist');


///parklist
  Future<List<Parks>> getParkList({List<String> filterList})async{

    print("servis katmanı filter: "+filterList.toString());
    List<Parks> parkList=[];

    if(filterList.length==0){
      await query.get().then((querySnapshot) async {
        print(querySnapshot.size.toString()+'  gelen park sayısı sss');

        querySnapshot.docs.forEach((document) {
          Map<String,dynamic> t=document.data() as Map<String,dynamic>;
          print(t["title"]);

          parkList.add(Parks.fromJsonMap(t));
          print(Parks.fromJsonMap(t).title);

        });

      });
    }else{
      switch(filterList.length){
        case 1:
          await query.where(filterList[0],isEqualTo: true).get().then((querySnapshot) async {
            print(querySnapshot.size.toString()+'  gelen park sayısı ${filterList.length}');

            querySnapshot.docs.forEach((document) {
              Map<String,dynamic> t=document.data() as Map<String,dynamic>;
              print(t["title"]);

              parkList.add(Parks.fromJsonMap(t));
              print(Parks.fromJsonMap(t).title);

            });

          });
          break;
        case 2:
          await query.where(filterList[0],isEqualTo: true).where(filterList[1],isEqualTo: true).get().then((querySnapshot) async {
            print(querySnapshot.size.toString()+'  gelen park sayısı ${filterList.length}');

            querySnapshot.docs.forEach((document) {
              Map<String,dynamic> t=document.data() as Map<String,dynamic>;
              print(t["title"]);

              parkList.add(Parks.fromJsonMap(t));
              print(Parks.fromJsonMap(t).title);

            });

          });
          break;
        case 3:
          await query.where(filterList[0],isEqualTo: true).where(filterList[1],isEqualTo: true).where(filterList[2],isEqualTo: true).get().then((querySnapshot) async {
            print(querySnapshot.size.toString()+'  gelen park sayısı ${filterList.length}');

            querySnapshot.docs.forEach((document) {
              Map<String,dynamic> t=document.data() as Map<String,dynamic>;
              print(t["title"]);

              parkList.add(Parks.fromJsonMap(t));
              print(Parks.fromJsonMap(t).title);

            });

          });
          break;
        case 4:
          await query.where(filterList[0],isEqualTo: true).where(filterList[1],isEqualTo: true).where(filterList[2],isEqualTo: true).where(filterList[3],isEqualTo: true).get().then((querySnapshot) async {
            print(querySnapshot.size.toString()+'  gelen park sayısı ${filterList.length}');

            querySnapshot.docs.forEach((document) {
              Map<String,dynamic> t=document.data() as Map<String,dynamic>;
              print(t["title"]);

              parkList.add(Parks.fromJsonMap(t));
              print(Parks.fromJsonMap(t).title);

            });

          });
          break;
        case 5:
          await query.where(filterList[0],isEqualTo: true).where(filterList[1],isEqualTo: true).where(filterList[2],isEqualTo: true).where(filterList[3],isEqualTo: true).where(filterList[4],isEqualTo: true).get().then((querySnapshot) async {
            print(querySnapshot.size.toString()+'  gelen park sayısı ${filterList.length}');

            querySnapshot.docs.forEach((document) {
              Map<String,dynamic> t=document.data() as Map<String,dynamic>;
              print(t["title"]);

              parkList.add(Parks.fromJsonMap(t));
              print(Parks.fromJsonMap(t).title);

            });

          });
          break;
        case 6:
          await query.where(filterList[0],isEqualTo: true).where(filterList[1],isEqualTo: true).where(filterList[2],isEqualTo: true).where(filterList[3],isEqualTo: true).where(filterList[4],isEqualTo: true).where(filterList[5],isEqualTo: true).get().then((querySnapshot) async {
            print(querySnapshot.size.toString()+'  gelen park sayısı');

            querySnapshot.docs.forEach((document) {
              Map<String,dynamic> t=document.data() as Map<String,dynamic>;
              print(t["title"]);

              parkList.add(Parks.fromJsonMap(t));
              print(Parks.fromJsonMap(t).title);

            });

          });
          break;
        case 7:
          await query.where(filterList[0],isEqualTo: true).where(filterList[1],isEqualTo: true).where(filterList[2],isEqualTo: true).where(filterList[3],isEqualTo: true).where(filterList[4],isEqualTo: true).where(filterList[5],isEqualTo: true).where(filterList[6],isEqualTo: true).get().then((querySnapshot) async {
            print(querySnapshot.size.toString()+'  gelen park sayısı');

            querySnapshot.docs.forEach((document) {
              Map<String,dynamic> t=document.data() as Map<String,dynamic>;
              print(t["title"]);

              parkList.add(Parks.fromJsonMap(t));
              print(Parks.fromJsonMap(t).title);

            });

          });
          break;
        case 8:
          await query.where(filterList[0],isEqualTo: true).where(filterList[1],isEqualTo: true).where(filterList[2],isEqualTo: true).where(filterList[3],isEqualTo: true).where(filterList[4],isEqualTo: true).where(filterList[5],isEqualTo: true).where(filterList[6],isEqualTo: true).where(filterList[7],isEqualTo: true).get().then((querySnapshot) async {
            print(querySnapshot.size.toString()+'  gelen park sayısı');

            querySnapshot.docs.forEach((document) {
              Map<String,dynamic> t=document.data() as Map<String,dynamic>;
              print(t["title"]);

              parkList.add(Parks.fromJsonMap(t));
              print(Parks.fromJsonMap(t).title);

            });

          });
          break;
        case 9:
          await query.where(filterList[0],isEqualTo: true).where(filterList[1],isEqualTo: true).where(filterList[2],isEqualTo: true).where(filterList[3],isEqualTo: true).where(filterList[4],isEqualTo: true).where(filterList[5],isEqualTo: true).where(filterList[6],isEqualTo: true).where(filterList[7],isEqualTo: true).where(filterList[8],isEqualTo: true).get().then((querySnapshot) async {
            print(querySnapshot.size.toString()+'  gelen park sayısı');

            querySnapshot.docs.forEach((document) {
              Map<String,dynamic> t=document.data() as Map<String,dynamic>;
              print(t["title"]);

              parkList.add(Parks.fromJsonMap(t));
              print(Parks.fromJsonMap(t).title);

            });

          });
          break;
        case 10:
          await query.where(filterList[0],isEqualTo: true).where(filterList[1],isEqualTo: true).where(filterList[2],isEqualTo: true).where(filterList[3],isEqualTo: true).where(filterList[4],isEqualTo: true).where(filterList[5],isEqualTo: true).where(filterList[6],isEqualTo: true).where(filterList[7],isEqualTo: true).where(filterList[8],isEqualTo: true).where(filterList[9],isEqualTo: true).get().then((querySnapshot) async {
            print(querySnapshot.size.toString()+'  gelen park sayısı');

            querySnapshot.docs.forEach((document) {
              Map<String,dynamic> t=document.data() as Map<String,dynamic>;
              print(t["title"]);

              parkList.add(Parks.fromJsonMap(t));
              print(Parks.fromJsonMap(t).title);

            });

          });
          break;
        case 11:
          await query.where(filterList[0],isEqualTo: true).where(filterList[1],isEqualTo: true).where(filterList[2],isEqualTo: true).where(filterList[3],isEqualTo: true).where(filterList[4],isEqualTo: true).where(filterList[5],isEqualTo: true).where(filterList[6],isEqualTo: true).where(filterList[7],isEqualTo: true).where(filterList[8],isEqualTo: true).where(filterList[9],isEqualTo: true).where(filterList[10],isEqualTo: true).get().then((querySnapshot) async {
            print(querySnapshot.size.toString()+'  gelen park sayısı');

            querySnapshot.docs.forEach((document) {
              Map<String,dynamic> t=document.data() as Map<String,dynamic>;
              print(t["title"]);

              parkList.add(Parks.fromJsonMap(t));
              print(Parks.fromJsonMap(t).title);

            });

          });
          break;
      }
    }




    return parkList;

}

  ///photos
  Future<List<Tasks>> getTaskPhoto()async{
    List<Tasks> d=[];
    Query query =
    FirebaseFirestore.instance.collection('gorevler');
    List<String> photoList=[];

     await query.get().then((querySnapshot) async {

      querySnapshot.docs.forEach((document)async {

        Map<String,dynamic> t= document.data() as  Map<String,dynamic>;
       d.add( Tasks.fromJsonMap(t));

      });
    });

     return d;

  }

  Future<bool> getTaskState({taskName, uid})async{
          DocumentReference query2 = FirebaseFirestore.instance.collection('gorevler').doc(taskName).collection('users').doc(uid);
           bool t;
          
    await query2.get().then((querySnapshot) async {
      if(querySnapshot.data()!=null){
        var d =querySnapshot.data() as Map;
        d.forEach((key, value) {
          t=value;
          print('task'+t.toString());

        });
      }else{
      t=false;

    }


    });

    return t;

  }



  ///ratings
  Future setRating(String parkname,var uid,double rating) async{

  DocumentReference query2 =  FirebaseFirestore.instance.collection('stars').doc(parkname).collection('users').doc(uid);

   await query2.set({
    'value': rating
  });
}

  Future setNote(var rating) async{

    DocumentReference query2 =  FirebaseFirestore.instance.collection('note').doc(rating);

    await query2.set({
      'value': rating
    });
  }


  Future<double> getRating(String parkname)async {
    double rating=0;
   int ratingCount;
    double ortrating=0;

  CollectionReference ratingList =  FirebaseFirestore.instance.collection('stars').doc(parkname).collection('users');
  await ratingList.get().then((value) {
     ratingCount=value.docs.length;
     value.docs.forEach((element) {

       Map map=element.data() as Map;
       rating=rating + map["value"];
     });
      ortrating= rating/ratingCount;
     print(ortrating.toString() +"remote");
   });

    return  ortrating;


}

  Future<double> getuUserRating(String parkname,var uid)async {
    double rating=0;

    DocumentReference ratingList =  FirebaseFirestore.instance.collection('stars').doc(parkname).collection('users').doc(uid);
    await ratingList.get().then((value) {
      Map d=value.data() as  Map<String,dynamic>;
      rating=d['value'];
      print(value.data().toString()+"user rating");
    });

    return  rating;


  }

  Future setTaskState({uid,   bool state, taskName})async{
    DocumentReference query2 = FirebaseFirestore.instance.collection('gorevler').doc(taskName).collection('users').doc(uid);

    query2.set({
      'complete':true
    });

  }

  Future setLevel({uid,level})async{
    DocumentReference query2 = FirebaseFirestore.instance.collection('USERSLEVEL').doc(uid);
    int levelNew= level+1;
    query2.set({
      'level':levelNew
    });

  }

  Future<int> getLevel({uid,level})async{
     int level;
    DocumentReference query2 =  FirebaseFirestore.instance.collection('USERSLEVEL').doc(uid);
     await query2.get().then((value) {
     Map d=  value.data() as Map;
     if(d!=null)
     level=d['level'];

     });

    print('levels: '+level.toString());

    return  level;
  }

  @override
  Future setActiviy(idenfitier,state)async {
    if(state =="ENTER"){
    await  FirebaseFirestore.instance.collection('parklist').doc(idenfitier).update(
          {
            "TotalActivity":FieldValue.increment(1),
            "InstantActivity":FieldValue.increment(1)


          });
    }if(state=="EXIT"){

     await FirebaseFirestore.instance.collection('parklist').doc(idenfitier).update(
          {
            "InstantActivity":FieldValue.increment(-1)


          });
    }
  }

  @override
  Future<List<Activity>> getActivities()async {
    CollectionReference query2 = FirebaseFirestore.instance.collection('activity');
    List<Activity> d=[];

    await query2.get().then((querySnapshot) async {

      querySnapshot.docs.forEach((document)async {

        Map<String,dynamic> t= document.data() as  Map<String,dynamic>;
        d.add( Activity.fromJsonMap(t));

      });
    });

    return d;
  }

  @override
  Future saveUser({activity_uid, user_uid}) async{
    DocumentReference query2 = FirebaseFirestore.instance.collection('activity').doc(activity_uid);
   await query2.update({
      'now_person':FieldValue.increment(1)
    });
    await query2.update({
      'katılımcılar':FieldValue.arrayUnion([user_uid])
    });
  }

  @override
  Future saveUid({activity_uid,user_uid}) async{
    DocumentReference query2 = FirebaseFirestore.instance.collection('activity').doc(activity_uid).collection("katılımcılar").doc(user_uid);
    await query2.set({
      'user_uid':user_uid
    });
  }

  @override
  Future<List<subscribers>> getSubscribesUid({activity_uid}) async{
    CollectionReference query2 = FirebaseFirestore.instance.collection('activity').doc(activity_uid).collection("katılımcılar");

    List<subscribers> d=[];

    await query2.get().then((querySnapshot) async {

      querySnapshot.docs.forEach((document)async {

        Map<String,dynamic> t= document.data() as  Map<String,dynamic>;
        d.add( subscribers.fromJsonMap(t));
      });
      return d;
    });
  }

}