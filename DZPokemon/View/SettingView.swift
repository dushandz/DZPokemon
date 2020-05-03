//
//  SettingView.swift
//  DZPokemon
//
//  Created by dushandz on 2020/4/19.
//  Copyright © 2020 dushandz. All rights reserved.
//

import SwiftUI
import Combine


struct SettingRootView: View {
    var body: some View {
        NavigationView {
            SettingView().navigationBarTitle("设置")
        }
    }
}



struct SettingView: View {
    @EnvironmentObject var store: Store
    
    var settingsBinding: Binding<AppState.Settings> {
        $store.appSate.setting
    }
    
    var settings: AppState.Settings {
        store.appSate.setting
    }
    
    var body: some View {
        Form {
            accountSection
            optionSection
            deleteSection
        }
    }
    
    var accountSection: some View {
        Section(header: Text("账户")) {
            Picker(selection: settingsBinding.accountBehavior, label: Text("")) {
                ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                    Text($0.text)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            if settings.user == nil {
                TextField("电子邮箱",text: settingsBinding.email)
                TextField("密码", text: settingsBinding.password)
            } else {
                Text(settings.user!.email)
                Button("注销") {
                    self.store.dispatch(.logout)
                }
            }
            

            if settings.accountBehavior == .register {
                SecureField("确认密码",text: settingsBinding.verifyPassword)

            }
            
            if settings.isRequestLogin == true {
                Text("登录中....")
            }
            
            if settings.user == nil && settings.accountBehavior == .login {
                Button(settings.accountBehavior.text) {
                    self.store.dispatch(.login(self.settings.email, password: self.settings.password))
                }
            }

        }
        
    }
    
    var optionSection: some View {
        Section(header: Text("选项")) {
            Toggle(isOn: settingsBinding.showEnglishName) {
                Text("显示英文名")
            }
            
            Toggle(isOn: settingsBinding.showFavoriteOnly) {
                Text("只显示收藏")
            }
        }
    }
    
    var deleteSection: some View {
        Section() {
            Button("清空缓存") {
                
            }.foregroundColor(.red)
        }
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRootView().environmentObject(Store())
    }
}
