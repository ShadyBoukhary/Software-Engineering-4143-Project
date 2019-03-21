import 'package:flutter/material.dart';
import 'package:hnh/app/components/countdown.dart';
import 'package:hnh/app/components/hhDrawer.dart';
import 'package:hnh/app/home/home_controller.dart';
import 'package:hnh/app/abstract/view.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hnh/app/utils/constants.dart';
import 'package:hnh/data/repositories/data_hhh_repository.dart';
import 'package:hnh/data/repositories/data_sponsor_repository.dart';
import 'package:hnh/data/repositories/data_authentication_repository.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageView createState() => HomePageView(HomeController(DataHHHRepository(), DataSponsorRepository(), DataAuthenticationRepository()));
}

class HomePageView extends View<HomePage> {
  HomeController _controller;

  HomePageView(this._controller) {
    _controller.refresh = callHandler;
    WidgetsBinding.instance.addObserver(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          elevation: 8.0,
          child: _controller.isLoading ? HhDrawer('Guest User', '') :HhDrawer(_controller.currentUser.fullName, _controller.currentUser.email)
        ),
        appBar: appBar,
        body: ModalProgressHUD(
            child: getbody(),
            inAsyncCall: _controller.isLoading,
            opacity: UIConstants.progressBarOpacity,
            color: UIConstants.progressBarColor));
  }

  AppBar get appBar => AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0, right: 5.0),
              child: CircleAvatar(
                radius: 15.0,
                backgroundColor: Colors.red,
                child: Text(
                  _controller.isLoading ? "GU" :_controller.currentUser?.initials,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      );

  ListView getbody() {
    List<Widget> children = [
      SizedBox(height: 60.0),
      logoContainer,
      subtitleColumn,
    ];

    if (!_controller.isLoading && _controller.eventTime != null) {
      children.add(Countdown(_controller.eventTime, callHandler));
    }

    return ListView(children: children);
  }

  Container get logoContainer => Container(
        width: double.infinity,
        height: 200.0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image(
            image: AssetImage(Resources.logo),
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
        ),
      );

  Column get subtitleColumn => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Text(
                      "HELL",
                      style: TextStyle(
                        color: Colors.red[800],
                        fontSize: 88.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 15.0,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.0, 5.0),
                            blurRadius: 3.0,
                            color: Colors.black,
                          ),
                          Shadow(
                            offset: Offset(0.0, 8.0),
                            blurRadius: 8.0,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "The Centennial \nRide From",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.0,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 3.0,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.0, 3.0),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(0.0, 5.0),
                          blurRadius: 8.0,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

  @override
  void dispose() {
    _controller.dispose();
    _stopTimer = true;
    super.dispose();
  }
}
