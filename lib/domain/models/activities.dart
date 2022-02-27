class Activity{
  String date;
  String lead;
  String image;
  String description;
  String activity_name;
  String activity_uid;
  String type;
  int total;
  int now;
  String lead_photo;
  List subscribersUid=[];

  Activity.fromJsonMap(Map<String, dynamic> map):
        date=map['date'],
        lead=map['lead'],
        type=map['type'],
        subscribersUid=List.from(map['katılımcılar']),
        activity_uid=map['activity_uid'],
        lead_photo=map['lead_photo'],
      image=map["image"],
        activity_name=map["activity_name"],
        description=map["description"],
        total=map['total_person'],
        now=map['now_person'];

}


class subscribers{
  String uid;
  subscribers.fromJsonMap(Map<String, dynamic> map):
        uid=map['user_uid'];
}
