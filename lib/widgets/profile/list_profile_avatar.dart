import 'package:crowdleague/actions/profile/delete_profile_pic.dart';
import 'package:crowdleague/actions/profile/select_profile_pic.dart';
import 'package:crowdleague/actions/profile/update_profile_page.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/profile/profile_pic.dart';
import 'package:crowdleague/widgets/shared/confirmation_alert.dart';
import 'package:flutter/material.dart';

class ListProfileAvatar extends StatelessWidget {
  final ProfilePic _pic;

  ListProfileAvatar({ProfilePic profilePic}) : _pic = profilePic;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 90,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: (_pic.deleting) ? null : 1,
            strokeWidth: 8,
          ),
          GestureDetector(
            child: CircleAvatar(
                radius: 45, backgroundImage: Image.network(_pic.url).image),
            onTap: () {
              context.dispatch(SelectProfilePic(picId: _pic.id));
              context.dispatch(UpdateProfilePage(
                  leaguerPhotoURL: _pic.url, selectingProfilePic: false));
            },
            onLongPress: () async {
              final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) => ConfirmationAlert(
                      question: 'Are you sure you want to delete the pic?'));

              if (confirmed) context.dispatch(DeleteProfilePic(pic: _pic));
            },
          )
        ],
      ),
    );
  }
}
