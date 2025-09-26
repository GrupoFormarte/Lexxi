import 'package:flutter/material.dart';
import 'package:lexxi/src/global/colors_custom.dart';
import 'package:lexxi/src/global/extensions/build_context_ext.dart';
import 'package:lexxi/src/global/utils/change_colors.dart';

class AvatarProfile extends StatefulWidget {
  const AvatarProfile(
      {super.key,
      required this.onClick,
      required this.icon,
      required this.name,
      required this.carrera,
      this.photo});

  final Function() onClick;
  final IconData icon;
  final Widget name;
  final String carrera;
  final String? photo;

  @override
  State<AvatarProfile> createState() => _AvatarProfileState();
}

class _AvatarProfileState extends State<AvatarProfile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: SizedBox(
        width: 200,
        height: 200,
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        // gradient: blueDarkToGradienGreen(context),
                        color: ColorPalette.white,
                        image: widget.photo != null
                            ? DecorationImage(
                              fit: BoxFit.cover,
                                image: NetworkImage(widget.photo!))
                            : null),
                    child: widget.photo == null
                        ? const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                  widget.name,
                  Text(
                    widget.carrera,
                    style: context.textTheme.titleLarge!
                        .copyWith(color: blackToWhite(context)),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 10,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: ColorPalette.secondary
                      // gradient: gradienGreenTowhite(context),
                      ),
                  child: Icon(
                    widget.icon,
                    color: ColorPalette.white,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
