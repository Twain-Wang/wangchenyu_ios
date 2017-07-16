//
//  XXNavigationController.h
//  XXNavigationController
//
//  Created by Tracy on 14-3-5.
//  Copyright (c) 2014年 Mark. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XXNavigationControllerDelegate <NSObject>
@optional
    -(void)Rateofprogress:(float)rate;
    -(void)willPushViewController;
@end

@interface XXNavigationController : UINavigationController
{
    __weak id<XXNavigationControllerDelegate> _mydelegate;
}
@property (nonatomic,weak) id<XXNavigationControllerDelegate> mydelegate;
@end
