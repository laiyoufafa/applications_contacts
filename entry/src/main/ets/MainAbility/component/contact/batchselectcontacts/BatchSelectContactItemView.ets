/**
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import StringUtil from '../../../util/StringUtil';

const TAG = 'BatchSelectRecentItemView ';

/**
 * Select the contact item component, which is responsible for displaying a single contact.
 */
@Component
export default struct BatchSelectRecentItemView {
  @State private item: any = {};
  private onContactItemClicked: Function;
  private index: number;

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
        Row() {
          if (StringUtil.isEmpty(this.item.nameSuffix)) {
            Image(StringUtil.isEmpty(this.item.portraitPath) ? $r("app.media.ic_user_portrait") : this.item.portraitPath)
              .width($r("app.float.id_card_image_mid"))
              .height($r("app.float.id_card_image_mid"))
              .objectFit(ImageFit.Contain)
              .borderRadius($r("app.float.id_card_image_mid"))
              .backgroundColor(this.item.portraitColor)
          } else {
            Text(this.item.nameSuffix.toUpperCase())
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .backgroundColor(this.item.portraitColor)
              .height($r("app.float.id_card_image_mid"))
              .width($r("app.float.id_card_image_mid"))
              .textAlign(TextAlign.Center)
              .borderRadius($r("app.float.id_card_image_mid"))
          }
        }
        .width($r("app.float.id_card_image_mid"))
        .height($r("app.float.id_card_image_mid"))
        .margin({ left: $r("app.float.id_card_margin_max") })

        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
          Text(StringUtil.isEmpty(this.item.showName) ? this.item.phoneNum : this.item.showName)
            .fontColor($r("sys.color.ohos_id_color_text_primary"))
            .fontSize($r("sys.float.ohos_id_text_size_body1"))
            .fontWeight(FontWeight.Medium)
            .margin({ left: $r("app.float.id_card_margin_xl"), bottom: $r("app.float.id_card_margin_sm") })

          Text(StringUtil.isEmpty(this.item.phoneNumbers[0].labelName) ? '' : this.item.phoneNumbers[0].labelName + '  ' + this.item.phoneNumbers[0].phoneNumber)
            .fontColor($r("sys.color.ohos_id_color_text_tertiary"))
            .fontSize($r("sys.float.ohos_id_text_size_body2"))
            .fontWeight(FontWeight.Regular)
            .margin({ left: $r("app.float.id_card_margin_xl") })
        }
        .flexGrow(1)
        .height($r("app.float.id_item_height_max"))

        Toggle({
          type: ToggleType.Checkbox,
          isOn: (this.item.phoneNumbers[0].checked == undefined) ? false : this.item.phoneNumbers[0].checked
        })
          .width($r("app.float.id_card_image_small"))
          .height($r("app.float.id_card_image_small"))
          .enabled(false)
          .margin({ left: $r("app.float.id_card_margin_max"), right: $r("app.float.id_card_margin_max") })
          .selectedColor($r("sys.color.ohos_id_color_connected"))
      }
      .width('100%')
      .height($r("app.float.id_item_height_max"))
      .onClick(() => {
        this.onContactItemClicked(this.index, 0);
      })

      List({ space: 0, initialIndex: 0 }) {
        ForEach(this.item.phoneNumbers, (item, index) => {
          ListItem() {
            if (index != 0) {
              Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
                Row() {
                }
                .width($r("app.float.id_card_image_mid"))
                .height($r("app.float.id_card_image_mid"))
                .margin({ left: $r("app.float.id_card_margin_max") })
                .visibility(Visibility.Hidden)

                Flex({
                  direction: FlexDirection.Column,
                  alignItems: ItemAlign.Start,
                  justifyContent: FlexAlign.Center
                }) {

                  Text(StringUtil.isEmpty(item.labelName) ? '' : item.labelName + '  ' + item.phoneNumber)
                    .fontColor($r("sys.color.ohos_id_color_text_tertiary"))
                    .fontSize($r("sys.float.ohos_id_text_size_body2"))
                    .fontWeight(FontWeight.Regular)
                    .margin({ left: $r("app.float.id_card_margin_xl") })
                }
                .flexGrow(1)
                .height($r("app.float.id_item_height_mid"))

                Toggle({ type: ToggleType.Checkbox, isOn: (item.checked == undefined) ? false : item.checked })
                  .width($r("app.float.id_card_image_small"))
                  .height($r("app.float.id_card_image_small"))
                  .enabled(false)
                  .margin({ left: $r("app.float.id_card_margin_max"), right: $r("app.float.id_card_margin_max") })
                  .selectedColor($r("sys.color.ohos_id_color_connected"))
              }
              .width('100%')
              .height($r("app.float.id_item_height_mid"))
              .onClick(() => {
                this.onContactItemClicked(this.index, index);
              })
            }
          }
        }, (item, index) => item.toString())
      }
      .listDirection(Axis.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .divider({
        strokeWidth: 0.5,
        color: $r('sys.color.ohos_id_color_list_separator'),
        startMargin: 76,
        endMargin: $r("app.float.id_card_margin_max"),
      })
    }
    .backgroundColor(Color.White)
  }
}