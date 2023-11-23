import 'package:flutter/material.dart';
import 'package:local_genie_vendor/app_properties.dart';
import 'package:local_genie_vendor/models/user_modal.dart';
import 'package:local_genie_vendor/services/auth_service.dart';
import 'package:local_genie_vendor/widgets/app_bar.dart';
import 'package:local_genie_vendor/widgets/circular_progress.dart';
import 'package:local_genie_vendor/widgets/network_image.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserI? user;
  void _getUserProfile() async {
    try {
      var _user = await getServiceProvider("1");
      setState(() {
        user = _user;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _getUserProfile);
  }

  Column listColumn(String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      appBar: appBar("My Profile"),
      body: user == null
          ? CircularProgress(colors: Colors.green)
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  if (user?.serviceProviderIconURL == "")
                    const Icon(
                      Icons.person,
                      color: lightGrey,
                      size: 100,
                    ),
                  if (user?.serviceProviderIconURL != "")
                    networkImage(user?.serviceProviderIconURL ?? "",
                        height: 200),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        listColumn(
                          "Name: ",
                          user?.serviceProviderName ?? "",
                        ),
                        const Divider(),
                        if (user?.mobileNumber != "")
                          listColumn(
                            "Mobile: ",
                            user?.mobileNumber ?? "",
                          ),
                        if (user?.mobileNumber != "") const Divider(),
                        if (user?.address != "")
                          listColumn(
                            "Address: ",
                            user?.address ?? "",
                          ),
                        if (user?.address != "") const Divider(),
                        if (user?.pinCode != "")
                          listColumn(
                            "Pincode: ",
                            user?.pinCode ?? "",
                          ),
                        if (user?.pinCode != "") const Divider(),
                        if (user?.businessId != "")
                          listColumn(
                            "Business ID: ",
                            user?.businessId ?? "",
                          ),
                        networkImage(user?.businessIdURL ?? "", height: 400),
                        if (user?.businessId != "") const Divider(),
                        // Image.network(user?.businessIdURL ?? ""),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
