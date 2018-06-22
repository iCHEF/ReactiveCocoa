Pod::Spec.new do |s|
  s.name         = "ReactiveCocoa"
  s.version      = "2.5"
  s.summary      = "Streams of values over time"
  s.description  = <<-DESC
  ReactiveCocoa (RAC) is an Objective-C framework inspired by Functional Reactive Programming. It provides APIs for composing and transforming streams of values.
                   DESC
  s.homepage     = "https://github.com/ReactiveCocoa/ReactiveCocoa"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = "ReactiveCocoa"

  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"

  s.source       = { :git => "https://github.com/iCHEF/ReactiveCocoa.git", :tag => "#{s.version}" }
  s.source_files          = "ReactiveCocoa/*.{h,m,d}",
                            "ReactiveCocoa/extobjc/*.{h,m}"

  non_arc_files = 'ReactiveCocoa/RACObjCRuntime.m'
  
  s.private_header_files  = "**/*Private.h",
                            "**/*EXTRuntimeExtensions.h", 
                            "**/RACEmpty*.h"

  s.ios.exclude_files     = "ReactiveCocoa/**/*{AppKit,NSControl,NSText,NSTable}*", non_arc_files

  s.osx.exclude_files     = "ReactiveCocoa/**/*{UIActionSheet,UIAlertView,UIBarButtonItem,"\
                            "UIButton,UICollectionReusableView,UIControl,UIDatePicker,"\
                            "UIGestureRecognizer,UIImagePicker,UIRefreshControl,"\
                            "UISegmentedControl,UISlider,UIStepper,UISwitch,UITableViewCell,"\
                            "UITableViewHeaderFooterView,UIText,MK}*", non_arc_files
                            
  s.tvos.exclude_files    = "ReactiveCocoa/**/*{AppKit,NSControl,NSText,NSTable,UIActionSheet,"\
                            "UIAlertView,UIDatePicker,UIImagePicker,UIRefreshControl,UISlider,"\
                            "UIStepper,UISwitch,MK}*", non_arc_files

  s.watchos.exclude_files = "ReactiveCocoa/**/*{UIActionSheet,UIAlertView,UIBarButtonItem,"\
                            "UIButton,UICollectionReusableView,UIControl,UIDatePicker,"\
                            "UIGestureRecognizer,UIImagePicker,UIRefreshControl,"\
                            "UISegmentedControl,UISlider,UIStepper,UISwitch,UITableViewCell,"\
                            "UITableViewHeaderFooterView,UIText,MK,AppKit,NSControl,NSText,"\
                            "NSTable,NSURLConnection}*", non_arc_files

  s.frameworks   = "Foundation"

  s.prepare_command = <<-'CMD'.strip_heredoc
                        find -E . -type f -not -name 'RAC*' -regex '.*(EXT.*|metamacros)\.[hm]$' \
                                  -execdir mv '{}' RAC'{}' \;
                        find . -regex '.*\.[hm]' \
                               -exec perl -pi \
                                          -e 's@"(?:(?!RAC)(EXT.*|metamacros))\.h"@"RAC\1.h"@' '{}' \;
                        find . -regex '.*\.[hm]' \
                               -exec perl -pi \
                                          -e 's@<ReactiveCocoa/(?:(?!RAC)(EXT.*))\.h>@<ReactiveCocoa/RAC\1.h>@' '{}' \;
                      CMD

  s.subspec 'no-arc' do |sp|
    sp.source_files = non_arc_files
    sp.requires_arc = false 
  end
end