import 'package:flutter/material.dart';
import 'package:blur/blur.dart';
import 'package:smart_home/constants/path_images.dart';
import 'package:smart_home/styles/app_colors.dart';
import 'package:smart_home/styles/app_styles.dart';
import 'package:smart_home/styles/app_text.dart';

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
          color: AppColors.white.withOpacity(0.7),
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
                    CircleAvatar(
                      maxRadius: 25,
                      backgroundImage: NetworkImage(
                          'https://scontent.fdad3-4.fna.fbcdn.net/v/t39.30808-6/306135507_1211755559394586_7445899947695751742_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=9c7eae&_nc_eui2=AeG3XOU_FtPpLfAhVhnb4qJdhSPDzNnfc2iFI8PM2d9zaLRhiP2fvg7dEF11BeY4FSJunVUN8DrYOX5-pTLhc53R&_nc_ohc=c2nk4Fgzlw8AX_tYfi6&_nc_ht=scontent.fdad3-4.fna&oh=00_AfByyXoB50Mkdn2cz_-LPDeymEv05B9oWfn5C3Plm-VcXg&oe=65D8AA7E'),
                    ),
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
                        Text('Wellcome to gPBL home',
                            style:
                                AppText.medium.copyWith(color: Colors.black54))
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.settings,
                      size: 20,
                    )
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
              SliverGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.white.withOpacity(0.5),
                          AppColors.white.withOpacity(0.6)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.white.withOpacity(0.5),
                            AppColors.white.withOpacity(0.6)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.white.withOpacity(0.5),
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.white.withOpacity(0.5),
                        AppColors.white.withOpacity(0.6)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  )),
                ],
              )
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
    return Container(
      padding: EdgeInsets.all(10),
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
          borderRadius: BorderRadius.circular(20)),
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
                  Text('Da Nang, Viet Nam',
                      style: AppText.small.copyWith(
                        color: AppColors.white,
                      ))
                ],
              ),
              Spacer(),
              Text('28°C',
                  style: AppText.heading1.copyWith(
                      color: AppColors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '31°',
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
                child: Column(
                  children: [
                    Text(
                      '31%',
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
        ],
      ),
    );
  }
}
