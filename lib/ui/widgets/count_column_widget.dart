import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildCountColumn extends StatelessWidget {
  const BuildCountColumn({Key? key, required this.text, required this.count})
      : super(key: key);

  final String text;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontSize: 18.0.sp),
        ),
        Text(
          count,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// Column buildColumn({required String text, required String count}) {
//     return Column(
//       children: <Widget>[
//         Text(
//           text,
//           style: Theme.of(context)
//               .textTheme
//               .headline6!
//               .copyWith(fontSize: 18.0.sp),
//         ),
//         Text(
//           count,
//           style: Theme.of(context)
//               .textTheme
//               .headline6!
//               .copyWith(fontSize: 16.0.sp, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }
// }