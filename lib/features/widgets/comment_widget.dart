import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:sizer/sizer.dart';
class Comment extends StatefulWidget {
  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {

  List comments=["Test yorumu"];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///input comment
        Form(child: Container
          (
          width:90.w ,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20.sp)
          ),

          child: Padding(
            padding:  EdgeInsets.only(left:3.0.w,right: 3.0.w),
            child: TextFormField(

              keyboardAppearance: Brightness.dark,
              minLines: 1,
              maxLines: 10,
              decoration: InputDecoration(hintText: "Bir düşüncen mi var? Sen de ",border: InputBorder.none,
             suffixIcon: Padding(
               padding:  EdgeInsets.only(top:4.0.w),
               child: InkWell(
                   onTap: (){},
                   child: Text("Paylaş",style: TextStyle(color: Color(0xff00524E),fontWeight: FontWeight.w800,fontSize: 14),)),
             ),
              ),
              style: TextStyle(),
            ),
          ),
        )),
        SizedBox(height: 6.w,),
        Column(children: List.generate(comments.length, (index) {
          return Column(
            children: [
              Container(
                  width: 90.w,
                  child: Card(
                    color: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0.sp),
                    ),
                    child: Padding(
                      padding:  EdgeInsets.only(left: 8.0.w,right: 8.w,bottom: 4.w,top: 4.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 22.w,
                            width: 22.w,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(500)
                            ),
                          ),
                          SizedBox(width: 4.w,),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GFRating( color: Colors.orange,borderColor: Colors.grey,size:5.w ,value: 3),

                              Text("Test yorumu"),
                            ],
                          )),
                        ],
                      ),
                    ),)),
              SizedBox(height: 4.w,),

            ],
          );

        }),)
      ],
    );
  }
}
