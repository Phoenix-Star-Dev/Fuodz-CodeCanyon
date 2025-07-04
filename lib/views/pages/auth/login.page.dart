import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_images.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/constants/sizes.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/login.view_model.dart';
import 'package:fuodz/views/pages/auth/login/compain_login_type.view.dart';
import 'package:fuodz/views/pages/auth/login/email_login.view.dart';
import 'package:fuodz/views/pages/auth/login/otp_login.view.dart';
import 'package:fuodz/views/pages/auth/login/social_media.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/buttons/arrow_indicator.dart';
import 'package:fuodz/widgets/dynamic_status_bar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import 'login/scan_login.view.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.required = false, Key? key}) : super(key: key);

  final bool required;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return DynamicStatusBar(
      baseColor: Colors.white,
      child: ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(context),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return PopScope(
            canPop: !widget.required,
            onPopInvoked: (didPop) async {
              if (!didPop && widget.required) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "You are required to login/register to continue process"
                          .tr(),
                    ),
                  ),
                );
              }
            },
            child: BasePage(
              showLeadingAction: !widget.required,
              showAppBar: !widget.required,
              appBarColor: AppColor.faintBgColor,
              leading: IconButton(
                icon: ArrowIndicator(leading: true),
                onPressed: () => Navigator.pop(context),
              ),
              elevation: 0,
              isLoading: model.isBusy,
              body: SafeArea(
                top: true,
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: context.mq.viewInsets.bottom,
                  ),
                  child:
                      VStack([
                        //
                        VStack([
                          //
                          HStack([
                            VStack([
                              "Welcome Back".tr().text.xl2.semiBold.make(),
                              "Login to continue".tr().text.light.make(),
                            ]).expand(),
                            Image.asset(AppImages.appLogo)
                                .h(60)
                                .w(60)
                                .box
                                .withRounded(value: Sizes.radiusSmall)
                                .clip(Clip.antiAlias)
                                .make(),
                          ]),

                          //LOGIN Section
                          //both login type
                          if (AppStrings.enableOTPLogin &&
                              AppStrings.enableEmailLogin)
                            CombinedLoginTypeView(
                              model,
                              radius: Sizes.radiusLarge,
                            ),
                          //only email login
                          if (AppStrings.enableEmailLogin &&
                              !AppStrings.enableOTPLogin)
                            EmailLoginView(model),
                          //only otp login
                          if (AppStrings.enableOTPLogin &&
                              !AppStrings.enableEmailLogin)
                            OTPLoginView(model),
                        ]).wFull(context).px20().pOnly(top: Vx.dp20),
                        //
                        //register
                        HStack([
                          UiSpacer.divider().expand(),
                          "OR".tr().text.light.make().px8(),
                          UiSpacer.divider().expand(),
                        ]).py8().px20(),
                        "New user?".richText
                            .withTextSpanChildren([
                              " ".textSpan.make(),
                              "Create An Account"
                                  .tr()
                                  .textSpan
                                  .semiBold
                                  .color(AppColor.primaryColor)
                                  .make(),
                            ])
                            .makeCentered()
                            .py12()
                            .onInkTap(model.openRegister),
                        SocialMediaView(model, bottomPadding: 10),
                        ScanLoginView(model),
                      ]).scrollVertical(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
