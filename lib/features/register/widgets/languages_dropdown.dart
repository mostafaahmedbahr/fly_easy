import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_fly_easy_new/core/utils/colors.dart';
import 'package:new_fly_easy_new/core/utils/strings.dart';

class LanguagesDropdown extends StatefulWidget {
  const LanguagesDropdown({Key? key,
  required this.value,
    required this.hint,
    required this.onChanged,
    required this.items
  }) : super(key: key);
  final String hint;
  final void Function(String?)? onChanged;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  @override
  State<LanguagesDropdown> createState() => _LanguagesDropdownState();
}

class _LanguagesDropdownState extends State<LanguagesDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 22.05,
            offset: Offset(0, 8.82),
            spreadRadius: 0,
          )
        ],
      ),
      child: DropdownButtonFormField2<String>(
        isExpanded: true,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: const Icon(Icons.language,color: AppColors.lightPrimaryColor,),
          contentPadding: const EdgeInsets.symmetric(vertical: 22),
          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(),
        ),
        hint: Text(
          widget.hint,
          style:  TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            fontFamily: AppFonts.lato,
            color: AppColors.lightPrimaryColor,
          ),
        ),
        items: widget.items,
        // validator: widget.validator,
        onChanged: widget.onChanged,
        value: widget.value,
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColors.lightPrimaryColor,
          ),
          openMenuIcon: Icon(
            Icons.arrow_drop_up,
            color: AppColors.lightPrimaryColor,
          ),
          iconSize: 24,
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  OutlineInputBorder _border()=>OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.transparent));
}
