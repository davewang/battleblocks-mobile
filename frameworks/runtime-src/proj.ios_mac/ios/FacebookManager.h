
#import <Foundation/Foundation.h>

#import "FBConnect.h"

#include <string>
#include <sstream>
#include <iostream>
#import <vector>
#include <FBSDKShareKit/FBSDKShareKit.h>
#include <FBSDKCoreKit/FBSDKCoreKit.h>
#include <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FacebookManager : NSObject <FBSDKAppInviteDialogDelegate,FBSessionDelegate, FBRequestDelegate, FBDialogDelegate,FBSDKGameRequestDialogDelegate>
{
    Facebook *facebook;
//	ThirdPartyAccountDelegate *delegate;
    NSString  *allFriendId;
    NSString  *allInstalledFriendId;
    NSString  *allUnInstalledFriendId;
    NSMutableArray *allFriendIdArray;
    NSMutableArray *allInstalledFriendIdArray;
    NSMutableArray *allUnInstalledFriendIdArray;
    NSString  *type;
    NSDictionary *meInfo;
}

@property (nonatomic, retain) Facebook *facebook;
//@property (nonatomic, assign) ThirdPartyAccountDelegate *delegate;
@property (nonatomic, retain)  NSString  *allFriendId;
@property (nonatomic, retain)  NSString  *allInstalledFriendId;
@property (nonatomic, retain)  NSString  *allUnInstalledFriendId;
@property (nonatomic, retain) NSMutableArray *allFriendIdArray;
@property (nonatomic, retain) NSMutableArray *allInstalledFriendIdArray;
@property (nonatomic, retain) NSMutableArray *allUnInstalledFriendIdArray;
@property (nonatomic, retain)  NSString  *type;

+ (FacebookManager*) sharedManager;

+ (void) invite:(NSDictionary*)dic;
+ (void) post:(NSDictionary*)dic;
+ (void) send:(NSDictionary*)dic;
+ (void) userInfo:(NSDictionary*)dic;

- (void) queryUserInfo;
- (void) post:(NSString *)name title:(NSString*)title content:(NSString*)content;
- (void) invite:(NSString *)message title:(NSString*)title userUnInstalled:(std::vector<std::string>)content;
- (void) request:(NSString *)message title:(NSString*)title userOfRequested:(std::vector<std::string>)content;
- (void) send:(NSString *)message title:(NSString*)title sendId:(NSString*) sendId;
- (void) logout;
- (void)getMeInfo;

@end
