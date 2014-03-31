platform :ios, '7.0'

pod 'MagicalRecord'
pod 'FrameAccessor'
pod 'FlatUIKit'

target :DriftTests, :exclusive => true do
    pod 'Expecta'
end

post_install do | installer |
    prefix_header = installer.sandbox_root + 'Pods-MagicalRecord-prefix.pch'
    text = prefix_header.read.gsub("#import \"CoreData+MagicalRecord.h\"","#define MR_ENABLE_ACTIVE_RECORD_LOGGING 0\n#import \"CoreData+MagicalRecord.h\"")
    prefix_header.open('w') { |file| file.write(text) }
end