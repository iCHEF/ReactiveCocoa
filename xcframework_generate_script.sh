#!/bin/bash

echo "### start execute script"

# 尋找當前目錄底下副檔名為 xcodeproj 的檔案，找不到則結束程式。
# 如果順利找到的話，應該會是像 "kkbox.xcodeproj" 這樣子的字串。
proj_name=( *.xcodeproj )
[[ -e $proj_name ]] || { echo "Not found *.xcodeproj"; exit 1; }

xcodebuild -version

# archive 出實體機版本的 framework
xcodebuild clean archive \
-project $proj_name \
-scheme "ReactiveCocoa iOS" \
-destination "generic/platform=iOS" \
-archivePath "archives/iOS" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
ALWAYS_SEARCH_USER_PATHS=NO

# archive 出模擬器版本的 framework
xcodebuild clean archive \
-project $proj_name \
-scheme "ReactiveCocoa iOS" \
-destination "generic/platform=iOS Simulator" \
-archivePath "archives/Simulator" \
SKIP_INSTALL=NO \
BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
ALWAYS_SEARCH_USER_PATHS=NO

# 合併以上兩個版本成為一個 xcframework 

# framework_name="${proj_name%.*}"
framework_name="ReactiveCocoa"
xcodebuild -create-xcframework \
-archive archives/iOS.xcarchive -framework ReactiveCocoa.framework \
-archive archives/Simulator.xcarchive -framework ReactiveCocoa.framework \
-output ./archives/ReactiveCocoa.xcframework
# -framework ./archives/iOS.xcarchive/Products/Library/Frameworks/$framework_name.framework \
# -framework ./archives/Simulator.xcarchive/Products/Library/Frameworks/$framework_name.framework \


exit 0
