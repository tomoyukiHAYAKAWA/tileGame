//
//  opencvWrapper.h
//  opencvTest
//
//  Created by Tomoyuki Hayakawa on 2017/12/08.
//  Copyright © 2017年 Tomoyuki Hayakawa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface opencvWrapper : NSObject
//(返り値の型 *)関数名:(引数の型 *)引数名;
- (UIImage *)toGray:(UIImage *)src;
- (UIImage *)createModel:(UIImage *)src_img;
- (NSArray *)splitImage:(UIImage *)src_img;

@end

