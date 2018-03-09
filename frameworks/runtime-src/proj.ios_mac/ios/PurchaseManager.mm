//
//  PurchaseManager.m
//  BattleTetris
//
//  Created by dave on 15/3/26.
//
//

#import "PurchaseManager.h"
#import <Parse/Parse.h>

@implementation PurchaseManager
@synthesize handlers;
static PurchaseManager * instanceOfPurchaseManager = nil;
+(id) alloc
{
    @synchronized(self)
    {
        NSAssert(instanceOfPurchaseManager == nil, @"Attempted to allocate a second instance of the singleton: GameKitHelper");
        instanceOfPurchaseManager = [[super alloc] retain];
        return instanceOfPurchaseManager;
    }
    
    // to avoid compiler warning
    return nil;
}
+(PurchaseManager*) sharedPurchaseManager
{
    @synchronized(self)
    {
        if (instanceOfPurchaseManager == nil)
        {
             [[PurchaseManager alloc] init];
        }
        
        return instanceOfPurchaseManager;
    }
    
    // to avoid compiler warning
    return nil;
}
-(void) call:(int)callback param:(cocos2d::LuaValueDict *)dic
{
    cocos2d::LuaBridge::pushLuaFunctionById(callback);
    cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
    
    
    if (dic!=nil) {
        stack->pushLuaValueDict(*dic);
    }else{
        dic =  new cocos2d::LuaValueDict();
        dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("success", cocos2d::LuaValue::stringValue("ok")));
        stack->pushLuaValueDict(*dic);
    }
    stack->executeFunction(1);
    //cocos2d::LuaBridge::releaseLuaFunctionById(callback);
    delete dic;
    
    
}
//+(void)buyProduct:(NSString*)uid handlers:(NSDictionary*) handlers
+(void)buyForProduct:(NSDictionary*) handlers;
{
    [PurchaseManager sharedPurchaseManager].handlers = handlers;
    NSLog(@"Purchase id = %@",[handlers objectForKey:@"productId"]);
    [PFPurchase buyProduct:[handlers objectForKey:@"productId"] block:^(NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        cocos2d::LuaValueDict *dic =  new cocos2d::LuaValueDict();
        if (!error) {
           
            dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("success", cocos2d::LuaValue::stringValue("yes")));
            dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("pid", cocos2d::LuaValue::stringValue([[handlers objectForKey:@"productId"] cStringUsingEncoding:NSUTF8StringEncoding] )));
        }else{
            dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("success", cocos2d::LuaValue::stringValue("no")));
        }
        [[PurchaseManager sharedPurchaseManager] call:[[[PurchaseManager sharedPurchaseManager].handlers objectForKey:@"onPurchaseCompileHandler"]  intValue] param: dic];
    }];
}

@end
