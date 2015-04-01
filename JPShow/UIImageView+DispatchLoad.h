//
//  UIImageView+DispatchLoad.h
//  iDou
//
//  Created by apple on 13-12-10.
//  Copyright (c) 2012年 水蓝 Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import <QuartzCore/QuartzCore.h>

@interface UIImageView (DispatchLoad)
- (void) setImageFromUrl:(NSString*)urlString;
- (void) setImageFromUrl:(NSString*)urlString 
              completion:(void (^)(void))completion;

- (void) setImageFromUrl:(NSString*)urlString 
              completion:(void (^)(void))completion 
          downLoadFailed:(void (^)(void))loadFailed;

- (void) setImageFromURL:(NSString*)urlString
              completion:(void (^)(void))completion
          downLoadFailed:(void (^)(void))loadFailed;

@end
