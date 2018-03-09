/****************************************************************************
 Copyright (c) 2010-2011 cocos2d-x.org
 Copyright (c) 2010      Ricardo Quesada
 
 http://www.cocos2d-x.org
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/
//而最新版本中增加了一个GADAdSize.h，所有的 GAD_SIZE的定义放到了该头文件中，且内容和之前的也不一样：


#import "RootViewController.h"
#import "cocos2d.h"
#import "platform/ios/CCEAGLView-ios.h"
#include "ide-support/SimpleConfigParser.h"
//#define MY_BANNER_UNIT_ID @"ca-app-pub-7004251596974931/1400612606"
#define MY_BANNER_UNIT_ID @"ca-app-pub-2340084892588583/5846483750" // ca-app-pub-2340084892588583/5846483750
#define MY_PAGE_UNIT_ID @"ca-app-pub-2340084892588583/8132298957"//"a151931c0a1281c" //ca-app-pub-2340084892588583/8132298957
@implementation RootViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
 
*/
// Override to allow orientations other than the default portrait orientation.
// This method is deprecated on ios6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (SimpleConfigParser::getInstance()->isLanscape()) {
        return UIInterfaceOrientationIsLandscape( interfaceOrientation );
    }else{
        return UIInterfaceOrientationIsPortrait( interfaceOrientation );
    }
}

// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
- (NSUInteger) supportedInterfaceOrientations{
#ifdef __IPHONE_6_0
    if (SimpleConfigParser::getInstance()->isLanscape()) {
        return UIInterfaceOrientationMaskLandscape;
    }else{
        return UIInterfaceOrientationMaskPortrait;//UIInterfaceOrientationMaskPortraitUpsideDown;
    }
#endif
    
}

- (BOOL) shouldAutorotate {
     // return YES;
    if (SimpleConfigParser::getInstance()->isLanscape()) {
        return YES;
    }else{
        return NO;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    cocos2d::GLView *glview = cocos2d::Director::getInstance()->getOpenGLView();

    if (glview)
    {
        CCEAGLView *eaglview = (CCEAGLView*) glview->getEAGLView();

        if (eaglview)
        {
            CGSize s = CGSizeMake([eaglview getWidth], [eaglview getHeight]);
            cocos2d::Application::getInstance()->applicationScreenSizeChanged((int) s.width, (int) s.height);
        }
    }
}
-(void)showBar
{
    if (bannerview_ != nil) {
        [bannerview_ setHidden:NO];
    }else{
        [self addBar];
    }
    
}

-(void)hiddenBar
{
    if (bannerview_ != nil) {
        [bannerview_ setHidden:YES];
    }
    
}
-(void)addBar
{
    //self.view.frame.size.height-CGSizeMake(self.view.frame.size.width, 50).height
    bannerview_ = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,0.0,CGSizeMake(self.view.frame.size.width, 50).width,CGSizeMake(self.view.frame.size.width, 50).height)];
    bannerview_.adUnitID = MY_BANNER_UNIT_ID;
    bannerview_.rootViewController = self;
    
    
    [self.view addSubview:bannerview_];
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[@"f5e07aad0b8d11add6b67b285f753754564f7b8f"];
    [bannerview_ loadRequest:request];

}

-(void)insertPage
{
    NSLog(@"->insertPage");
    interstitial_ = [[GADInterstitial alloc] initWithAdUnitID:MY_PAGE_UNIT_ID];
    
    interstitial_.delegate = self;
    //[interstitial_ loadRequest:[GADRequest request]];
    
//    GADRequest *request = [GADRequest request];
//    
//    // 请求测试广告。填入模拟器
//    // 以及接收测试广告的任何设备的标识符。
//    request.testDevices = [NSArray arrayWithObjects:
//                           @"YOUR_SIMULATOR_IDENTIFIER",
//                           @"YOUR_DEVICE_IDENTIFIER",
//                           nil];
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[@"f5e07aad0b8d11add6b67b285f753754564f7b8f"];
    [interstitial_ loadRequest:request];
    // Initiate a generic request to load it with an ad.
    
    
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [interstitial_ presentFromRootViewController:self];
}


//fix not hide status on ios7
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
