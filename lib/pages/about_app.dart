import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  static const String id = 'about_app';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
              child: Center(child: Text('Code For Iraq', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)),
            ),
            Text('وهي مبادرة إنسانية غير ربحية تهدف الى خدمة المجتمع عن طريق البرمجة، تعتبر هذه المبادرة مبادرة تعليمية حقيقية ترعى المهتمين بتعلم تصميم وبرمجة تطبيقات الهاتف الجوال ومواقع الانترنت وبرامج الحاسوب والشبكات والاتصالات ونظم تشغيل الحاسوب باستخدام التقنيات مفتوحة المصدر كما توفر لهم جميع الدروس التعليمية اللازمة وبشكل مجاني تماما بل الاهم من ذلك تعتمد على مبدا المواطنة والمشاركة الفاعلة في تأسيس وبناء المجتمع تدعو هذه المبادرة جميع الطلبة والخريجين والهواة والاساتذة الجامعيين والمهتمين مجال البرمجة وتقنيات المعلومات وكذلك الاختصاصات الأخرى السب التطوع والمشاركة الفعلية لأجل الارتقاء بواقع البلد, حيث تعتبر فرصة عظيمة اكتساب الخبرة والمهارة عن طريق تصميم وتنفيذ برامج وتطبيقات خدمية من شأنها خدمة المواطن وذلك ضمن مجاميع عمل نشطة وفعالة يتعاون فيها جميع الافراد كفريق واحد تبادل الآراء والخبرات ويطرح الافكار ليتم مناقشتها وتطبيقها على أرض الواقع, كما تفتح المجال لجميع المواطنين العراقيين ومن جميع الاختصاصات الى المشاركة الفاعلة في هذه المشاريع لرفد الفريق بالخبرات والأفكار والآراء والمقترحات التي من شأنها خدمة المجتمع بأفضل ما يمكن'
            ,style: TextStyle(fontSize: 16),textAlign: TextAlign.right,),

            Divider(),
            Text('فكرة تطبيقنا هوة تطبيق يحتوي على أماكن جميع الناس الذين يحتاجون الى المساعدة تظهر في خريطة سيكون هذا التطبيق وسيلة لمساعدة الناس الذين بحاجة الى المساعدة الفورية سواء كانت المساعدة طبية او إنسانية او أي مساعدة أخرى بأمكان المستخدمين ايضا طلب المساعدة في حال حصل حريق اوأي امر طارئ آخر واضافة تلك الحالة على الخريطة وسوف يستطيع الأشخاص القريبين منه على الخريطة تقديم المساعدة',
            style: TextStyle(fontSize: 16),textAlign: TextAlign.right),
            Divider(),

            Center(child: Text('مطور التطبيق', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)),

            SizedBox(height: 10.0,),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/me.jpg'),
              ),
            ),

            SizedBox(height: 5.0,),
            Center(child: Text('Ameer Ali', style: TextStyle(fontSize: 18),)),
            Center(child: Text('ameerali10020@gmail.com', style: TextStyle(fontSize: 18),)),
            SizedBox(height: 5.0,),
            Divider(),
          ],
        ),
      ),
    );
  }
}
