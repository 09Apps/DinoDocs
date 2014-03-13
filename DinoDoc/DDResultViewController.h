//
//  DDResultViewController.h
//  DinoDoc
//
//  Created by Swapnil Takalkar on 3/8/14.
//  Copyright (c) 2014 09Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDResultViewController : UIViewController

@property NSUInteger score;
@property NSUInteger time;
@property (weak, nonatomic) IBOutlet UILabel *scorelbl;

@end
