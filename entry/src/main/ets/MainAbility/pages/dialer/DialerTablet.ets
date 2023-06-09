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

import CallRecord from './callRecord/CallRecord'
import resourceManager from '@ohos.resourceManager';
import HiLog from '../../util/Hilog';
import DialerPresenter from './../../presenter/dialer/DialerPresenter';
import { DialerInitialPage } from '../../component/dialer/DialerInitialPage';
import PreferencesUtil from '../../util/PreferencesUtil'

const TAG = 'DialerTablet'

@Component
struct DialButton {
  @Prop button_number: string
  @Prop button_char: string
  @Link mPresenter: DialerPresenter

  build() {
    Column() {
      Button() {
        Flex({
          direction: FlexDirection.Column,
          alignItems: ItemAlign.Center,
          justifyContent: FlexAlign.Center
        }) {
          if (`${this.button_number}` == '*') {
            Image($r("app.media.symbol"))
              .width($r("app.float.id_item_height_sm"))
              .height($r("app.float.id_item_height_sm"))
          } else if (`${this.button_number}` == '#') {
            Image($r("app.media.symbols"))
              .width($r("app.float.id_item_height_sm"))
              .height($r("app.float.id_item_height_sm"))
          } else if (`${this.button_number}` == '0') {
            Text(`${this.button_number}`)
              .fontSize($r("sys.float.ohos_id_text_size_headline6"))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontWeight(FontWeight.Medium)
              .margin({ top: $r("app.float.id_card_margin_mid") })
          } else {
            Text(`${this.button_number}`)
              .fontSize($r("sys.float.ohos_id_text_size_headline6"))
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .fontWeight(FontWeight.Medium)
          }

          if ((this.button_char == 'ic')) {
            Image($r("app.media.ic_contacts_voicemail_mini"))
              .width($r("app.float.id_card_margin_xxl"))
              .height($r("app.float.id_card_margin_xxl"))
          } else if ((this.button_char == '+')) {
            Image($r("app.media.ic_public_add"))
              .width($r("app.float.id_card_margin_xl"))
              .height($r("app.float.id_card_margin_xl"))
          } else {
            Text(`${this.button_char}`)
              .fontSize($r("sys.float.ohos_id_text_size_body3"))
              .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          }
        }
      }
      .backgroundColor($r('sys.color.ohos_id_color_primary_contrary'))
      .width('100%')
      .height($r("app.float.dialer_keypad_button_height"))
      .onClick(() => {
        this.mPresenter.ifNeedSpace();
        this.mPresenter.tele_number += this.button_number
        this.mPresenter.all_number += this.button_number
        this.mPresenter.viewNumberTextProc();
        this.mPresenter.playAudio(this.button_number);
      })
    }
    .flexShrink(1)
  }
}

@Component
struct DialPad {
  @Link mPresenter: any;

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row }) {
        DialButton({
          button_number: '1',
          button_char: 'ic',
          mPresenter: $mPresenter,
        })

        DialButton({
          button_number: '2',
          button_char: 'ABC',
          mPresenter: $mPresenter,
        })

        DialButton({
          button_number: '3',
          button_char: 'DEF',
          mPresenter: $mPresenter,
        })
      }

      Flex({ direction: FlexDirection.Row }) {
        DialButton({
          button_number: '4',
          button_char: 'GHI',
          mPresenter: $mPresenter,
        })

        DialButton({
          button_number: '5',
          button_char: 'JKL',
          mPresenter: $mPresenter,
        })

        DialButton({
          button_number: '6',
          button_char: 'MNO',
          mPresenter: $mPresenter,
        })
      }

      Flex({ direction: FlexDirection.Row }) {
        DialButton({
          button_number: '7',
          button_char: 'PQRS',
          mPresenter: $mPresenter,
        })

        DialButton({
          button_number: '8',
          button_char: 'TUV',
          mPresenter: $mPresenter,
        })

        DialButton({
          button_number: '9',
          button_char: 'WXYZ',
          mPresenter: $mPresenter,
        })
      }

      Flex({ direction: FlexDirection.Row }) {
        DialButton({
          button_number: '*',
          button_char: '(P)',
          mPresenter: $mPresenter,
        })

        DialButton({
          button_number: '0',
          button_char: '+',
          mPresenter: $mPresenter,
        })

        DialButton({
          button_number: '#',
          button_char: '(W)',
          mPresenter: $mPresenter,
        })
      }
    }
    .width('100%')
    .padding({ left: $r("app.float.dialer_keypad_button_height"), right: $r("app.float.dialer_keypad_button_height") })
    .backgroundColor($r('sys.color.ohos_id_color_primary_contrary'))
  }
}

@Entry
@Component
export default struct CallTablet {
  @State mPresenter: DialerPresenter = DialerPresenter.getInstance()
  menuRes: Resource[] = [$r("app.string.call_setting_type_paste"),
  $r("app.string.call_setting_type_batch_delete"),
  $r("app.string.call_setting_type_harassment_interception"),
  $r("app.string.call_setting_type_setting")];
  @State private callmenu: any = [{ value: "", action: () => {
  } }];

  aboutToAppear() {
    this.getMenu();
    this.mPresenter.aboutToAppear();
  }

  onPageShow() {
    this.mPresenter.onPageShow();
  }

  aboutToDisappear() {
    this.mPresenter.onDestroy();
  }

  getMenu() {
    let tmpPhoneMenu = [];
    this.menuRes.forEach(element => {
      tmpPhoneMenu.push({});
    });
    this.callmenu = tmpPhoneMenu;
    resourceManager.getResourceManager().then(result => {
      this.menuRes.forEach((element, i) => {
        result.getString(element.id, (err, typeName) => {
          HiLog.i(TAG, typeName);
          this.callmenu[i] = {
            value: typeName,
            action: () => {
            }
          };
        });
      });
    });
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start }) {

      Column() {
        if (this.mPresenter.tele_number.length > 0) {
          Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
              Text(`${this.mPresenter.tele_number}`)
                .fontSize(this.mPresenter.tele_num_size)
                .fontColor($r('sys.color.ohos_id_color_text_primary'))
                .maxLines(1)
            }
            .width('100%')
            .height('112vp')

            if (this.mPresenter.tele_number.length >= 3) {
              Row() {
                Image($r("app.media.ic_public_add"))
                  .width($r("app.float.id_card_margin_max"))
                  .height($r("app.float.id_card_margin_max"))
                  .margin({
                    left: $r("app.float.id_card_margin_max"),
                    right: $r("app.float.id_card_margin_xxl")
                  })

                Text($r("app.string.new_contact"))
                  .fontSize($r("sys.float.ohos_id_text_size_body1"))
                  .fontColor($r('sys.color.ohos_id_color_text_primary'))
              }
              .width('100%')
              .height($r("app.float.id_item_height_large"))
              .onClick(() => {
                this.mPresenter.jumpToAccountants()
              })

              Divider()
                .color($r('sys.color.ohos_id_color_list_separator'))
                .lineCap(LineCapStyle.Square)
                .width('100%')
                .padding({ left: $r("app.float.id_item_height_max") })

              Row() {
                Image($r("app.media.ic_public_contacts"))
                  .width($r("app.float.id_card_margin_max"))
                  .height($r("app.float.id_card_margin_max"))
                  .margin({
                    left: $r("app.float.id_card_margin_max"),
                    right: $r("app.float.id_card_margin_xxl")
                  })

                Text($r("app.string.save_to_existing_contacts"))
                  .fontSize($r("sys.float.ohos_id_text_size_body1"))
                  .fontColor($r('sys.color.ohos_id_color_text_primary'))
              }
              .width('100%')
              .height($r("app.float.id_item_height_large"))
              .onClick(() => {
              })

              Divider()
                .color($r('sys.color.ohos_id_color_list_separator'))
                .lineCap(LineCapStyle.Square)
                .width('100%')
                .padding({ left: $r("app.float.id_item_height_max") })

              Row() {
                Image($r("app.media.ic_public_message"))
                  .width($r("app.float.id_card_margin_max"))
                  .height($r("app.float.id_card_margin_max"))
                  .margin({
                    left: $r("app.float.id_card_margin_max"),
                    right: $r("app.float.id_card_margin_xxl")
                  })

                Text($r("app.string.send_messages"))
                  .fontSize($r("sys.float.ohos_id_text_size_body1"))
                  .fontColor($r('sys.color.ohos_id_color_text_primary'))
              }
              .width('100%')
              .height($r("app.float.id_item_height_large"))
              .onClick(() => {
                this.mPresenter.sendMessage();
              })

              Divider()
                .color($r('sys.color.ohos_id_color_list_separator'))
                .lineCap(LineCapStyle.Square)
                .width('100%')
                .padding({ left: $r("app.float.id_item_height_max") })
            }

          }
          .width('100%')
          .height('100%')
          .backgroundColor($r('sys.color.ohos_id_color_primary_contrary'))
        } else {
          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
            Button() {
              Image($r("app.media.ic_public_more"))
                .width($r("app.float.id_card_margin_max"))
                .height($r("app.float.id_card_margin_max"))
            }
            .width($r("app.float.id_item_height_mid"))
            .height($r("app.float.id_item_height_mid"))
            .backgroundColor($r('sys.color.ohos_id_color_primary_contrary'))
            .margin({ right: $r("app.float.id_card_margin_xl") })
            .type(ButtonType.Normal)
            .visibility(Visibility.Hidden)
          }
          .width('100%')
          .height($r("app.float.id_item_height_large"))
          .backgroundColor($r('sys.color.ohos_id_color_primary_contrary'))
          .zIndex(3)

          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
            Text($r("app.string.dialer"))
              .fontSize($r("sys.float.ohos_id_text_size_headline6"))
              .fontWeight(FontWeight.Bold)
              .fontColor($r('sys.color.ohos_id_color_text_primary'))
              .margin({ left: $r("app.float.id_card_margin_max") })
          }
          .width('100%')
          .height($r("app.float.id_item_height_large"))
          .backgroundColor($r('sys.color.ohos_id_color_primary_contrary'))
          .zIndex(3)

          if (PreferencesUtil.isUsed()) {
            Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
              CallRecord()
            }
            .height('100%')
            .zIndex(1)
          } else {
            DialerInitialPage()
          }
        }
      }
      .width('40%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)
      .backgroundColor($r("sys.color.ohos_id_color_primary_contrary"))

      Column() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {

          DialPad({ mPresenter: $mPresenter })

          Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
            Button()
              .backgroundColor($r('sys.color.ohos_id_color_primary_contrary'))
              .width($r("app.float.id_item_height_mid"))
              .height($r("app.float.id_item_height_mid"))

            Button() {
              Image($r("app.media.ic_public_phone_filled_white"))
                .width($r("app.float.id_item_height_sm"))
                .height($r("app.float.id_item_height_sm"))
            }
            .width('68vp')
            .height('68vp')
            .backgroundColor($r('sys.color.ohos_id_color_connected'))
            .onClick(() => {
              if (this.mPresenter.tele_number.length > 0) {
                this.mPresenter.dialing(this.mPresenter.all_number);
                this.mPresenter.tele_number = '';
                this.mPresenter.all_number = '';
              }
            })

            Button() {
              Image($r("app.media.ic_public_dial_delete"))
                .width('28vp')
                .height('28vp')
            }
            .backgroundColor($r('sys.color.ohos_id_color_primary_contrary'))
            .width($r("app.float.id_item_height_mid"))
            .height($r("app.float.id_item_height_mid"))
            .opacity(this.mPresenter.tele_number.length > 0 ? 1 : 0.6)
            .enabled(this.mPresenter.tele_number.length > 0 ? true : false)
            .gesture(
            LongPressGesture({ repeat: false, fingers: 1, duration: 700 })
              .onAction((event: GestureEvent) => {
                this.mPresenter.tele_number = '';
                this.mPresenter.all_number = '';
              })
            )
            .onClick(() => {
              this.mPresenter.pressVibrate();
              this.mPresenter.all_number = this.mPresenter.all_number.substr(0, this.mPresenter.all_number.length - 1)
              this.mPresenter.deleteTeleNum();
              this.mPresenter.deleteAddSpace();
            })
          }
          .width('100%')
          .height($r("app.float.dialer_keypad_button_height"))
          .padding({
            left: $r("app.float.dialer_keypad_button_height"),
            right: $r("app.float.dialer_keypad_button_height")
          })
        }
        .width('100%')
        .height('100%')
        .padding({ bottom: $r("app.float.dialer_keypad_button_height") })
      }
      .width('60%')
      .height('100%')
      .backgroundColor($r('sys.color.ohos_id_color_primary_contrary'))
    }
    .width('100%')
    .height('100%')
  }
}