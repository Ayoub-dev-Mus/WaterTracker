import 'package:flutter/material.dart';
import 'package:water_tracker/interfaces/TopBarClickListener.dart';
import 'package:water_tracker/utils/Color.dart';


class CommonTopBar extends StatefulWidget {
  final String headerName;
  final TopBarClickListener clickListener;

  final bool isShowSubheader;

  final String? subHeader;

  CommonTopBar(this.headerName, this.clickListener,
      {
        this.isShowSubheader = false,
        this.subHeader,
      });

  @override
  _CommonTopBarState createState() => _CommonTopBarState();
}

class _CommonTopBarState extends State<CommonTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 5.0,bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.headerName,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                              color: Colur.txt_black),
                        ),
                        Visibility(
                          visible: widget.isShowSubheader,
                          child: Text(
                            widget.isShowSubheader ? widget.subHeader! : "",
                            style: TextStyle(
                                color: Colur.txt_grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
