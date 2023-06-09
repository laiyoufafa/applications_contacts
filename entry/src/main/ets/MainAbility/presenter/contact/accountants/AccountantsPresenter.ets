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

import ContactAbility from '../../../model/ContactAbilityModel'
import HiLog from '../../../util/Hilog';
import StringUtil from "../../../util/StringUtil";
import ArrayUtil from "../../../util/ArrayUtil";
import ObjectUtil from "../../../util/ObjectUtil";
import AccountTypeService from '../../../account/AccountTypeService';
import AccountType from '../../../account/type/AccountType';
import Aim from '../../../contact/contract/Aim';
import Birthday from '../../../contact/contract/Birthday';
import Email from '../../../contact/contract/Email';
import House from '../../../contact/contract/House';
import Relation from '../../../contact/contract/Relation';
import Phone from '../../../contact/contract/Phone';
import { EmailBean } from "../../../model/bean/EmailBean";
import { ContactInfo } from "../../../model/bean/ContactInfo";
import { PhoneNumBean } from "../../../model/bean/PhoneNumBean";
import { HouseBean } from "../../../model/bean/HouseBean";
import { AIMBean } from "../../../model/bean/AIMBean";
import { EventBean } from "../../../model/bean/EventBean";
import { AssociatedPersonBean } from "../../../model/bean/AssociatedPersonBean";

const TAG = 'AccountantsPresenter  ';

/**
 * Add Contact Presenter
 */
export default class AccountantsPresenter {
  private static instance: AccountantsPresenter;
  static readonly timeSub: number = 1000;
  clickBefEvent: Date = new Date();
  clickAftEvent: Date = new Date();
  contactId: string = "";
  routerAvtiveFlag: boolean = false;

  // update mark
  updateShow: boolean = false;
  isShowPosition: boolean = false;
  showMore: boolean = false;
  addState: boolean = false;

  // refresh mark
  changed: boolean = false;

  // contact detail
  contactInfoBefore: ContactInfo = new ContactInfo("", "", "", [], [], "", "", "", [], [], [], [], [], []);
  contactInfoAfter: ContactInfo = new ContactInfo("", "", "", [], [], "", "", "", [], [], [], [], [], []);
  MagList: any = [];
  private constructor() {
  }

  public static getInstance(): AccountantsPresenter {
    if (!AccountantsPresenter.instance) {
      AccountantsPresenter.instance = new AccountantsPresenter()
    }
    return AccountantsPresenter.instance
  }

  init() {
    this.contactId = "";
    this.updateShow = false;
    this.MagList = [1];
    this.contactInfoBefore = new ContactInfo("", "", "", [], [], "", "", "", [], [], [], [], [], []);
    this.contactInfoAfter = new ContactInfo("", "", "", [], [], "", "", "", [], [], [], [], [], []);
    this.clickBefEvent = new Date();
    this.clickAftEvent = this.clickBefEvent;
  }

  refresh() {
    this.contactInfoBefore = this.contactInfoAfter;
    this.changed = !this.changed;
  }

  updatesInit() {
    HiLog.i(TAG, ' init start');
    this.contactInfoAfter.setID(this.contactId);
    if (this.updateShow == true) {
      HiLog.i(TAG, ' getPageData start %s', this.contactId);
      this.getPageData(this.contactId);
    }
  }

  isExistenceInfo(afterInfo: any) {
    let flag = false;
    flag = flag || !StringUtil.isEmpty(afterInfo.display_name);
    flag = flag || !StringUtil.isEmpty(afterInfo.nickname);
    flag = flag || !StringUtil.isEmpty(afterInfo.remarks);
    flag = flag || !StringUtil.isEmpty(afterInfo.position);
    flag = flag || !StringUtil.isEmpty(afterInfo.company);
    if (!ArrayUtil.isEmpty(afterInfo.phones)) {
      flag = flag || !StringUtil.isEmpty(afterInfo.phones[0].num);
    }
    if (!ArrayUtil.isEmpty(afterInfo.emails)) {
      flag = flag || !StringUtil.isEmpty(afterInfo.emails[0].address);
    }
    if (!ArrayUtil.isEmpty(afterInfo.aims)) {
      flag = flag || !StringUtil.isEmpty(afterInfo.aims[0].aimName);
    }
    if (!ArrayUtil.isEmpty(afterInfo.houses)) {
      flag = flag || !StringUtil.isEmpty(afterInfo.houses[0].houseName);
    }
    if (!ArrayUtil.isEmpty(afterInfo.websites)) {
      flag = flag || !StringUtil.isEmpty(afterInfo.websites[0]);
    }
    if (!ArrayUtil.isEmpty(afterInfo.events)) {
      flag = flag || !StringUtil.isEmpty(afterInfo.events[0].data);
    }
    if (!ArrayUtil.isEmpty(afterInfo.relationships)) {
      flag = flag || !StringUtil.isEmpty(afterInfo.relationships[0].name);
    }
    return flag;
  }

  getPageData(id: string) {
    if (StringUtil.isEmpty(id)) {
      HiLog.e(TAG, 'The parameter ID is empty.');
    }
    ContactAbility.getContactById(id, result => {
      if (StringUtil.isEmpty(result)) {
        HiLog.e(TAG, 'The result in the database is empty.');
        return;
      }
      this.dealRecordDetailsData(result.data);
    });
  }

  private dealRecordDetailsData(data) {
    let contactTemp = new ContactInfo("", "", "", [], [], "", "", "", [], [], [], [], [], []);
    if (!data.hasOwnProperty('id') || data.id != this.contactId) {
      HiLog.e(TAG, 'Failed to query the database based on the ID.');
      return;
    }
    contactTemp.setID(data.id);
    let nameUpdate = 0;
    if (data.hasOwnProperty('nameUpdate')) {
      nameUpdate = data.nameUpdate;
    }
    if (data.hasOwnProperty('display_name') && nameUpdate == 0) {
      contactTemp.setDisplayName(data.display_name);
    }
    if (data.hasOwnProperty('nickname')) {
      contactTemp.setNickName(data.nickname);
    }
    if (data.hasOwnProperty('phones')) {
      contactTemp.setPhones(data.phones);
    }
    if (data.hasOwnProperty('emails')) {
      contactTemp.setEmails(data.emails);
    }
    if (data.hasOwnProperty('remarks')) {
      contactTemp.setRemarks(data.remarks);
    }
    if (data.hasOwnProperty('position')) {
      contactTemp.setPosition(data.position);
      this.isShowPosition = true;
    }
    if (data.hasOwnProperty('company')) {
      contactTemp.setCompany(data.company);
    }
    if (data.hasOwnProperty('aims')) {
      contactTemp.setAims(data.aims);
    }
    if (data.hasOwnProperty('houses')) {
      contactTemp.setHouses(data.houses);
    }
    if (data.hasOwnProperty('websites')) {
      contactTemp.setWebsites(data.websites);
    }
    if (data.hasOwnProperty('relationships')) {
      contactTemp.setRelationships(data.relationships);
    }
    if (data.hasOwnProperty('events')) {
      contactTemp.setEvents(data.events);
    }
    if (data.hasOwnProperty('groups')) {
      contactTemp.setGroups(data.groups);
    }
    this.contactInfoBefore = contactTemp;
    this.contactInfoAfter = contactTemp;
  }

  public getArray(array) {
    if (ArrayUtil.isEmpty(array))
    array.push({});
    let itemList = ArrayUtil.isEmpty(array) ? this.MagList : array;
    itemList = itemList.map((item, index) => {
      return {
        i: index + 1, item: item
      };
    })
    return itemList;
  }

  public addMore(type: any) {
    switch (type) {
      case "phone":
        this.contactInfoAfter.phones.push(new PhoneNumBean("", "", "1", "", ""));
        break;
      case "email":
        this.contactInfoAfter.emails.push(new EmailBean("", "", "1"));
        break;
      case "AIM":
        this.contactInfoAfter.aims.push(new AIMBean("", "", "1", ""));
        break;
      case "house":
        this.contactInfoAfter.houses.push(new HouseBean("", "", "1", ""));
        break;
      case "relationships":
        this.contactInfoAfter.relationships.push(new AssociatedPersonBean("", "", "", "1"));
        break;
      case "events":
        this.contactInfoAfter.events.push(new EventBean("", "", "1", ""));
        break;
      default:
        break;
    }
    this.refresh();
  }

  public deleteItem(typeName: string, startIndex) {
    switch (typeName) {
      case "phone":
        if (this.contactInfoAfter.phones.length > 1) {
          this.contactInfoAfter.phones.splice(startIndex, 1);
        } else {
          this.contactInfoAfter.phones[0].num = "";
        }
        break;
      case "email":
        if (this.contactInfoAfter.emails.length > 1) {
          this.contactInfoAfter.emails.splice(startIndex, 1);
        } else {
          this.contactInfoAfter.emails[0].address = "";
        }
        break;
      case "AIM":
        if (this.contactInfoAfter.aims.length > 1) {
          this.contactInfoAfter.aims.splice(startIndex, 1);
        } else {
          this.contactInfoAfter.aims[0].aimName = "";
        }
      case "house":
        if (this.contactInfoAfter.houses.length > 1) {
          this.contactInfoAfter.houses.splice(startIndex, 1);
        } else {
          this.contactInfoAfter.houses[0].houseName = "";
        }
        break;
      case "relationships":
        if (this.contactInfoAfter.relationships.length > 1) {
          this.contactInfoAfter.relationships.splice(startIndex, 1);
        } else {
          this.contactInfoAfter.relationships[0].name = "";
        }
        break;
      case "events":
        if (this.contactInfoAfter.events.length > 1) {
          this.contactInfoAfter.events.splice(startIndex, 1);
        } else {
          this.contactInfoAfter.events[0].data = "";
        }
        break;
      default:
        break;
    }
    this.refresh();
  }

  public getTextDisplay(typeName: string, data: any) {
    let display: string = "";
    switch (typeName) {
      case "phone":
        if (data.item.hasOwnProperty("num")) {
          display = data.item.num;
        }
        break;
      case "email":
        if (data.item.hasOwnProperty("address")) {
          display = data.item.address;
        }
        break;
      case "AIM":
        if (data.item.hasOwnProperty("aimName")) {
          display = data.item.aimName;
        }
        break;
      case "house":
        if (data.item.hasOwnProperty("houseName")) {
          display = data.item.houseName;
        }
        break;
      case "relationships":
        if (data.item.hasOwnProperty("name")) {
          display = data.item.name;
        }
        break;
      case "events":
        if (data.item.hasOwnProperty("data")) {
          display = data.item.data;
        }
        break;
      default:
        break;
    }
    return display;
  }

  public listItemChange(typeName: string, data: any, arg: string) {
    switch (typeName) {
      case "phone":
        if (StringUtil.isEmpty(this.contactInfoAfter.phones[data.i - 1].numType)) {
          this.contactInfoAfter.phones[data.i - 1] = new PhoneNumBean("", "", "1", "", "");
        }
        this.contactInfoAfter.phones[data.i - 1].num = arg.toString();
        break;
      case "email":
        if (StringUtil.isEmpty(this.contactInfoAfter.emails[data.i - 1].emailType)) {
          this.contactInfoAfter.emails[data.i - 1] = new EmailBean("", "", "1");
        }
        this.contactInfoAfter.emails[data.i - 1].address = arg.toString();
        break;
      case "AIM":
        if (StringUtil.isEmpty(this.contactInfoAfter.aims[data.i - 1].aimType)) {
          this.contactInfoAfter.aims[data.i - 1] = new AIMBean("", "", "1", "");
        }
        this.contactInfoAfter.aims[data.i - 1].aimName = arg.toString();
        break;
      case "house":
        if (StringUtil.isEmpty(this.contactInfoAfter.houses[data.i - 1].houseType)) {
          this.contactInfoAfter.houses[data.i - 1] = new HouseBean("", "", "1", "");
        }
        this.contactInfoAfter.houses[data.i - 1].houseName = arg.toString();
        break;
      case "relationships":
        if (StringUtil.isEmpty(this.contactInfoAfter.relationships[data.i - 1].associatedType)) {
          this.contactInfoAfter.relationships[data.i - 1] = new AssociatedPersonBean("", "", "", "1");
        }
        this.contactInfoAfter.relationships[data.i - 1].name = arg.toString();
        break;
      default:
        break;
    }
  }

  public menuSelect(typeName: string, data: any) {
    let typeId = 1;
    switch (typeName) {
      case "phone":
        if (data.item.hasOwnProperty("numType")) {
          typeId = Number(data.item.numType)
        }
        return Phone.getTypeLabelResource(typeId);
        break;
      case "email":
        if (data.item.hasOwnProperty("emailType")) {
          typeId = Number(data.item.emailType)
        }
        return Email.getTypeLabelResource(typeId);
        break;
      case "AIM":
        if (data.item.hasOwnProperty("aimType")) {
          typeId = Number(data.item.aimType)
        }
        return Aim.getTypeLabelResource(typeId);
        break;
      case "house":
        if (data.item.hasOwnProperty("houseType")) {
          typeId = Number(data.item.houseType)
        }
        return House.getTypeLabelResource(typeId);
        break;
      case "relationships":
        if (data.item.hasOwnProperty("associatedType")) {
          typeId = Number(data.item.associatedType)
        }
        return Relation.getTypeLabelResource(typeId);
        break;
      case "events":
        if (data.item.hasOwnProperty("eventType")) {
          typeId = Number(data.item.eventType)
        }
        return Birthday.getTypeLabelResource(typeId);
        break;
      default:
        return "";
        break;
    }
  }

  getMenuList(typeName: string) {
    let accountTypeService = new AccountTypeService();
    let menuKindTypeList;
    let phoneType = accountTypeService.getAccountType(AccountType.PHONE_ACCOUNT_TYPE);
    switch (typeName) {
      case "phone":
        menuKindTypeList = phoneType.mineKinds.get(Phone.CONTENT_ITEM_TYPE).typeList;
        break;
      case "email":
        menuKindTypeList = phoneType.mineKinds.get(Email.CONTENT_ITEM_TYPE).typeList;
        break;
      case "AIM":
        menuKindTypeList = phoneType.mineKinds.get(Aim.CONTENT_ITEM_TYPE).typeList;
        break;
      case "house":
        menuKindTypeList = phoneType.mineKinds.get(House.CONTENT_ITEM_TYPE).typeList;
        break;
      case "relationships":
        menuKindTypeList = phoneType.mineKinds.get(Relation.CONTENT_ITEM_TYPE).typeList;
        break;
      case "events":
        menuKindTypeList = phoneType.mineKinds.get(Birthday.CONTENT_ITEM_TYPE).typeList;
        break;
      default:
        break;
    }
    return menuKindTypeList;
  }

  public menuChange(typeName: string, data: any, item: any) {
    switch (typeName) {
      case "phone":
        if (ObjectUtil.isEmpty(this.contactInfoAfter.phones[data.i - 1])) {
          this.contactInfoAfter.phones[data.i - 1] = new PhoneNumBean("", "", "", "", "");
        }
        this.contactInfoAfter.phones[data.i - 1].numType = item.rawValue.toString();
        break;
      case "email":
        if (ObjectUtil.isEmpty(this.contactInfoAfter.emails[data.i - 1])) {
          this.contactInfoAfter.emails[data.i - 1] = new EmailBean("", "", "");
        }
        this.contactInfoAfter.emails[data.i - 1].emailType = item.rawValue.toString();
        break;
      case "AIM":
        if (ObjectUtil.isEmpty(this.contactInfoAfter.aims[data.i - 1])) {
          this.contactInfoAfter.aims[data.i - 1] = new AIMBean("", "", "", "");
        }
        this.contactInfoAfter.aims[data.i - 1].aimType = item.rawValue.toString();
        break;
      case "house":
        if (ObjectUtil.isEmpty(this.contactInfoAfter.houses[data.i - 1])) {
          this.contactInfoAfter.houses[data.i - 1] = new HouseBean("", "", "", "");
        }
        this.contactInfoAfter.houses[data.i - 1].houseType = item.rawValue.toString();
        break;
      case "relationships":
        if (ObjectUtil.isEmpty(this.contactInfoAfter.relationships[data.i - 1])) {
          this.contactInfoAfter.relationships[data.i - 1] = new AssociatedPersonBean("", "", "", "");
        }
        this.contactInfoAfter.relationships[data.i - 1].associatedType = item.rawValue.toString();
        break;
      case "events":
        if (ObjectUtil.isEmpty(this.contactInfoAfter.events[data.i - 1])) {
          this.contactInfoAfter.events[data.i - 1] = new EventBean("", "", "", "");
        }
        this.contactInfoAfter.events[data.i - 1].eventType = item.rawValue.toString();
        break;
      default:
        break;
    }
    this.refresh();
  }

  public saveContact() {
    this.clickAftEvent = new Date();
    if (this.isExistenceInfo(this.contactInfoAfter) && !this.clicksMultiple()) {
      if (this.updateShow == false) {
        ContactAbility.addContact(this.contactInfoAfter, null, (arg) => {
          this.contactId = arg.toString();
          this.routerAvtiveFlag = true;
        })
      }
      else {
        ContactAbility.updateContact(null, this.contactInfoAfter, (arg) => {
          this.contactId = arg.toString();
          this.routerAvtiveFlag = true;
        })
      }
    }
  }

  private clicksMultiple() {
    if (this.clickAftEvent.getTime() - this.clickBefEvent.getTime() > AccountantsPresenter.timeSub) {
      this.clickBefEvent = this.clickAftEvent;
      return false;
    }
    else {
      this.clickBefEvent = this.clickAftEvent;
      return true;
    }
  }

  public getAddState() {
    return this.addState;
  }
}