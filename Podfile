platform :ios, '14.0'

artifactory_url = 'https://artifactory-external.vkpartner.ru/artifactory/vk-ios-sdk'

target 'PlayerDemo' do
  use_frameworks!

  pod 'WebM', :podspec => "#{artifactory_url}/WebM/1.1/WebM.podspec", :inhibit_warnings => true
  pod 'OVPlayerKit', :podspec => "#{artifactory_url}/OVPlayerKit/3.55/OVPlayerKit.podspec", :inhibit_warnings => true
  pod 'VKOpus', :podspec => "#{artifactory_url}/VKOpus/1.0/VKOpus.podspec", :inhibit_warnings => true
  pod 'OVKit', :podspec => "#{artifactory_url}/OVKit/5.15/OVKit.podspec", :inhibit_warnings => true
  pod 'VPX', :podspec => "#{artifactory_url}/VPX/1.1/VPX.podspec", :inhibit_warnings => true
  pod 'OVKResources', :podspec => "#{artifactory_url}/OVKResources/2.53/OVKResources.podspec", :inhibit_warnings => true
  pod 'Dav1d', :podspec => "#{artifactory_url}/Dav1d/2.0/Dav1d.podspec", :inhibit_warnings => true
  pod 'OVKitStatistics', :podspec => "#{artifactory_url}/OVKitStatistics/1.2/OVKitStatistics.podspec", :inhibit_warnings => true
end