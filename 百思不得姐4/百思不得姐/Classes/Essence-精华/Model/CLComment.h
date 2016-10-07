//
//  CLComment.h
//  百思不得姐
//
//  Created by 杨博兴 on 16/10/4.
//  Copyright © 2016年 xx_cc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLUser;
@interface CLComment : NSObject

@property(nonatomic,strong)NSString *content;

@property(nonatomic,strong)CLUser *user;

@end
