import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:provider/provider.dart';
import 'package:volt_arena/consts/my_icons.dart';
import 'package:volt_arena/provider/dark_theme_provider.dart';
import 'package:volt_arena/search.dart';
import 'package:volt_arena/user_info.dart';
import 'package:flutter/material.dart';
import 'package:volt_arena/wishlist/wishlist.dart';
import 'cart/cart.dart';
import 'feeds.dart';
import 'orders/order.dart';
import 'user_info.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';
  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  // List<Map<String, Object>> _pages;
  ScrollController? _scrollController;
  var top = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _email;
  String? _joinedAt;
  String? _userImageUrl;
  int? _phoneNumber;
  @override
  void initState() {
    pages = [
      Feeds(),
      Search(),
      MyBookingsScreen(),
      // UserInfo(),
    ];
    //
    super.initState();
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      setState(() {});
    });
    getData();
  }

  void getData() async {
    User user = _auth.currentUser!;
    _uid = user.uid;

    print('user.displayName ${user.displayName}');
    print('user.photoURL ${user.photoURL}');
    DocumentSnapshot<Map<String, dynamic>>? userDoc = user.isAnonymous
        ? null
        : await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    // .then((value) {
    // if (user.isAnonymous) {
    //   userDoc = null;
    // } else {
    //   userDoc = value;
    // }
    // });
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        _name = userDoc.get('name');
        _email = user.email!;
        _joinedAt = userDoc.get('joinedAt');
        _phoneNumber = userDoc.get('phoneNumber');
        _userImageUrl = userDoc.get('imageUrl');
      });
    }
    // print("name $_name");
  }

  int _selectedPageIndex = 0;
  late List pages;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      body: pages[_selectedPageIndex], //_pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        // color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 0.01,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: kBottomNavigationBarHeight * 0.98,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              onTap: _selectPage,
              backgroundColor: Theme.of(context).primaryColor,
              unselectedItemColor: Theme.of(context).textSelectionColor,
              selectedItemColor: Colors.deepOrange,
              currentIndex: _selectedPageIndex,
              // selectedLabelStyle: TextStyle(fontSize: 16),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.room_service), label: 'Services'),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyAppIcons.search,
                    ),
                    label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(
                      MyAppIcons.bag,
                    ),
                    label: 'My Bookings'),
                // BottomNavigationBarItem(
                //     icon: Icon(MyAppIcons.user), label: 'User'),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage("assets/images/person.png"),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: userTitle(title: 'User Bag')),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () =>
                      Navigator.of(context).pushNamed(WishlistScreen.routeName),
                  splashColor: Colors.red,
                  child: ListTile(
                    title: Text('Wishlist'),
                    trailing: Icon(Icons.chevron_right_rounded),
                    leading: Icon(MyAppIcons.wishlist),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(MyBookingsScreen.routeName);
                },
                title: Text('My Bookings'),
                trailing: Icon(Icons.chevron_right_rounded),
                leading: Icon(MyAppIcons.cart),
              ),
              ListTile(
                onTap: () =>
                    Navigator.of(context).pushNamed(OrderScreen.routeName),
                title: Text('Completed Sessions'),
                trailing: Icon(Icons.chevron_right_rounded),
                leading: Icon(MyAppIcons.bag),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: userTitle(title: 'User Information'),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              userListTile('Email', _email ?? '', 0, context),
              userListTile('Phone number', _phoneNumber.toString(), 1, context),
              // userListTile('Shipping address', '', 2, context),
              userListTile('joined date', _joinedAt ?? '', 3, context),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: userTitle(title: 'User settings'),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              ListTileSwitch(
                value: themeChange.darkTheme,
                leading: Icon(FontAwesomeIcons.moon),
                onChanged: (value) {
                  setState(() {
                    themeChange.darkTheme = value;
                  });
                },
                visualDensity: VisualDensity.comfortable,
                switchType: SwitchType.cupertino,
                switchActiveColor: Colors.indigo,
                title: Text('Dark theme'),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: Theme.of(context).splashColor,
                  child: ListTile(
                    onTap: () async {
                      // Navigator.canPop(context)? Navigator.pop(context):null;
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Image.network(
                                      'https://image.flaticon.com/icons/png/128/1828/1828304.png',
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Sign out'),
                                  ),
                                ],
                              ),
                              content: Text('Do you wanna Sign out?'),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel')),
                                TextButton(
                                    onPressed: () async {
                                      await _auth.signOut().then(
                                          (value) => Navigator.pop(context));
                                    },
                                    child: Text(
                                      'Ok',
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            );
                          });
                    },
                    title: Text('Logout'),
                    leading: Icon(Icons.exit_to_app_rounded),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    //starting fab position
    final double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 160.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController!.hasClients) {
      double offset = _scrollController!.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down

        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down

        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          heroTag: "btn1",
          onPressed: () {},
          child: Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }

  List<IconData> _userTileIcons = [
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.exit_to_app_rounded
  ];

  Widget userListTile(
      String title, String subTitle, int index, BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      leading: Icon(_userTileIcons[index]),
    );
  }

  Widget userTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
