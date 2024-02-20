#!/bin/sh

echo "Xcode Cloud 빌드를 위한 환경을 세팅합니다..."

cd ..

plutil -replace BaseURL -string $API_BASEURL "MSData/Sources/MSData/Resources/APIInfo.plist"

exit 0
