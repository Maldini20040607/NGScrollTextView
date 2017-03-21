//
//  NGScrollContentView.h
//  NGScrollTextView
//
//  Created by Ning Gang on 2017/3/21.
//  Copyright © 2017年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NGScrollContentViewDelegate <NSObject>

-(void)textFlowFinished;

@end

@interface NGScrollContentView : UIView

- (id)initWithFrame:(CGRect)frame Text:(NSMutableAttributedString *)text Attribute:(NSDictionary *) attrDict Delegate:(id<NGScrollContentViewDelegate>)delegate;

-(void)runText;

@end
