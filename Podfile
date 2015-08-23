source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
plugin 'cocoapods-keys', {
	:project => 'SuperjobExample',
	:target => 'SuperjobExample',
	:keys => [
    	"SuperjobApplicantKey"
    ]
}

inhibit_all_warnings!
target 'SuperjobExample' do
	pod 'Objection', '~> 1.5'
	pod 'ReactiveCocoa', '~> 2.5'
	pod 'AFNetworking', '~> 2.5.4'
	pod 'Mantle', '~> 2.0.4'
end

target 'SuperjobExampleTests' do
	pod 'Specta'
	pod 'Expecta'
	pod 'OCMockito'
end

post_install do |installer|
    file = Tempfile.new('mantle.patch')
    file.write("--- Mantle.h    2015-07-14 15:05:26.000000000 +0300
+++ Mantle.h  2015-08-23 15:05:01.000000000 +0300
@@ -14,8 +14,8 @@
 //! Project version string for Mantle.
 FOUNDATION_EXPORT const unsigned char MantleVersionString[];

-#import <Mantle/MTLJSONAdapter.h>
 #import <Mantle/MTLModel.h>
+#import <Mantle/MTLJSONAdapter.h>
 #import <Mantle/MTLModel+NSCoding.h>
 #import <Mantle/MTLValueTransformer.h>
 #import <Mantle/MTLTransformerErrorHandling.h>")
    file.close
    `patch Pods/Mantle/Mantle/Mantle.h < #{file.path}`
    file.unlink
end