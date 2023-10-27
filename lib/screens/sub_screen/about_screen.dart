import 'package:flutter/material.dart';

import '../../components/my_appbar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: 'About',
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Did you know?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/about_img_1.png'),
            const SizedBox(height: 10),
            const Text(
              'Millions of Stray Animals is Awaiting You to Take Them Home',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'According to The Institut Pasteur Du Cambodge, there are around 5 million dogs in Cambodia, most of them strays. The situation for cats is even worse. Lack of means and access to vet care forces people to abandon their cats and dogs, often at pagodas which are thought to be a safe haven. Unfortunately, pagodas are not safe for animals. The monks and residents are often overwhelmed by the large numbers, sharing the little they have with the cats, dogs, and other abandoned animals.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 35),
            const Text(
              'Our Solution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Image.asset('assets/images/about_img_2.png'),
            const SizedBox(height: 10),
            const Text.rich(
              TextSpan(
                text: '“',
                children: <TextSpan>[
                  TextSpan(
                    text: 'AdoptMe',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                      text:
                          '” is an application created by three IT students from Limkokwing University who are passionate about helping the community. The application aims to provide comfortable homes for less fortunate pets, such as strays and pets that need relocation. This will be achieved by connecting pet lovers all around Cambodia and providing them with a platform to connect and share pet relocation postings. Ultimately, the goal is to reduce the number of less fortunate pets and foster a more loving community'),
                ],
              ),
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            const Text(
              'Our Team',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisExtent: 250,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _buildCircularImageWithBorder(
                      myDataList[index].imageUrl, myDataList[index].text);
                },
                itemCount:
                    myDataList.length, // Adjust the number of items as needed
              ),
            ),
            Stack(
              children: [
                Image.asset('assets/images/about_img_2.png'),
                const Positioned(
                  top: 25, // Align to the top
                  left: 0, // Align to the left
                  right: 0, // Align to the right
                  child: Center(
                    child: Text(
                      'Why Shop?\nWhen You Can Adopt!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black, // Set the text color
                        fontSize: 32, // Set the font size
                        fontWeight: FontWeight.bold, // Set the font weight
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCircularImageWithBorder(String imageUrl, String nameText) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black, // Set the border color here
                  width: 1.0, // Set the border width here
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              nameText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}

class ImageTextData {
  final String imageUrl;
  final String text;

  ImageTextData(this.imageUrl, this.text);
}

final List<ImageTextData> myDataList = [
  ImageTextData(
    'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
    'Hong Narethputponleu',
  ),
  ImageTextData(
    'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
    'Sreng Kuong',
  ),
  ImageTextData(
    'https://img.freepik.com/premium-vector/man-avatar-profile-picture-vector-illustration_268834-538.jpg',
    'Heng Vysedh',
  ),
];
