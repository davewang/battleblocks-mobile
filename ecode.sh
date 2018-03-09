rm -rf out/
#/Users/dave/projects/cocos2d-x/cocos2d-x-3.4/tools/cocos2d-console/bin/cocos luacompile -s src/ -d out/ -e -k emma@0401 -b dave@0707 --disable-compile
/Users/dave/projects/cocos2d-x/cocos2d-x-3.4/tools/cocos2d-console/bin/cocos luacompile -s src/ -d out/ -e -k emma@0401 -b dave@0707 --disable-compile
cd out/
zip -r game.zip *
zip -r game1.zip game.zip
cp game.zip ../res/game.zip
#mv game1.zip ../BattleCode/public/files/game.zip
#cd ../BattleCode/
#parse deploy
#xcrun instruments -w "882712E2-2569-4A9C-9295-CC01E181ECDB"
#xcrun simctl launch booted "net.iapploft.games.battletetris" | cut -b 34- | xargs kill -9 
#xcrun simctl launch booted "net.iapploft.games.battletetris"
# xcodebuild -configuration "Release" -arch "armv7 arm64" -target "BattleTetris iOS" -sdk iphoneos CODE_SIGN_IDENTITY="iPhone Distribution: Jinsheng Wang" GCC_VERSION="com.apple.compilers.llvm.clang.1_0" -project ./frameworks/runtime-src/proj.ios_mac/BattleTetris.xcodeproj
