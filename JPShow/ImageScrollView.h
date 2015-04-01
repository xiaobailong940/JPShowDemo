//
//  ImageScrollView.h
//  iVertuad
//
//  Created by apple on 13-12-10.
//  Copyright (c) 2013年 jetsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate>{
    
    __block UIActivityIndicatorView * loadingView;
    __block UIImageView * altImageView;
    UIImageView   *imageView;
    BOOL loadable;
    CGRect formerFrame;
    
}

//yxlong add;20120713
- (UIImage *) showImage;
- (CGRect)fitImagePositionToCenter:(UIImage *) image;
- (BOOL)shouldLoadImage;
- (void)displayNetImage:(NSString *) imageUrl;
- (void)displayLoadImage:(NSString *)imagePath;

//origin methods
- (void)displayImage:(UIImage *)image;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;
- (void)formerFrameView;

@end
