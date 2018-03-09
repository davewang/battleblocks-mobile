//
//  PurchaseManager.h
//  BattleTetris
//
//  Created by dave on 15/3/26.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#include "CCLuaEngine.h"
#include "CCLuaBridge.h"
@interface PurchaseManager : NSObject
@property(nonatomic,retain)NSDictionary *handlers;
+(PurchaseManager*) sharedPurchaseManager;

//+(void)buyProduct:(NSString*)uid handlers:(NSDictionary*) handlers
+(void)buyForProduct:(NSDictionary*) handlers;
-(void) call:(int)callback param:(cocos2d::LuaValueDict *)dic;
@end
