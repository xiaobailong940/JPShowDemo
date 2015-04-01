//
//  UIImageView+DispatchLoad.m
//  iDou
//
//  Created by apple on 13-12-10.
//  Copyright (c) 2012年 水蓝 Tech. All rights reserved.
//

#import "UIImageView+DispatchLoad.h"

@implementation UIImageView (DispatchLoad)


- (void) setImageFromUrl:(NSString*)urlString {
    [self setImageFromUrl:urlString completion:NULL];
}

- (void) setImageFromUrl:(NSString*)urlString 
              completion:(void (^)(void))completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
//        NSLog(@"Starting: %@", urlString);
        
        UIImage *avatarImage = nil; 
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        avatarImage = [UIImage imageWithData:responseData];
        
//        NSLog(@"Finishing: %@", urlString);
        
        
        if (avatarImage) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.image = avatarImage;  

            });
            
            dispatch_async(dispatch_get_main_queue(), completion);
        }
        else {
            
            NSLog(@"download failed!");
        }
    });   
}   

- (void) setImageFromUrl:(NSString*)urlString 
              completion:(void (^)(void))completion 
          downLoadFailed:(void (^)(void))loadFailed{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *avatarImage = nil; 
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        avatarImage = [UIImage imageWithData:responseData];
        
        
        if (avatarImage) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.image = avatarImage;  
                
            });
            
            dispatch_async(dispatch_get_main_queue(), completion);
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), loadFailed);
            
            NSLog(@"download failed!");
        }
    });   
}

- (void) setImageFromURL:(NSString*)urlString
              completion:(void (^)(void))completion
          downLoadFailed:(void (^)(void))loadFailed{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *avatarImage = nil;
        NSURL *url = [[NSURL alloc] initFileURLWithPath:urlString];
        NSData *responseData = [NSData dataWithContentsOfURL:url];
        avatarImage = [UIImage imageWithData:responseData];
        
        
        if (avatarImage) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.image = avatarImage;
                
            });
            
            dispatch_async(dispatch_get_main_queue(), completion);
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), loadFailed);
            
            NSLog(@"download failed!");
        }
    });
}


//CATransition *animation=[CATransition animation];
//animation.delegate = self;
//animation.duration=.6f;
//animation.timingFunction=UIViewAnimationCurveEaseInOut;
//animation.type=@"oglFlip";
//animation.subtype=kCATransitionFromRight;
//animation.fillMode = kCAFillModeBoth;
//
//self.image = avatarImage;  
//
//[[self layer] addAnimation:animation forKey:@"animation"];

@end
