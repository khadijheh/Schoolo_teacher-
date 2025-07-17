import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:schoolo_teacher/core/utils/constants.dart';
import 'package:schoolo_teacher/core/utils/size_config.dart';
import 'package:schoolo_teacher/core/widgets/space_widget.dart';
import 'package:schoolo_teacher/features/profile/presentation/widget/edit_profile_body.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final Teacher teacher = Teacher(
    id: 'tch_789',
    name: 'م. خديجة حسون',
    email: 'ahmed@univ.edu',
    phone: '+966500000000',
    specialization: 'أدرس اللغة البرمجية في البحوث العلميةي',
    joinDate: '15/09/2020',
    imageUrl: 'images/logoo.png',
  );

  double _coverImageHeight = SizeConfig.screenHeight! / 3.5;
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            setState(() {
              _coverImageHeight =
                  SizeConfig.screenHeight! / 3.5 -
                  scrollNotification.scrollDelta!.clamp(0, 150);
            });
          }
          return true;
        },
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: SizeConfig.screenHeight! / 3.5,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: _buildProfileHeader(),
                  ),
                  pinned: true,
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildPersonalInfoSection(),
                  ]),
                ),
              ],
            ),
            Positioned(
              top: SizeConfig.screenHeight! / 3.5,
              right: 20,
              child: _buildEditButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _coverImageHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                // ignore: deprecated_member_use
                primaryColor.withOpacity(0.9),
                // ignore: deprecated_member_use
                primaryColor.withOpacity(0.5),
              ],
            ),
          ),
          child: Image.asset(
            'images/logoo.png',
            fit: BoxFit.cover,
            opacity: AlwaysStoppedAnimation(0.2),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                // ignore: deprecated_member_use
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Hero(
                  tag: 'profileImage',
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(80),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 46,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : AssetImage(teacher.imageUrl) as ImageProvider,
                      ),
                    ),
                  ),
                ),

                HorizontalSpace(1),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.screenWidth! / 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.8),
                              blurRadius: 6,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),

                      VerticalSpace(0.5),
                      Text(
                        teacher.specialization,
                        style: TextStyle(
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.9),
                          fontSize: SizeConfig.screenWidth! / 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor,
                // ignore: deprecated_member_use
                secondaryColor.withOpacity(0.4),
                Colors.grey[50]!,
                // ignore: deprecated_member_use
                primaryColor.withOpacity(0.4),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.defualtSize!),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: primaryColor,
                      size: SizeConfig.defualtSize! * 3,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'profile.personal_info'.tr(),
                      style: TextStyle(
                        fontSize: SizeConfig.defualtSize! * 3,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),

                VerticalSpace(1.5),
                _buildInteractiveInfoTile(
                  Icons.email,
                   'profile.email',
                  teacher.email,
                  primaryColor,
                ),

                _buildInteractiveInfoTile(
                  Icons.phone,
                 'profile.phone',
                  teacher.phone,
                  Colors.green,
                ),

                _buildInteractiveInfoTile(
                  Icons.calendar_today,
                 'profile.join_date', 
                  teacher.joinDate,
                  Colors.orange,
                ),

                _buildInteractiveInfoTile(
                  Icons.badge,
                 'profile.teacher_id',
                  teacher.id,
                  Colors.purple,
                  showCopyButton: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveInfoTile(
    IconData icon,
 String titleKey,    String value,
    Color color, {
    bool showCopyButton = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.defualtSize! * 1.5),
        child: Row(
          children: [
            Container(
              width: SizeConfig.defualtSize! * 5,
              height: SizeConfig.defualtSize! * 5,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color,
                size: SizeConfig.defualtSize! * 3,
              ),
            ),

            HorizontalSpace(1),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   titleKey.tr(), 
                    style: TextStyle(
                      fontSize: SizeConfig.defualtSize! * 2.3,
                      color: primaryColor,
                    ),
                  ),

                  VerticalSpace(0.5),

                  Text(
                    value,
                    style: TextStyle(
                      fontSize: SizeConfig.defualtSize! * 1.5,
                      fontWeight: FontWeight.w500,
                      color: blockColor,
                    ),
                  ),
                ],
              ),
            ),

            if (showCopyButton)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.content_copy,
                    size: 20,
                    color: Colors.grey[700],
                  ),
                  onPressed: () => _copyToClipboard(value),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => _navigateToEditProfile(context),
        backgroundColor: primaryColor,
        elevation: 4,
        child: Icon(
          Icons.edit,
          color: whiteColor,
          size: SizeConfig.defualtSize! * 3.5,
        ),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileBody(
          teacher: teacher,
          profileImage: _selectedImage,
          onImageChanged: (File? newImage) {
            setState(() {
              _selectedImage = newImage;
            });
          },
        ),
      ),
    ).then((_) {
      setState(() {}); 
    });
  }

  void _copyToClipboard(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('profile.copied'.tr()),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
