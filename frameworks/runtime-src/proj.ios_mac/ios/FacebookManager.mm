#import "FacebookManager.h"
//#import "Login.h"
#import "SBJSON.h"
#import <vector>
//#import "Message.h"
//#import "MessageDispatcher.h"
//#import "EntityMessages.h"
//#include "NotificationCenter.h"

@implementation FacebookManager

@synthesize facebook;
//@synthesize delegate;
@synthesize allFriendId,allInstalledFriendId,allUnInstalledFriendId;
@synthesize allFriendIdArray,allInstalledFriendIdArray,allUnInstalledFriendIdArray;
@synthesize type;

static FacebookManager *sharedFacebookManager = nil;

+ (FacebookManager*) sharedManager
{
    if (sharedFacebookManager == nil)
        sharedFacebookManager = [[super allocWithZone:NULL] init];
    return sharedFacebookManager;
}
/*!
 @abstract Sent to the delegate when the app invite completes without error.
 @param appInviteDialog The FBSDKAppInviteDialog that completed.
 @param results The results from the dialog.  This may be nil or empty.
 */
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"results = %@",results);
}

/*!
 @abstract Sent to the delegate when the app invite encounters an error.
 @param appInviteDialog The FBSDKAppInviteDialog that completed.
 @param error The error.
 */
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    NSLog(@"error = %@",error);
}


+ (void) invite:(NSDictionary*)dic
{
   // std::vector<std::string> ids;
   // [[FacebookManager sharedManager] invite:[dic objectForKey:@"message"] title:[dic objectForKey:@"title"] userUnInstalled:ids];
    
    FBSDKGameRequestContent *gameRequestContent = [[FBSDKGameRequestContent alloc] init];
    
    //FBSDKAppInviteContent *appInviteContent = [[FBSDKAppInviteContent alloc] init];
    //appInviteContent.appInvitePreviewImageURL = [NSURL URLWithString:@"http://www.iapploft.net"];
    //appInviteContent.appLinkURL =  [NSURL URLWithString:@"https://itunes.apple.com/us/app/monkey-junior-teach-your-child/id930331514?mt=8"];
    //[FBSDKAppInviteDialog showWithContent:appInviteContent delegate:[FacebookManager sharedManager]];
    // Look at FBSDKGameRequestContent for futher optional properties
    gameRequestContent.message = [dic objectForKey:@"message"];
     gameRequestContent.title = [dic objectForKey:@"title"] ;
    // gameRequestContent.to =@[ @"861193893957676"];
    // Assuming self implements <FBSDKGameRequestDialogDelegate>
    [FBSDKGameRequestDialog showWithContent:gameRequestContent delegate:[FacebookManager sharedManager]];
    
}
+ (void) post:(NSDictionary*)dic
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"http://www.iapploft.net"];
    content.imageURL = [NSURL URLWithString:@"https://secure.gravatar.com/avatar/12af64b0dc1a159f4009293ecf2cf87b?size=220&default=https%3A%2F%2Fwww.parse.com%2Fimages%2Faccounts%2Fno_avatar.png"];
    
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.mode = FBSDKShareDialogModeWeb;
    
    //dialog.fromViewController = self;
    dialog.shareContent = content;
    [dialog show];
    //[[FacebookManager sharedManager] post:[dic objectForKey:@"name"]  title:[dic objectForKey:@"title"]  content:[dic objectForKey:@"message"]];
}
+ (void) send:(NSDictionary*)dic
{
    FBSDKGameRequestContent *gameRequestContent = [[FBSDKGameRequestContent alloc] init];
    // Look at FBSDKGameRequestContent for futher optional properties
    gameRequestContent.message = [dic objectForKey:@"message"];
    gameRequestContent.title = [dic objectForKey:@"title"] ;
   // gameRequestContent.to = @[ [dic objectForKey:@"sendId"]];
    gameRequestContent.recipients =  @[ [dic objectForKey:@"sendId"]];
    // Assuming self implements <FBSDKGameRequestDialogDelegate>
    [FBSDKGameRequestDialog showWithContent:gameRequestContent delegate:[FacebookManager sharedManager]];
    // [[FacebookManager sharedManager] send:[dic objectForKey:@"message"]  title:[dic objectForKey:@"title"]  sendId:[dic objectForKey:@"sendId"]];
}
+ (void) userInfo:(NSDictionary*)dic
{
    // [[FacebookManager sharedManager] queryUserInfo];
    if ([FBSDKAccessToken currentAccessToken]) {
        [[FacebookManager sharedManager] getMeInfo];
    } else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_actions.news",@"user_actions.fitness",@"user_posts",@"read_stream"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                // Process error
            } else if (result.isCancelled) {
                // Handle cancellations
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                //dang nhap thanh cong
                [[FacebookManager sharedManager]  getMeInfo];
            }
        }];
    }

}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

//- (void)release
//{
//    //do nothing
//}

- (id)autorelease
{
    return self;
}

- (id) init
{
	self = [super init];
	if(self!= NULL)
	{
        facebook = [[Facebook alloc] initWithAppId:@"842963855824402" andDelegate:self];
        //facebook = [[Facebook alloc] initWithAppId:@"186281401544836" andDelegate:self];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"])
        {
            facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
        
        //delegate = NULL;
    }
	return self;
}

- (void) dealloc
{
	[super dealloc];
    sharedFacebookManager = nil;
}
- (void)getMeInfo
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (error) {
//                 loginBtn.visible = YES;
//                 logoutBtn.visible = NO;
//                 lblName.string = @"NULL";
                 NSLog(@"Mat ket noi den server");
             } else {
                  meInfo = result;
                  NSLog(@"me:%@",meInfo);
//                 lblName.string = [meInfo valueForKey:@"name"];
//                 
//                 loginBtn.visible = NO;
//                 logoutBtn.visible = YES;
             }
         }];
    }
    
}
- (void) queryUserInfo
{
    if ([facebook isSessionValid])
    {
        [self sendUserInfoRequest];
    }
    else
    {
        [facebook authorize:nil];
    }
}

//分享
- (void) post:(NSString *)name title:(NSString*)title content:(NSString*)content
{
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    
    // The action links to be shown with the post in the feed
    NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      @"Get Started",@"name",@"http://www.facebook.com/BattleBlocks/",@"link", nil], nil];
    NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    // Dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   name, @"name",
                                   title, @"caption",
                                   content, @"description",
                                   @"http://www.facebook.com/BattleBlocks/", @"link",
                                   @"https://secure.gravatar.com/avatar/12af64b0dc1a159f4009293ecf2cf87b?size=220&default=https%3A%2F%2Fwww.parse.com%2Fimages%2Faccounts%2Fno_avatar.png", @"picture",
                                   actionLinksStr, @"actions",
                                   nil];

    [facebook dialog:@"feed" andParams:params andDelegate:self];
}
//邀请未安装游戏的好友
- (void) invite:(NSString *)message title:(NSString*)title userUnInstalled:( std::vector<std::string>)content
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (std::vector<std::string >::iterator iter=content.begin();iter!=content.end();iter++)
    {
        [array addObject:[NSString stringWithUTF8String:iter->c_str()]];
    }
    
 
     NSString *ids = [NSString stringWithFormat:@"[%@]", [array componentsJoinedByString:@","]];// @"[100004975897139,100003999337218]";
     // NSString *ids =  @"[100004975897139,100003999337218]";
    NSLog(@"ids = %@",ids);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   message, @"message",
                                   title, @"title",
                                   ids, @"exclude_ids",
                                 //  ids, @"suggestions",
                                   @"1", @"frictionless",
                                   //@"send",@"action_type",
                                   @"50",@"maxRecipients",
                                 // @"[100003999337218]",@"object_id",
                                   nil];
    
    [facebook dialog:@"apprequests" andParams:params andDelegate:self];
}

//商店里面向好友请求礼物
- (void) request:(NSString *)message title:(NSString*)title userOfRequested:(std::vector<std::string>)content
{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (std::vector<std::string >::iterator iter=content.begin();iter!=content.end();iter++)
    {
        [array addObject:[NSString stringWithUTF8String:iter->c_str()]];
    }
    NSMutableArray  *limitArray = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i<(i < 40 ? [array count] : 40); i++) {
        
        [limitArray addObject:[array objectAtIndex:i]];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   message, @"message",
                                   title, @"title",
                                   [limitArray componentsJoinedByString:@","], @"suggestions",
                                   @"1", @"frictionless",
                                   nil];
    [facebook dialog:@"apprequests" andParams:params andDelegate:self];
}
//赠送好友礼物
- (void) send:(NSString *)message title:(NSString*)title sendId:(NSString*) sendId
{
    type = @"send";
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   message, @"message",
                                   title, @"title",
                                   sendId, @"to",
                                   @"1", @"frictionless",
                                   nil];
    
    [facebook dialog:@"apprequests" andParams:params andDelegate:self];

}



- (void) logout
{
    [facebook logout];
}

- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self sendUserInfoRequest];
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
   //if (delegate != NULL)
    //  delegate->didNotReceiveUserInfo(614, NULL);
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
    NSLog(@"token extended");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}
/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)sendUserInfoRequest
{
    NSString  *params1 =@"{ \"method\": \"GET\", \"relative_url\": \"me?fields=id,name,gender\" }";
    NSString *params2 = @"{ \"method\": \"GET\", \"relative_url\": \"me/friends?fields=installed\" }";
    NSString *jsonRequestsArray = [NSString stringWithFormat:@"[ %@, %@ ]", params1, params2];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:jsonRequestsArray forKey:@"batch"];
    
    [facebook requestWithGraphPath:@"me" andParams:params andHttpMethod:@"POST" andDelegate:self];
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */

-(void) dialogDidComplete:(FBDialog *)dialog
{
   
 NSLog(@"dialog is:%@ ", dialog.params);

}

-(void) dialogCompleteWithUrl:(NSURL *)url
{
    NSLog(@"url is:%@ ", url);
    NSArray  *array1=[url.absoluteString componentsSeparatedByString:@"="];
    NSArray *array2 = [array1[0] componentsSeparatedByString:@"?"];
    
    if ([array2[1] isEqualToString:@"request"])
    
    {
    if ([type isEqualToString: @"send"])
      {
//            
//            Message  msg = Message(msgHaveSendGiftfbId);
//            msg.put("haveSendGiftfbId",[array1[2] UTF8String]);
//            MsgDispatcher->sendAsycMsg(msg);
       
      }
    else
      {
       
   //   Notification *notification = new Notification;
      std::vector<std::string> *fbIds = new std::vector<std::string>;
      for (int i = 2; i < [array1 count]; i++)
       {
        NSArray *array3 = [array1[i] componentsSeparatedByString:@"&"];
        NSLog(@"fbid = %@",array3[0]);
       
        //void *fbid = static_cast<void*>(new std::string([array3[0] UTF8String]));
        //notifi->setObj(fbid);
          fbIds->push_back([array3[0] UTF8String]);
      }
      if (fbIds->empty()) {
          delete []fbIds;
         // delete  notification;
      }else{
         // notification->setObj(fbIds);
         // NotificationCenter::getInstance()->postNotification(FACKBOOK_INVITE_FRIEND_NOTIFICATION,notification);
      }
     }
    }
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSArray *allResponses = result;
    NSLog( @"[allResponses count]: %lu", (unsigned long)[allResponses count] );
    
    for ( int i=0; i < [allResponses count]; i++ ) {
        NSDictionary *response = [allResponses objectAtIndex:i];
        int httpCode = [[response objectForKey:@"code"] intValue];
        NSString *jsonResponse = [response objectForKey:@"body"];
        if ( httpCode != 200 ) {
            NSLog( @"Facebook request error: code: %d  message: %@", httpCode, jsonResponse );
        } else {
            
            SBJsonParser *parser = [[SBJsonParser alloc] init];
            NSDictionary  *rootDic = [parser objectWithString:jsonResponse];
            
            if (i==0) {
               
                NSString* uid = [rootDic objectForKey:@"id"];
                NSString* name = [rootDic objectForKey:@"name"];
                NSString* gender = [rootDic objectForKey:@"gender"];
                NSLog(@"Facebook gender:%@ ", gender);
                NSLog(@"Facebook uid:%@ name:%@", uid, name);
                NSString* male=@"male";
                if ([gender isEqualToString:male])
                {
                    //LoginMgr->setGender(LoginManager::Male);
                }
                else
                {
                    //LoginMgr->setGender(LoginManager::Female);
                }
                //if (delegate != NULL)
                    //delegate->didReceiveUserInfo([uid UTF8String], [name UTF8String]);
                std::vector<std::string> vector1;
              
                //[self invite:@"来玩足球经理吧！" title:@"足球经理" userUnInstalled:vector1];
            }
            else
            {
                
                //[self setAllInstalledFriendIdArray:[[NSMutableArray alloc] init]];
                //[self setAllUnInstalledFriendIdArray:[[NSMutableArray alloc] init]];
                
                NSMutableArray *installeds =  [NSMutableArray array];
                NSMutableArray *unInstalleds =  [NSMutableArray array];
                
                NSArray *allArray = [rootDic objectForKey:@"data"];
                for (int i=0; i<[allArray count]; i++) {
                    
                    NSDictionary  *dic = [allArray objectAtIndex:i];
                    
                    [ allFriendIdArray addObject:[NSString  stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
                   
//                    if (allFriendId == NULL) {
//                        allFriendId = [dic objectForKey:@"id"];
//                    }
//                    else
//                    
//                    {
//                        allFriendId = [[NSString alloc] initWithFormat:@"%@,%@",allFriendId,[dic objectForKey:@"id"]];
//                    }
                    
                    if ([dic count] > 1)
                    {
                         // [ allInstalledFriendIdArray  addObject:[NSString  stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
                        
                        if ([dic objectForKey:@"installed"])
                        {
                            [installeds addObject:[NSString  stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
//                            if (allInstalledFriendId == NULL)
//                            {
//                                allInstalledFriendId = [dic objectForKey:@"id"];
//                            }
//                            else
//                            {
//                                allInstalledFriendId = [[NSString alloc] initWithFormat:@"%@,%@",allInstalledFriendId,[dic objectForKey:@"id"]];
//                            }
                        }
                    }
                    else
                    {
                        [unInstalleds addObject:[NSString  stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
                        //[ allUnInstalledFriendIdArray  addObject:[NSString  stringWithFormat:@"%@",[dic objectForKey:@"id"]]];
//                        
//                        if (allUnInstalledFriendId == NULL)
//                        {
//                            allUnInstalledFriendId = [dic objectForKey:@"id"];
//                        }
//                        else
//                        {
//                            allUnInstalledFriendId = [[NSString alloc] initWithFormat:@"%@,%@",allUnInstalledFriendId,[dic objectForKey:@"id"]];
//                        }
                    }
                }
             //   std::string string;
//                if (allUnInstalledFriendId == NULL ) {
//                    string = "";
//                }
//                else
//                    string = [allUnInstalledFriendId UTF8String];
              // FriendMgr->setFbUserAllUninstalledId(string);
              // FriendMgr->setFbUserAllFriendsId([allFriendId UTF8String]);
                
//                Message  msg = Message(msgFacebookFriends);
//                msg.put("friendsList",[allFriendId UTF8String]);
//                MsgDispatcher->sendAsycMsg(msg);
            }
        }
    }
}





/*!
 @abstract Sent to the delegate when the app group request completes without error.
 @param appGroupAddDialog The FBSDKAppGroupAddDialog that completed.
 @param results The results from the dialog.  This may be nil or empty.
 */
- (void)gameRequestDialog:(FBSDKGameRequestDialog *)appGroupAddDialog didCompleteWithResults:(NSDictionary *)results
{
    NSLog(@"results = %@",results);
}
/*!
 @abstract Sent to the delegate when the app group request encounters an error.
 @param appGroupAddDialog The FBSDKAppGroupAddDialog that completed.
 @param error The error.
 */
- (void)gameRequestDialog:(FBSDKGameRequestDialog *)appGroupAddDialog didFailWithError:(NSError *)error
{
    NSLog(@"results = %@",error);
}

/*!
 @abstract Sent to the delegate when the app group dialog is cancelled.
 @param appGroupAddDialog The FBSDKAppGroupAddDialog that completed.
 */
- (void)gameRequestDialogDidCancel:(FBSDKGameRequestDialog *)appGroupAddDialog
{
    NSLog(@"results = %@",appGroupAddDialog);
}


@end

//void FacebookAccount::setDelegate(ThirdPartyAccountDelegate* delegate)
//{
//    [FacebookManager sharedManager].delegate = delegate;
//}
//
//void FacebookAccount::queryUserInfo()
//{
//    [[FacebookManager sharedManager] queryUserInfo];
//}
//
//void FacebookAccount::logout()
//{
//    [[FacebookManager sharedManager] logout];
//}
//




