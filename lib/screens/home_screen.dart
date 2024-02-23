import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:smart_home/components/location.dart';
import 'package:smart_home/components/tab_bar_home.dart';
import 'package:smart_home/constants/path_images.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_styles.dart';
import 'package:smart_home/styles/app_text.dart';
import 'package:smart_home/utilities/caculate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.asset(PathImage.im_home,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover)
            .blurred(
          colorOpacity: 0.2,
          borderRadius: BorderRadius.horizontal(right: Radius.circular(5)),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Color.fromARGB(255, 238, 241, 242).withOpacity(1),
        ),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: AppStyles.paddingBothSidesPage),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 55,
                ),
              ),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    // CircleAvatar(
                    //   maxRadius: 25,
                    //   backgroundImage: NetworkImage(
                    //       'https://scontent.fdad3-4.fna.fbcdn.net/v/t39.30808-6/306135507_1211755559394586_7445899947695751742_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=9c7eae&_nc_eui2=AeG3XOU_FtPpLfAhVhnb4qJdhSPDzNnfc2iFI8PM2d9zaLRhiP2fvg7dEF11BeY4FSJunVUN8DrYOX5-pTLhc53R&_nc_ohc=c2nk4Fgzlw8AX_tYfi6&_nc_ht=scontent.fdad3-4.fna&oh=00_AfByyXoB50Mkdn2cz_-LPDeymEv05B9oWfn5C3Plm-VcXg&oe=65D8AA7E'),
                    // ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Hi, ',
                              style: AppText.heading4
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text('Cao Nam',
                                style: AppText.heading4
                                    .copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Text('Wellcome to smart home',
                            style:
                                AppText.medium.copyWith(color: Colors.black54))
                      ],
                    ),
                    Spacer(),
                    CircleAvatar(
                      maxRadius: 25,
                      backgroundImage: NetworkImage(
                          'https://scontent.fdad3-4.fna.fbcdn.net/v/t39.30808-6/306135507_1211755559394586_7445899947695751742_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=9c7eae&_nc_eui2=AeG3XOU_FtPpLfAhVhnb4qJdhSPDzNnfc2iFI8PM2d9zaLRhiP2fvg7dEF11BeY4FSJunVUN8DrYOX5-pTLhc53R&_nc_ohc=c2nk4Fgzlw8AX_tYfi6&_nc_ht=scontent.fdad3-4.fna&oh=00_AfByyXoB50Mkdn2cz_-LPDeymEv05B9oWfn5C3Plm-VcXg&oe=65D8AA7E'),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),
              SliverToBoxAdapter(child: InformationSheet()),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
              SliverFillRemaining(
                child: TabBarHome(),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class InformationSheet extends StatelessWidget {
  const InformationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    var isLoading = false;

    final databaseReference = FirebaseDatabase.instance.ref("");

    return StreamBuilder(
      stream: databaseReference.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        final dynamic rawData = snapshot.data!.snapshot.value;

        if (rawData == null || !(rawData is Map)) {
          return Text('Data is not available or invalid.');
        }

        final sensorsData = rawData['sensors'];

        num? temperature;
        num? humidity;

        if (sensorsData is Map) {
          temperature = sensorsData['temperature'];
          humidity = sensorsData['humidity'];
        }

        num sensible =
            calculateSensibleTemperature(temperature ?? 0, humidity ?? 0)
                .toInt();

        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xffDDDDDD),
                  blurRadius: 0.3,
                  spreadRadius: 0,
                  offset: Offset(0.0, 0.0),
                )
              ],
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.6), AppColors.primary],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30))),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(PathImage.im_sunny, height: 50),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cloudy',
                          style: AppText.heading3.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          )),
                      Location(),
                    ],
                  ),
                  Spacer(),
                  Text('${temperature!.toInt().toString()}°',
                      style: AppText.heading1.copyWith(
                          color: AppColors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(45)),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.white.withOpacity(0.2),
                      AppColors.white.withOpacity(0.2)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${sensible.toString()}°',
                            style: AppText.heading4.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            'Sensible',
                            style: AppText.small.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.symmetric(
                                vertical: BorderSide(
                                    color: AppColors.white.withOpacity(0.4)))),
                        child: Column(
                          children: [
                            Text(
                              '${humidity.toString()}%',
                              style: AppText.heading4.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              'Humidity',
                              style: AppText.small.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '3',
                            style: AppText.heading4.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            'W. force',
                            style: AppText.small.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
