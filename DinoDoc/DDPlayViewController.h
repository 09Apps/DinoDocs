//
//  DDPlayViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 1/28/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DDPlayViewController : UIViewController
@property (nonatomic,strong) NSArray* options;
@property (nonatomic,strong) NSString* rtsound;
@property (nonatomic,strong) NSString* wrngsound;
@property (weak, nonatomic) IBOutlet UIButton *button1;


@end
