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

import IAccountTypeService from './IAccountTypeService';
import PhoneAccountType from './type/PhoneAccountType';
import AccountType from './type/AccountType';


/**
 * Account type service, which is used to display account characteristics such as account type holding contact details.
 */
export default class AccountTypeService implements IAccountTypeService {
  constructor() {
  }

  getAccountType(accountType: string) {
    return new PhoneAccountType();
  }
}