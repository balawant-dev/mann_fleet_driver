import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../widget/commonAppBar.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Performance",isBack: true,),
      // appBar:AppBar(title: Text("Performance"),) ,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFF1F5F9),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Driver Rating', style: TextStyle(color: Colors.black54),),
                      Spacer(),
                      Icon(Icons.star, color: Colors.amber,),
                    ],
                  ),
                  SizedBox(height: 6,),

                  Row(

                    children: [
                      Text('4.82', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, ),),
                      SizedBox(width: 2,),
                      Padding(
                        padding: EdgeInsets.only(top: 3.0),
                        child: Text('+0.2% this week', style: TextStyle(color: Color(0xff71F7DE), fontSize: 12),),
                      )
                    ],
                  ),
                  SizedBox(height: 6,),
                  RatingBarIndicator(
                    rating: 4.5,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 16,
                  )
                ],
              ),
            ),
            SizedBox(height: 14,),


            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(0xFFF1F5F9),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Acceptance', style: TextStyle(color: Colors.black54)),
                        Text('94%', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.trending_up_rounded, color: Color(0xff71F7DE), size: 14),
                            Text('1.5%', style: TextStyle(color: Color(0xff71F7DE), fontSize: 12))
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(0xFFF1F5F9),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x0C000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Trips', style: TextStyle(color: Colors.black54)),
                        Text('1,240', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.trending_up_rounded, color: Color(0xff71F7DE), size: 14),
                            Text('1.5%', style: TextStyle(color: Color(0xff71F7DE), fontSize: 12))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14,),

            Text('Incentive Eligibility', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),

            SizedBox(height: 14,),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFF1F5F9),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Weekly Trip Goal', style: TextStyle(color: Colors.black87)),
                      Spacer(),
                      Text('42 / 50', style: TextStyle(fontWeight: FontWeight.w600),),
                    ],
                  ),
                  SizedBox(height: 6),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 42 / 50,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(Color(0xff5142AB),
                      ),
                    ),
                  ),

                  Text('8 trips left to unlock \$50 bonus', style: TextStyle(color: Colors.black54, fontSize: 12)),

                  SizedBox(height: 14),

                  Row(
                    children: [
                      Text('Airport Priority Score', style: TextStyle(color: Colors.black87)),
                      Spacer(),
                      Text('92%', style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 92 / 100,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation(Color(0xff71F7DE),
                      ),
                    ),
                  ),

                  Text('8 trips left to unlock \$50 bonus', style: TextStyle(color: Colors.black54, fontSize: 12)),

                ],
              ),
            ),

            SizedBox(height: 10,),

            Container(
              padding: EdgeInsets.only(top: 18, bottom: 12, left: 14, right: 14),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xffFFEDD5),
                ),
                borderRadius: BorderRadius.circular(16),
                color: Color(0xffFFF7ED),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xffFFEDD5),
                        child: Icon(Icons.warning_amber_outlined, size: 26, color: Color(0xffEA580C),
                        ),
                      ),

                      SizedBox(width: 8,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Compliance Warning', style: TextStyle(fontSize: 18, color: Color(0xff7C2D12),
                              fontWeight: FontWeight.bold
                          ),),

                          Text('Your vehicle inspection is due in 3 days.\nComplete it to maintain airport shuttle\naccess. ',
                            style: TextStyle(color: Color(0xff9A3412)),

                          ),

                          SizedBox(height: 14,),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffEA580C),

                            ),
                            child: Center(
                              child: Text('Schedule Now', style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 18, color: Colors.white
                              ),),),
                          ),
                        ],
                      ),


                    ],
                  ),

                ],
              ),

            ),

            SizedBox(height: 14,),

            Text('Recent Feedback', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),

            SizedBox(height: 14,),

            Container(
              padding: EdgeInsets.all(14),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFF1F5F9),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                          radius: 26,
                          backgroundColor: Color(0xffF1F5F9),
                          child: Icon(Icons.messenger_outline, size: 26, color: Color(0xff4E41B4),)
                      ),

                      SizedBox(width: 10,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('"Excellent service!"', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Airport Shuttle • 2 hours ago', style: TextStyle(fontSize: 12, color: Colors.black54),),
                        ],
                      ),

                      Spacer(),

                      Text('View All', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff4E41B4)),),
                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
