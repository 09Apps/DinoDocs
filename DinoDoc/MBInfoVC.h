//
//  MBInfoVC.h
//  KichenCalender
//
//  Created by Swapnil Takalkar on 8/27/13.
//  Copyright (c) 2013 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface MBInfoVC : UIViewController <MFMailComposeViewControllerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (nonatomic, strong) NSString* openurl;
@end
