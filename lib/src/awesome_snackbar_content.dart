import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:awesome_snackbar_content/src/assets_path.dart';
import 'package:awesome_snackbar_content/src/content_type.dart';

class AwesomeSnackbarContent extends StatelessWidget {
  /// `IMPORTANT NOTE` for SnackBar properties before putting this in `content`
  /// set backgroundColor: Colors.transparent
  /// set behavior: SnackBarBehavior.floating
  /// set elevation: 0.0

  /// title is the header String that will show on top
  final String title;

  /// message String is the body message which shows only 2 lines at max
  final String message;

  /// `optional` color of the SnackBar body
  final Color? color;

  /// contentType will reflect the overall theme of SnackBar: failure, success, help, warning
  final ContentType contentType;

  /// `optional` the maximum number of lines for the messsage
  final int? messageMaxLines;

  ///  `optional` textstyle to be used for the  title
  final TextStyle? titleTextStyle;

  /// `optional` textstyle to be used for the  message
  final TextStyle? messageTextStyle;

  /// `optional` the spacing between the  title and messase text
  final double? contentSpacing;

  /// `optional` show the close icon
  final bool showCloseIcon;

  const AwesomeSnackbarContent({
    Key? key,
    this.color,
    required this.title,
    required this.message,
    required this.contentType,
    this.messageMaxLines = 2,
    this.contentSpacing = 4,
    this.titleTextStyle,
    this.messageTextStyle,
    this.showCloseIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// For managing responsiveness
    Size size = MediaQuery.of(context).size;

    // is mobile
    bool isMobile = size.width <= 768;
    bool isTablet = size.width > 768 && size.width <= 992;
    bool isDesktop = size.width >= 992;

    /// For reflecting different color shades in the SnackBar
    final hsl = HSLColor.fromColor(color ?? contentType.color!);
    final hslDark = hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0));

    return Row(
      children: [
        isDesktop || isTablet
            ? const Spacer()
            : SizedBox(
                width: size.width * 0.02,
              ),
        Expanded(
          flex: isTablet || isMobile ? 7 : 1,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              /// SnackBar Body
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: isTablet ? size.width * 0.1 : 0,
                ),
                /* padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? size.width * 0.1 : size.width * 0.05,
                  vertical: isTablet || isDesktop
                      ? size.height * 0.02
                      : size.height * 0.025,
                ), */
                //height: size.height * 0.12,
                decoration: BoxDecoration(
                  color: color ?? contentType.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    /// other SVGs in body
                    Positioned(
                      bottom: 0,
                      left: isTablet ? size.width * 0.1 : 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                        ),
                        child: SvgPicture.asset(
                          AssetsPath.bubbles,
                          height: size.height * 0.06,
                          width: size.width * 0.04,
                          color: hslDark.toColor(),
                          package: 'awesome_snackbar_content',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            isTablet ? size.width * 0.1 : size.width * 0.05,
                        vertical: isTablet || isDesktop
                            ? size.height * 0.02
                            : size.height * 0.025,
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          Expanded(
                            flex: isMobile ? 8 : 25,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    /// `title` parameter
                                    Text(
                                      title,
                                      style: titleTextStyle ??
                                          TextStyle(
                                            fontSize: isTablet || isDesktop
                                                ? size.height * 0.03
                                                : size.height * 0.025,
                                            color: Colors.white,
                                          ),
                                    ),
                                    Visibility(
                                      visible: showCloseIcon,
                                      child: InkWell(
                                        onTap: () =>
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar(),
                                        child: SvgPicture.asset(
                                          AssetsPath.failure,
                                          height: size.height * 0.022,
                                          package: 'awesome_snackbar_content',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                //const Spacer(),
                                SizedBox(
                                  height: contentSpacing,
                                ),

                                /// `message` body text parameter
                                Text(
                                  message,
                                  style: messageTextStyle ??
                                      TextStyle(
                                        fontSize: size.height * 0.016,
                                        color: Colors.white,
                                      ),
                                  maxLines: messageMaxLines,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                top: -size.height * 0.02,
                left: isTablet ? size.width * 0.125 : size.width * 0.02,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      AssetsPath.back,
                      height: size.height * 0.06,
                      color: hslDark.toColor(),
                      package: 'awesome_snackbar_content',
                    ),
                    Positioned(
                      top: size.height * 0.015,
                      child: SvgPicture.asset(
                        assetSVG(contentType),
                        height: size.height * 0.022,
                        package: 'awesome_snackbar_content',
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        isDesktop || isTablet
            ? const Spacer()
            : SizedBox(
                width: size.width * 0.02,
              ),
      ],
    );
  }

  /// Reflecting proper icon based on the contentType
  String assetSVG(ContentType contentType) {
    if (contentType == ContentType.failure) {
      /// failure will show `CROSS`
      return AssetsPath.failure;
    } else if (contentType == ContentType.success) {
      /// success will show `CHECK`
      return AssetsPath.success;
    } else if (contentType == ContentType.warning) {
      /// warning will show `EXCLAMATION`
      return AssetsPath.warning;
    } else if (contentType == ContentType.help) {
      /// help will show `QUESTION MARK`
      return AssetsPath.help;
    } else {
      return AssetsPath.failure;
    }
  }
}
