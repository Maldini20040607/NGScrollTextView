//
//  NGScrollTextView.h
//  NGScrollTextView
//
//  Created by Ning Gang on 2017/3/21.
//  Copyright © 2017年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NGScrollTextViewDelegate <NSObject>

-(void)clickScrollTextMessage:(NSDictionary *)dict;

@end

@interface NGScrollTextView : UIView


-(id)initWithFrame:(CGRect) rect Delegate:(id<NGScrollTextViewDelegate>) delegate;

-(void)setDataWithImage:(NSString*)imagePath contentArr:(NSArray<NSDictionary*>*)arr;

@end
