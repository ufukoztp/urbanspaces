import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:solution_challenge/domain/models/activities.dart';
import 'package:solution_challenge/domain/repository/repo.dart';

abstract class ActivityProvider_abs{
  void getActivities();
  void saveUser({activity_uid});
  Future saveUid({activity_uid});
}

class ActivityProvider with ChangeNotifier implements ActivityProvider_abs{
  FirebaseAuth auth =FirebaseAuth.instance;

  String _select_type="hepsi";


  String get select_type => _select_type;

  set select_type(String value) {
    _select_type = value;
    notifyListeners();
  }

  ProductRepository _repo=ProductRepository();

  int _selecteId=0;

  int get selecteId => _selecteId;

  set selecteId(int value) {
    _selecteId = value;
    notifyListeners();
  }

  List<Activity> _activities=[];

  List<Activity> get activities => _activities;

  set activities(List<Activity> value) {
    _activities = value;
    notifyListeners();
  }

  @override
  void getActivities() async{
  await _repo.getActivites().then((value) {
    activities=value;
   print( activities[0].subscribersUid[0]);
  });
  }

  @override
  Future saveUser({activity_uid}) async{
   await _repo.saveUser(activity_uid: activity_uid,user_uid: auth.currentUser.uid);
  }

  @override
  Future saveUid({activity_uid}) async{
    await _repo.saveUid(activity_uid: activity_uid,user_uid: auth.currentUser.uid);
  }

  @override
  Future getSubscribersUid({activity_uid}) async{
    await _repo.getSubscribesUid(activity_uid: activity_uid);
  }

}