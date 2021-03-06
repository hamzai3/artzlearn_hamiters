import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'home.dart';
import 'learn.dart';
import 'profile.dart'; 
import 'ExtraDetails.dart';
import 'course_by_cat.dart';
class BottomNav extends StatefulWidget {
  final currentPage, url;

  BottomNav({this.currentPage, this.url});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var _currentIndex = 0;
  ExtraDetails ed  =new ExtraDetails();
  List data;
  bool is_loaded = true;
  String user_type = "0";

  List<BottomNavigationBarItem> bottom_items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: Colors.grey.shade200,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      currentIndex: widget.currentPage,
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.search_rounded,
              color: Colors.grey.shade500,
              size: 26,
            ),
            activeIcon: Icon(
              Icons.search_rounded,
              color: ed.getBlueColor(),
              size: 26,
            ),
            label: "Explore"),
        
        BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_outlined,
              color: Colors.grey.shade500,
              size: 26,
            ),
            activeIcon: Icon(
              Icons.menu_book_outlined,
              color: ed.getBlueColor(),
              size: 26,
            ),
            label: "My Course"),
            
        BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.grey.shade500,
              size: 26,
            ),
            activeIcon: Icon(
              Icons.shopping_cart,
              color: ed.getBlueColor(),
              size: 26,
            ),
            label: "Cart"),
        
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: Colors.grey.shade500,
              size: 26,
            ),
            activeIcon: Icon(
              Icons.person_outline,
              color: ed.getBlueColor(),
              size: 26,
            ),
            label: "Profile"),
      ],
      onTap: (index) {
        _currentIndex = widget.currentPage;
        if (index == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        if (index == 1) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LearnPage()));
        }
        if (index == 2) { Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartList(
                                type: 'cart',
                              ),
                            ),
                          );
        }
        if (index == 3) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        }
      },
    );
  }
}
//for Logout and remove all presvios BACK
//Navigator.of(context).pushNamedAndRemoveUntil('/screen4', (Route<dynamic> route) => false);
