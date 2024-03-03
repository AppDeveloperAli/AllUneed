import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiv/pages/cartPage/cart_part.dart';
import 'package:fiv/pages/favoritePage/favorite_page.dart';
import 'package:fiv/pages/order/myorder.dart';
import 'package:flutter/material.dart';

import '../pages/homepage/home_page.dart';
import '../pages/login/login_page.dart';
import '../pages/profile/profile_page.dart';
import '../route/routing_page.dart';

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            accountName: Text(userModel.fullName),
            accountEmail: Text(userModel.emailAddress),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage("images/non_profile.jpg"),
            ),
          ),
          ListTile(
            onTap: () {
              RoutingPage.goTonext(
                context: context,
                navigateTo: ProfilePage(),
              );
            },
            leading: const Icon(
              Icons.person,
            ),
            title: const Text("Profile"),
          ),
          ListTile(
            onTap: () {
              RoutingPage.goTonext(
                context: context,
                navigateTo: const CartPage(),
              );
            },
            leading: const Icon(
              Icons.shopping_cart_rounded,
            ),
            title: const Text("Cart"),
          ),
          ListTile(
            onTap: () {
              RoutingPage.goTonext(
                context: context,
                navigateTo: const FavoritePage(),
              );
            },
            leading: const Icon(
              Icons.favorite,
            ),
            title: const Text("Favorite"),
          ),
          ListTile(
            onTap: () {
              RoutingPage.goTonext(
                context: context,
                navigateTo: const MyOrderScreen(),
              );
            },
            leading: const Icon(
              Icons.shopping_basket_sharp,
            ),
            title: const Text("My Order"),
          ),
          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    ),
                  );
            },
            leading: const Icon(
              Icons.exit_to_app,
            ),
            title: const Text("Log out"),
          )
        ],
      ),
    );
  }
}
