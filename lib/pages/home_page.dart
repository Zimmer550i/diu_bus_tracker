import 'dart:ui';

import 'package:diu_bus_tracker/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isExpanded = false;
  bool isLoading = true;
  int selected = -1;
  late InAppWebViewController _controller;

  void permission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    //pos is Ready to be used for longtitude and latitude
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    pos = pos;
  }

  @override
  void initState() {
    super.initState();
    permission();
  }

  @override
  Widget build(BuildContext context) {
    permission();
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(mapsUrl),
            ),
            onWebViewCreated: (controller) {
              _controller = controller;
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
            },
            androidOnGeolocationPermissionsShowPrompt:
                (controller, origin) async {
              return GeolocationPermissionShowPromptResponse(
                origin: origin,
                allow: true,
                retain: true,
              );
            },
          ),
          Column(children: [
            AppBar(
              title: const Text(
                'DIU Bus Tracker',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              centerTitle: true,
            ),
            Expanded(
              child: isLoading
                  ? LottieBuilder.asset('assets/busAnimated.json')
                  : AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: isExpanded ? 3 : 0,
                          sigmaY: isExpanded ? 3 : 0,
                        ),
                        child: isExpanded
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    isExpanded = false;
                                  });
                                },
                                child: Container(),
                              )
                            : Container(),
                      ),
                    ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: isExpanded
                  ? MediaQuery.of(context).size.height - 200
                  : MediaQuery.of(context).size.height / 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isExpanded ? 0 : 25),
                  topRight: Radius.circular(isExpanded ? 0 : 25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    onPanUpdate: (details) {
                      if (details.delta.dy < 0) {
                        setState(() {
                          isExpanded = true;
                        });
                      }

                      if (details.delta.dy > 0) {
                        setState(() {
                          isExpanded = false;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 10,
                            width: 40,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "Routes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: routesList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == routesList.length) {
                          return const Text(
                            "\n\nMade by:\nZimmer550i\nSunny Gomes",
                            textAlign: TextAlign.center,
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16,
                            left: 8,
                            right: 8,
                          ),
                          child: InkWell(
                            onTap: () {
                              if (selected != index) {
                                setState(() {
                                  selected = index;
                                  _controller.loadUrl(
                                    urlRequest: URLRequest(
                                      url: Uri.parse(
                                          routesList[selected]['link']),
                                    ),
                                  );
                                });
                              } else {
                                setState(() {
                                  selected = -1;
                                  _controller.loadUrl(
                                    urlRequest: URLRequest(
                                      url: Uri.parse(mapsUrl),
                                    ),
                                  );
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selected == index
                                    ? Colors.blue
                                    : Colors.grey[100],
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                    spreadRadius: -1,
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "R${index + 1}. ${routesList[index]['name']}",
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "        From DSC: ${routesList[index]['from']}",
                                  ),
                                  Text(
                                    "        To DSC: ${routesList[index]['to']}",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ])
        ],
      ),
    );
  }
}
