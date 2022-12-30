/*
 *  This file is part of BlackHole (https://github.com/Sangwan5688/BlackHole).
 * 
 * BlackHole is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * BlackHole is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with BlackHole.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * Copyright (c) 2021-2022, Ankit Sangwan
 */

import 'package:musico/gen/colors.gen.dart';
import 'package:musico/utils/font_style_utils.dart';
import 'package:flutter/material.dart';

Future<void> showTextInputDialog({
  required BuildContext context,
  required String title,
  String? initialText,
  required TextInputType keyboardType,
  required Function(String) onSubmitted,
}) async {
  await showDialog(
    context: context,
    builder: (BuildContext ctxt) {
      final controller = TextEditingController(text: initialText);
      return AlertDialog(
        backgroundColor: ColorName.dialogBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: ColorName.secondaryColor,
                  ),
                ),
              ],
            ),
            TextField(
              autofocus: true,
              controller: controller,
              keyboardType: keyboardType,
              style: FSUtils.normal_14_FFFFFF,
              cursorColor: ColorName.secondaryColor,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  // 不是焦点的时候颜色
                  borderSide: BorderSide(
                    color: ColorName.secondaryColor,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  // 焦点集中的时候颜色
                  borderSide: BorderSide(
                    color: ColorName.secondaryColor,
                  ),
                ),
              ),
              textAlignVertical: TextAlignVertical.bottom,
              onSubmitted: (value) {
                onSubmitted(value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(

                /*      foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey[700],*/
                ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'cancel',
              style: FSUtils.normal_13_FFFFFF,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              /*  foregroundColor:
                  Theme.of(context).colorScheme.secondary == Colors.white
                      ? Colors.black
                      : Colors.white,*/
              backgroundColor: ColorName.secondaryColor,
            ),
            onPressed: () {
              onSubmitted(controller.text.trim());
            },
            child: const Text(
              'sure',
              style: FSUtils.normal_13_FFFFFF,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      );
    },
  );
}
