/*
 * Copyright 2011 Fictorial LLC. All Rights Reserved.
 *
 * This file is part of RPS World Masters - Online Rock Paper Scissors.
 *
 * RPS World Masters - Online Rock Paper Scissors is free software: you can
 * redistribute it and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * RPS World Masters - Online Rock Paper Scissors is distributed in the hope that
 * it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
 * Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * RPS World Masters - Online Rock Paper Scissors.  If not, see
 * <http://www.gnu.org/licenses/>.
 */


#import "MatchController.h"
//#import "BaseScene.h"
//#import "MainMenuLayer.h"
#import "MatchState.h"
//#import "MatchScene.h"


#import "cocos2d.h"
#import "UIImage+Resize.h"
#include "CCLuaEngine.h"
#include "CCLuaBridge.h"
#import <Parse/Parse.h>
#define USER_SELF_GAME_SERVER_MATCH 1

static NSString * const kRPSErrorInvalidData = @"invalid data sent by peer";

static MatchController *theManager = nil;

@interface MatchController ()
@property (nonatomic, retain, readwrite) NSDictionary *scriptHandlers;
@property (nonatomic, retain, readwrite) MatchState *matchState;
//@property (nonatomic, retain, readwrite) MatchScene *matchScene;

- (void)showError:(NSString *)errorMessage;
- (void)handleRemotePlayerForfeit:(RPSForfeitReason)reason;
- (void)clearCurrentMatch;
- (void)returnToMainMenu;

@end

@implementation MatchController

@synthesize matchState,  playersOnline;//matchScene,

+ (MatchController *)sharedController {
    if (theManager == nil)
        theManager = [[MatchController alloc] init];

    return theManager;
}

+ (id)alloc {
    NSAssert(theManager == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

- (id)init {
    if ((self = [super init])) {
        GameKitHelper *gkHelper = [GameKitHelper sharedGameKitHelper];

        if (!gkHelper.isGameCenterAvailable) {
            // This shouldn't happen since we require GC in the info.plist
            // but let's be defensive anyway.

            [self showError:@"Game Center is required for this game to function."];
        } else {
            gkHelper.delegate = self;
            gkHelper.usesAchievements = NO;          // this game does not use em!
            [gkHelper authenticateLocalPlayer];
        }
    }
    return self;
}
-(void) call:(int)callback params:(cocos2d::LuaValueArray *)arr
{
    if (arr==nil)
        return ;
    cocos2d::LuaBridge::pushLuaFunctionById(callback);
    cocos2d::LuaStack *stack = cocos2d::LuaBridge::getStack();
    stack->pushLuaValueArray(*arr);
    stack->executeFunction(1);
    //cocos2d::LuaBridge::releaseLuaFunctionById(callback);
    delete arr;
    
    
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
- (void)dealloc {
    if (self.matchState)
        [self forfeitMatch:kRPSForfeitReasonAppTermination];

    [self clearCurrentMatch];

    [super dealloc];
}

- (void)showError:(NSString *)errorMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Center Error"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];

//    CCScene *scene = [BaseScene sceneWithLayerClass:@"ErrorLayer"];
//    scene.tag = kRPSTagSceneError;
//    [[CCDirector sharedDirector] replaceScene:
//     [CCTransitionFade transitionWithDuration:kRPSTransitionDuration
//                                        scene:scene
//                                    withColor:ccRED]];
}
-(void)registerScriptHandler:(NSDictionary *)handlers
{
    self.scriptHandlers = handlers;
    //goMainMenuHandler = [[handlers objectForKey:@"goMainMenuHandler"] intValue];
    //[[LuaObjectCBridgeTest getInstance] setScriptHandler:[[dict objectForKey:@"scriptHandler"] intValue]];
    
}

- (void)clearCurrentMatch {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    [[GameKitHelper sharedGameKitHelper] disconnectCurrentMatch];

    self.matchState.delegate = nil;
    //self.matchScene.delegate = nil;

    //self.matchScene = nil;
    self.matchState = nil;
}

- (void)returnToMainMenu {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    [self clearCurrentMatch];
    //[MainMenuLayer replaceCurrentScene];
    //[self call:goMainMenuHandler];
    
    //[self call:[[self.scriptHandlers objectForKey:@"setCurrentPlayerHandler"] intValue] param:nil];
    [self call:[[self.scriptHandlers objectForKey:@"enterMenuSceneHandler"] intValue] param:nil];
}

- (void)onLocalPlayerAuthenticationChanged {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    // We were put into the background, the player logged out of Game Center,
    // another user logged in, and we were brought back to the foreground.

    [self clearCurrentMatch];
}

- (void)authenticationFailedWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    [self showError:[error localizedDescription]];

    //GAN_TRACK_EVENT_WITH_LABEL(@"errors", @"auth", [error localizedDescription]);
}

- (void)authenticationSucceeded {
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    #ifdef USER_SELF_GAME_SERVER_MATCH
        cocos2d::LuaValueDict *dic =  new cocos2d::LuaValueDict();
    
        dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("success", cocos2d::LuaValue::stringValue("ok")));
    
        dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("playerId", cocos2d::LuaValue::stringValue([localPlayer.playerID cStringUsingEncoding:NSASCIIStringEncoding])));
    
    #else

    
    
    [localPlayer loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo1, NSError *error){
        cocos2d::LuaValueDict *dic =  new cocos2d::LuaValueDict();
        if(error == nil){
            if (photo1.size.width>256) {
                photo1 = [photo1 imageScaledToSize:CGSizeMake(256, 256)];
            }
            NSData *data = UIImagePNGRepresentation(photo1);
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
            NSString *avatarPath = [NSString stringWithFormat:@"%@/%@.png",basePath,localPlayer.playerID];
            [data writeToFile:avatarPath atomically:YES];

            cocos2d::Image tm;
            //avatarPath
            tm.initWithImageData((unsigned char *)data.bytes,data.length);
            cocos2d::Texture2D *texture = new cocos2d::Texture2D();
            texture->initWithImage(&tm);
            cocos2d::Sprite *sprite = cocos2d::Sprite::createWithTexture(texture);
            sprite->retain();
            texture->release();
            dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("avatar", cocos2d::LuaValue::ccobjectValue(sprite,"Sprite")));
          
        } else {
          
        }
        
        dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("name", cocos2d::LuaValue::stringValue([localPlayer.alias cStringUsingEncoding:NSUTF8StringEncoding])));
        dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("success", cocos2d::LuaValue::stringValue("ok")));
        
        [self call:[[self.scriptHandlers objectForKey:@"setCurrentPlayerHandler"] intValue] param:dic];
    }];
    cocos2d::LuaValueDict *dic =  new cocos2d::LuaValueDict();
    
    dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("success", cocos2d::LuaValue::stringValue("ok")));
    
    dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("playerId", cocos2d::LuaValue::stringValue([localPlayer.playerID cStringUsingEncoding:NSASCIIStringEncoding])));
    #endif
    [self call:[[self.scriptHandlers objectForKey:@"onGameCenterAuthSuccessedHandler"] intValue]  param:dic];
    
//    [PFUser logInWithUsernameInBackground:localPlayer.playerID password:@"mypass"
//                                    block:^(PFUser *user, NSError *error) {
//                                        if (user) {
//                                            // Do stuff after successful login.
//                                            PFUser *currentUser = [PFUser currentUser];
//                                            NSLog(@"logIn currentUser username = %@",currentUser.username);
//                                            [[GameKitHelper sharedGameKitHelper] queryMatchmakingActivity];
//                                        } else {
//                                            if (error.code==101) {
//                                                PFUser *user = [PFUser user];
//                                                user.username = localPlayer.playerID;
//                                                
//                                                user.password = @"mypass";
//                                                
//                                                
//                                                // other fields can be set just like with PFObject
//                                                user[@"game_center_id"] = localPlayer.playerID;
//                                                user[@"coin"] = @"7000";
//                                                
//                                                
//                                                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                                                    if (!error) {
//                                                        // Hooray! Let them use the app now.
//                                                        PFUser *currentUser = [PFUser currentUser];
//                                                        NSLog(@"signUp currentUser username = %@",currentUser.username);
//                                                        [[GameKitHelper sharedGameKitHelper] queryMatchmakingActivity];
//                                                    } else {
//                                                        NSString *errorString = [error userInfo][@"error"];
//                                                        NSLog(@"errorString = %@",errorString);
//                                                        // Show the errorString somewhere and let the user try again.
//                                                        [self showError:[error localizedDescription]];
//                                                    }
//                                                }];
//                                            }
//                                            // The login failed. Check error to see why.
//                                            NSLog(@"error = %@",error);
//                                        }
//                                    }];
    
}

- (void)onFriendListReceived:(NSArray*)friends {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

// Scores here are simply the number of matches won by the player.
// Flow for score submission:
// 1) updateLocalPlayerScoreByOne
// 2) onScoresReceived:
// 3) onScoresSubmitted:

- (void)updateLocalPlayerScoreByOne {
    //[[GameKitHelper sharedGameKitHelper] retrieveLocalPlayerScoreForCategory:kRPSLeaderboardName];
}

- (void)onScoresReceived:(NSArray*)scores {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    int64_t newScore = 1;

    // scores is nil on first post to the leaderboard for the local player.

    if (scores) {
        GKScore *localPlayerScore = [scores objectAtIndex:0];
        newScore = localPlayerScore.value+1;
        NSLog(@"Fetched current score for winning player; is %d", (int)localPlayerScore.value);
    }

    //[[GameKitHelper sharedGameKitHelper] submitScore:newScore category:kRPSLeaderboardName];
}

- (void)onScoresSubmitted:(bool)success {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    UIAlertView *alert;

    if (success) {
        alert = [[UIAlertView alloc] initWithTitle:@"Leaderboard Updated"
                                           message:@"Your win has been posted to the leaderboard!"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Leaderboard Error"
                                           message:[[[GameKitHelper sharedGameKitHelper] lastError] localizedDescription]
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
    }

    [alert show];
    [alert release];
}

- (void)onAchievementReported:(GKAchievement*)achievement {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onAchievementsLoaded:(NSDictionary*)achievements {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onResetAchievements:(bool)success {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onMatchFound:(GKMatch*)match {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onMatchRequestError {
    NSError *error = [[GameKitHelper sharedGameKitHelper] lastError];

    if (error && [error code] != GKErrorCancelled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Requesting Match"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

    if ([error code] != GKErrorCancelled)
        [self performSelector:@selector(returnToMainMenu) withObject:nil afterDelay:1];

    //GAN_TRACK_EVENT_WITH_LABEL(@"errors", @"match-request", [error localizedDescription]);
}

- (void)onPlayersAddedToMatch:(bool)success {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onReceivedMatchmakingActivity:(NSInteger)activity {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    //NSLog(@"activity=%d",activity);
    //playersOnline = activity;

    // All info ready for the main menu layer so show it as a scene.

   // [MainMenuLayer replaceCurrentScene];
    
    //[self call:[[self.scriptHandlers objectForKey:@"setCurrentPlayerHandler"] intValue] param:nil];
   [self call:[[self.scriptHandlers objectForKey:@"enterMenuSceneHandler"] intValue] param:nil];
}

- (void)onPlayerConnected:(NSString*)playerID {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onPlayerDisconnected:(NSString*)playerID {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    cocos2d::LuaValueDict *dic =  new cocos2d::LuaValueDict();
    
    dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("success", cocos2d::LuaValue::stringValue("ok")));
  
    dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("playerId", cocos2d::LuaValue::stringValue([playerID cStringUsingEncoding:NSASCIIStringEncoding])));
    [self call:[[self.scriptHandlers objectForKey:@"onPlayerDisconnectedHandler"] intValue]  param:dic];
    
    //[self returnToMainMenu];
}

- (void)onStartMatch {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    // We need to know the alias / nick of the remote player before we can show the match scene.
    // This will call us back with onPlayerInfoReceived:

    GameKitHelper *gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper getPlayerInfo:[NSArray arrayWithObject:[gkHelper.currentMatch.playerIDs objectAtIndex:0]]];

    // Save the number of matches started with this local player.
    // We may need to act on it in the future for reporting the percentage of matches resigned, etc.

    NSString *matchesStartedCountKey = [NSString stringWithFormat:@"%@_matchesStarted",
                                        [GKLocalPlayer localPlayer].playerID];

    [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:matchesStartedCountKey] + 1
                                               forKey:matchesStartedCountKey];

    [[NSUserDefaults standardUserDefaults] synchronize];

    //GAN_TRACK_PAGEVIEW(@"matchStart");
} 
- (void)onPlayerInfoReceived:(NSArray*)players {
//    dispatch_async(dispatch_get_current_queue(),^{
//        NSLog(@"dispatch_async %@", NSStringFromSelector(_cmd));
//    });
//    dispatch_sync(dispatch_get_current_queue(),^{
//     NSLog(@"dispatch_sync %@", NSStringFromSelector(_cmd));
//    });
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    cocos2d::LuaValueArray *arr = new cocos2d::LuaValueArray();
    dispatch_group_t group = dispatch_group_create();
    for(int i=0;i<players.count;i++)
    {
        GKPlayer *remotePlayer  = [players objectAtIndex:i];
        NSLog(@"player name = %@",remotePlayer.alias);
        dispatch_group_enter(group); //For each element, enter the group
        [remotePlayer loadPhotoForSize:GKPhotoSizeSmall withCompletionHandler:^(UIImage *photo1, NSError *error){
            cocos2d::LuaValueDict *dic =  new cocos2d::LuaValueDict();
            if(error == nil){
                
                NSLog(@"photo1.size = %@",NSStringFromCGSize(photo1.size));
                if (photo1.size.width>256) {
                    photo1 = [photo1 imageScaledToSize:CGSizeMake(256, 256)];
                }
                NSData *data = UIImagePNGRepresentation(photo1);
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
                NSString *avatarPath = [NSString stringWithFormat:@"%@/%@.png",basePath,remotePlayer.playerID];
                [data writeToFile:avatarPath atomically:YES];
                
                cocos2d::Image tm;
                //avatarPath
                tm.initWithImageData((unsigned char *)data.bytes,data.length);
                cocos2d::Texture2D *texture = new cocos2d::Texture2D();
                texture->initWithImage(&tm);
                cocos2d::Sprite *sprite = cocos2d::Sprite::createWithTexture(texture);
                texture->release();
                sprite->retain();
                dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("avatar", cocos2d::LuaValue::ccobjectValue(sprite,"Sprite")));
                
            } else {
                
            }
            
            dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("name", cocos2d::LuaValue::stringValue([remotePlayer.alias cStringUsingEncoding:NSUTF8StringEncoding])));
            
            dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("playerId", cocos2d::LuaValue::stringValue([remotePlayer.playerID cStringUsingEncoding:NSASCIIStringEncoding])));
            arr->push_back(cocos2d::LuaValue::dictValue(*dic));
            dispatch_group_leave(group); //Leave group when the operation is done
            
            
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //This is called when all process have leave the group
         [self call:[[self.scriptHandlers objectForKey:@"onPlayerInfoReceivedHandler"] intValue] params:arr];
    });

   
    
   
    // Now that we have the remote player's alias we can show the match scene.

//    MatchScene *scene = [MatchScene node];
//    scene.tag = kRPSTagSceneMatch;
//    scene.delegate = self;
//    self.matchScene = scene;
//
//    GKPlayer *remotePlayer = (GKPlayer *)[players objectAtIndex:0];
//    [scene setRemotePlayerName:remotePlayer.alias];
//
//    [[CCDirector sharedDirector] pushScene:
//     [CCTransitionFade transitionWithDuration:kRPSTransitionDuration/2 scene:scene withColor:ccBLACK]];

    MatchState *ms = [[MatchState alloc] init];
    ms.delegate = self;
    self.matchState = ms;
    [ms release];
}

- (NSString *)handleThrowPacket:(NSData *)data {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    PlayerThrowPacket packet;
    memcpy(&packet, [data bytes], sizeof(PlayerThrowPacket));

    if (packet.magic != kRPSPacketTypeThrow) {
        NSLog(@"packet magic value invalid; expected %u got %u", kRPSPacketTypeThrow, packet.magic);
        return kRPSErrorInvalidData;
    }

    if (packet.throwNo != matchState.totalThrows || packet.setNo != matchState.setNo) {
        NSLog(@"recv'd throw info for wrong throw; expected set %u total throws %u; got set %u total throws %u",
              matchState.setNo, matchState.totalThrows, packet.setNo, packet.throwNo);

        return kRPSErrorInvalidData;
    }

//    if (packet.throwType != kRPSThrowRock &&
//        packet.throwType != kRPSThrowPaper &&
//        packet.throwType != kRPSThrowScissors) {
//
//        NSLog(@"recv'd throw info but it's not R, P, or S but %c", packet.throwType);
//        return kRPSErrorInvalidData;
//    }
//
//    CCLOG(@"recv'd throw is valid; it's a %c", packet.throwType);
//
//    matchState.remoteThrowNext = packet.throwType;
    return nil;
}

- (NSString *)describeForfeitReason:(RPSForfeitReason)why {
    switch (why) {
        case kRPSForfeitReasonResign:
            return @"resign";

        case kRPSForfeitReasonAppTermination:
            return @"term";

        case kRPSForfeitReasonInactivityTimeout:
            return @"inactivity";

        default:
            return @"unknown";
    }

    return nil;
}

// Local player is forfeiting the current match.

- (void)forfeitMatch:(RPSForfeitReason)why {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (!matchState)
        return;

    // Save the number of resignations made to the local defaults.
    // We may actually report on this later.
    // Yes, the user may use multiple devices with the same GC account,
    // but there's no central off-site place to store this so it's local device or nothing.

    NSString *resignationCountKey = [NSString stringWithFormat:@"%@_resignations",
                                     [GKLocalPlayer localPlayer].playerID];

    [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:resignationCountKey] + 1
                                               forKey:resignationCountKey];

    [[NSUserDefaults standardUserDefaults] synchronize];

    //GAN_TRACK_PAGEVIEW(@"matchEnd");
    //GAN_TRACK_EVENT_WITH_LABEL(@"forfeits", @"local", [self describeForfeitReason:why]);

    // Notify remote peer of our forfeit.
    // Do this before returning to the previous scene.
    // The other side will detect us not doing anything so there's no reason to tell
    // them we've done nothing on this side in case of inactivity timeouts :)

    if (why != kRPSForfeitReasonInactivityTimeout) {
        ForfeitMatchPacket packet = { kRPSPacketTypeForfeit, static_cast<uint8_t>(why) };
        [[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:[NSData dataWithBytes:&packet length:sizeof(packet)]];
    }

    switch (why) {
        case kRPSForfeitReasonResign:
            [self returnToMainMenu];
            break;

        case kRPSForfeitReasonAppTermination:
            [self clearCurrentMatch];
            break;

        case kRPSForfeitReasonInactivityTimeout: {
            // Placebo warning

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Match Canceled"
                                                            message:(@"You failed to act within the allotted time. "
                                                                     @"Note: repeat offenders will be reported.")
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];

            [alert show];
            [alert release];

            [self returnToMainMenu];
            break;
        }

        default:
            break;
    }
}

- (void)handleRemotePlayerForfeit:(RPSForfeitReason)reason {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (!matchState)
        return;

    //GAN_TRACK_PAGEVIEW(@"matchEnd");
    //GAN_TRACK_EVENT_WITH_LABEL(@"forfeits", @"remote", [self describeForfeitReason:reason]);

    switch (reason) {
        case kRPSForfeitReasonResign:
           // [matchScene setMessage:@"Your opponent resigned!"];

//            if (matchState.totalThrows >= kRPSMatchMinThrows)
//                [self updateLocalPlayerScoreByOne];

            break;

        case kRPSForfeitReasonAppTermination:
        case kRPSForfeitReasonInactivityTimeout: {
            // This reporting the remote player thing is a just a placebo.

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Match Canceled"
                                                            message:(@"The match has been canceled since your opponnent "
                                                                     @"failed to act. If you feel that your opponent was "
                                                                     @"trying to avoid a loss, you may report them for review. "
                                                                     @"Would you like to report your opponent?")
                                                            delegate:nil
                                                   cancelButtonTitle:@"No"
                                                   otherButtonTitles:@"Yes", nil];
            [alert show];
            [alert release];
            break;
        }

        default:
            break;
    }

    //[self performSelector:@selector(returnToMainMenu) withObject:nil afterDelay:kRPSGameOverMainMenuDelay];
}

- (NSString *)handleForfeitPacket:(NSData *)data {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    ForfeitMatchPacket packet;
    memcpy(&packet, [data bytes], sizeof(ForfeitMatchPacket));

    if (packet.magic != kRPSPacketTypeForfeit) {
        NSLog(@"packet magic value invalid; expected %u got %u", kRPSPacketTypeForfeit, packet.magic);
        return kRPSErrorInvalidData;
    }

    //[self handleRemotePlayerForfeit:packet.reason];

    return nil;
}

- (void)onReceivedData:(NSData *)data fromPlayer:(NSString*)playerID {
    //NSLog(@"%@", NSStringFromSelector(_cmd));

    if (!matchState)
        return;

    NSString *error = nil;

//    uint32_t magic;
//    memcpy(&magic, [data bytes], sizeof(uint32_t));
//
//    switch (magic) {
//        case kRPSPacketTypeThrow:
//            error = [self handleThrowPacket:data];
//            break;
//
//        case kRPSPacketTypeForfeit:
//            error = [self handleForfeitPacket:data];
//            break;
//
//        default:
//            //NSLog(@"unknown packet with magic %u recv'd");
//            error = kRPSErrorInvalidData;
//            break;
//    }
    

    
    
    
    cocos2d::LuaValueDict *dic =  new cocos2d::LuaValueDict();
    
    
    //dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("name", cocos2d::LuaValue::stringValue([localPlayer.alias cStringUsingEncoding:NSUTF8StringEncoding])));
    dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("success", cocos2d::LuaValue::stringValue("ok")));
    NSString *dataString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("playerId", cocos2d::LuaValue::stringValue([playerID cStringUsingEncoding:NSASCIIStringEncoding])));
    dic->insert(dic->end(),cocos2d::LuaValueDict::value_type("jsonData", cocos2d::LuaValue::stringValue([dataString cStringUsingEncoding:NSASCIIStringEncoding])));
    [self call:[[self.scriptHandlers objectForKey:@"onReceivedDataByPlayerHandler"] intValue]  param:dic];
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communications Error"
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];

       // GAN_TRACK_EVENT_WITH_LABEL(@"errors", @"comm", error);

        [self performSelector:@selector(returnToMainMenu) withObject:nil afterDelay:1];
    }
}

- (void)onMatchmakingViewDismissed {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onMatchmakingViewError {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    NSString *desc = [[[GameKitHelper sharedGameKitHelper] lastError] localizedDescription];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Creating Challenge"
                                                    message:desc
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];

    //GAN_TRACK_EVENT_WITH_LABEL(@"errors", @"matchmaking", desc);

    [self performSelector:@selector(returnToMainMenu) withObject:nil afterDelay:1];
}

- (void)onLeaderboardViewDismissed {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onAchievementsViewDismissed {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark -
#pragma mark MatchStateDelegate

- (void)localPlayerWentOnTheClock {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (matchState.outcome == kRPSMatchOutcomeNone) {
        //[matchScene localPlayerWentOnTheClock];

        //GAN_TRACK_EVENT_WITH_LABEL(@"clock", @"local", @"on");
    }
}

- (void)localPlayerWentOffTheClock {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (matchState.outcome == kRPSMatchOutcomeNone) {
//        [matchScene localPlayerWentOffTheClock];
//
//        GAN_TRACK_EVENT_WITH_LABEL(@"clock", @"local", @"off");
    }
}

- (void)localPlayerMightForfeitOnInactivity {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    //if (matchState.outcome == kRPSMatchOutcomeNone)
       // [matchScene localPlayerMightForfeitOnInactivity];
}

- (void)localPlayerForfeitsOnInactivity {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (matchState.outcome == kRPSMatchOutcomeNone)
        [self forfeitMatch:kRPSForfeitReasonInactivityTimeout];
}

- (void)remotePlayerWentOnTheClock {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (matchState.outcome == kRPSMatchOutcomeNone) {
        //[matchScene remotePlayerWentOnTheClock];

        //GAN_TRACK_EVENT_WITH_LABEL(@"clock", @"remote", @"on");
    }
}

- (void)remotePlayerWentOffTheClock {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (matchState.outcome == kRPSMatchOutcomeNone) {
        //[matchScene remotePlayerWentOffTheClock];

        //GAN_TRACK_EVENT_WITH_LABEL(@"clock", @"remote", @"off");
    }
}

- (void)remotePlayerMightForfeitOnInactivity {
    NSLog(@"%@", NSStringFromSelector(_cmd));

   // if (matchState.outcome == kRPSMatchOutcomeNone)
       // [matchScene remotePlayerMightForfeitOnInactivity];
}

- (void)remotePlayerForfeitsOnInactivity {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    if (matchState.outcome == kRPSMatchOutcomeNone)
        [self handleRemotePlayerForfeit:kRPSForfeitReasonInactivityTimeout];
}

#pragma mark -
#pragma mark MatchSceneDelegate
//
//- (void)localPlayerSelected:(RPSThrowType)throwType {
//    CCLOG(@"%@:%c", NSStringFromSelector(_cmd), throwType);
//
//    NSAssert(matchState, @"no active match");
//    NSAssert(throwType != kRPSThrowNone, @"cannot throw 'none'");
//
//    PlayerThrowPacket packet = {
//        .magic     = kRPSPacketTypeThrow,
//        .setNo     = matchState.setNo,
//        .throwNo   = matchState.totalThrows,
//        .throwType = throwType
//    };
//
//    NSData *data = [NSData dataWithBytes:&packet length:sizeof(PlayerThrowPacket)];
//    [[GameKitHelper sharedGameKitHelper] sendDataToAllPlayers:data];
//
//    NSString *throwTypeDesc = nil;
//
//    switch (throwType) {
//        case kRPSThrowNone:
//            throwTypeDesc = @"none??";
//            break;
//        case kRPSThrowRock:
//            throwTypeDesc = @"rock";
//            break;
//        case kRPSThrowPaper:
//            throwTypeDesc = @"paper";
//            break;
//        case kRPSThrowScissors:
//            throwTypeDesc = @"scissors";
//            break;
//        default:
//            throwTypeDesc = @"unknown";
//            break;
//    }
//
//    GAN_TRACK_EVENT(@"choices", throwTypeDesc);
//}

// Tell the match state to advance based on the next-throw selections
// of the local and remote player.

- (void)handAnimationsDidFinish {
    MatchOutcome outcome = [matchState determineOutcomeForNextThrow];

   // [matchScene updateScoreboardFromMatchState];

//    switch (outcome) {
//        case kRPSMatchOutcomeNone:
//            break;
//
//        case kRPSMatchOutcomeLocalWin:
//            [matchScene setMessage:@"You won!"];
//            [[SimpleAudioEngine sharedEngine] playEffect:@"you-win.caf"];
//            [self updateLocalPlayerScoreByOne];
//            [self performSelector:@selector(returnToMainMenu) withObject:nil afterDelay:kRPSGameOverMainMenuDelay];
//            GAN_TRACK_PAGEVIEW(@"matchEnd");
//            break;
//
//        case kRPSMatchOutcomeRemoteWin:
//            [[SimpleAudioEngine sharedEngine] playEffect:@"you-lose.caf"];
//            [matchScene setMessage:@"You lost!"];
//            [self performSelector:@selector(returnToMainMenu) withObject:nil afterDelay:kRPSGameOverMainMenuDelay];
//            GAN_TRACK_PAGEVIEW(@"matchEnd");
//            break;
//
//        default:
//            break;
//    }
}










//lua  call

+(void)findOpponent
{
    GKMatchRequest* request = [[[GKMatchRequest alloc] init] autorelease];
    request.minPlayers = request.maxPlayers = 2;
    
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper cancelMatchmakingRequest];  // if any
    [gkHelper findMatchForRequest:request];
}
+(void)cancelMatchmakingRequest
{
  
    [[GameKitHelper sharedGameKitHelper] cancelMatchmakingRequest];
   
}
+(void)sendDataToAllPlayer:(NSDictionary*)dic
{
    
    GameKitHelper* gkHelper = [GameKitHelper sharedGameKitHelper];
    [gkHelper sendDataToAllPlayers:[[dic objectForKey:@"data"] dataUsingEncoding:NSASCIIStringEncoding]];
    
}

@end
