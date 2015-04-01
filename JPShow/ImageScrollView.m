//
//  ImageScrollView.m
//  iVertuad
//
//  Created by apple on 13-12-10.
//  Copyright (c) 2013年 jetsen. All rights reserved.
//

#import "ImageScrollView.h"
#import "UIImageView+DispatchLoad.h"


@implementation ImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        
        loadable = YES;
        
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        loadingView.frame = CGRectMake(0, 0, 40, 40);
        loadingView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self addSubview:loadingView];

        [loadingView startAnimating];
        
        
        //        altImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 100)];
        //        altImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        //        altImageView.image = [UIImage imageNamed:@"loading_back03.png"];
        //        altImageView.contentMode = UIViewContentModeScaleAspectFit;
        //        [self addSubview:altImageView];
        //        [self bringSubviewToFront:altImageView];
        //        [altImageView release];
        
    }
    return self;
}

- (void)formerFrameView
{
    imageView.frame = formerFrame;
    self.zoomScale = 1.0;
    [self layoutSubviews];
    imageView.frame = formerFrame;
    self.zoomScale = 1.0;
    [self layoutSubviews];
//    [self setMaxMinZoomScalesForCurrentBounds];
}

#pragma mark -
#pragma mark Override layoutSubviews to center content

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;
    
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

//- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
//{
//    CGFloat offsetX = (aScrollView.bounds.size.width > aScrollView.contentSize.width)?
//    (aScrollView.bounds.size.width - aScrollView.contentSize.width) * 0.5 : 0.0;
//    CGFloat offsetY = (aScrollView.bounds.size.height > aScrollView.contentSize.height)?
//    (aScrollView.bounds.size.height - aScrollView.contentSize.height) * 0.5 : 0.0;
//    imageView.center = CGPointMake(aScrollView.contentSize.width * 0.5 + offsetX,
//                                   aScrollView.contentSize.height * 0.5 + offsetY);
//
//}

#pragma mark -
#pragma mark Configure scrollView to display new image (tiled or not)
- (UIImage *) showImage
{
    if(imageView && imageView.image)
    {
        return imageView.image;
    }
    
    return nil;
}
//yxlong add;20120713
- (CGRect) fitImagePositionToCenter:(UIImage *) image
{
    CGSize boundsSize = self.bounds.size;
    
    CGRect frameToCenter;
    
    if(image.size.width > boundsSize.width)
    {
        int iWidth = boundsSize.width;
        int iHeight = image.size.height*iWidth/image.size.width;
        if (iHeight > boundsSize.height) {
            
            iWidth = iWidth*boundsSize.height/iHeight;
            iHeight = boundsSize.height;
        }
        frameToCenter = CGRectMake(0, 0, iWidth, iHeight);
        self.contentSize = CGSizeMake(iWidth, iHeight);//image.size;
    }
    else if(image.size.height > boundsSize.height)
    {
        frameToCenter = CGRectMake(0, 0, image.size.width*(boundsSize.height/image.size.height), boundsSize.height);
        self.contentSize = CGSizeMake(image.size.width*(boundsSize.height/image.size.height), boundsSize.height);//image.size;
    }
    else{
        frameToCenter = CGRectMake((boundsSize.width-image.size.width)/2, (boundsSize.height-image.size.height)/2, image.size.width, image.size.height);
        self.contentSize = image.size;
    }
    
    return frameToCenter;
}

//yxlong add;20120713
- (BOOL)shouldLoadImage
{
    if(imageView&&!imageView.image&&loadable)
    {
        return YES;
    }
    return NO;
}

//yxlong add;20120713
- (void)displayNetImage:(NSString *) imageUrl
{
    
    loadable = NO;
    
//    NSLog(@"imageUrl-%@",imageUrl);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    [imageView setImageFromUrl:imageUrl completion:^{
        
        if(loadingView)
        {
            [loadingView stopAnimating];
            [loadingView removeFromSuperview];loadingView=nil;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        }
        
        if(altImageView)
        {
            //缓冲图片
            [altImageView removeFromSuperview];altImageView = nil;
        }
        
        imageView.frame = [self fitImagePositionToCenter:imageView.image];
        
        formerFrame = imageView.frame;
        self.maximumZoomScale = 10;
        self.minimumZoomScale = .2;
        
        self.zoomScale = 1.0;
        
    } downLoadFailed:^{
        
        if(loadingView)
        {
            [loadingView stopAnimating];
            [loadingView removeFromSuperview];loadingView=nil;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
    
}

#pragma origin methods
- (void)displayLoadImage:(NSString *)imagePath
{
    loadable = NO;
    
    //    NSLog(@"imageUrl-%@",imageUrl);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    [imageView setImageFromURL:imagePath completion:^{
        
        if(loadingView)
        {
            [loadingView stopAnimating];
            [loadingView removeFromSuperview];loadingView=nil;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
        }
        
        if(altImageView)
        {
            //缓冲图片
            [altImageView removeFromSuperview];altImageView = nil;
        }
        
        imageView.frame = [self fitImagePositionToCenter:imageView.image];
        
        formerFrame = imageView.frame;
        self.maximumZoomScale = 10;
        self.minimumZoomScale = .2;
        
        self.zoomScale = 1.0;
        
    } downLoadFailed:^{
        
        if(loadingView)
        {
            [loadingView stopAnimating];
            [loadingView removeFromSuperview];loadingView=nil;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}


#pragma origin methods
- (void)displayImage:(UIImage *)image
{
    // clear the previous imageView
    [imageView removeFromSuperview];
    imageView = nil;
    
    
    if(loadingView)
    {
        [loadingView stopAnimating];
        [loadingView removeFromSuperview];loadingView=nil;
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }
    // reset our zoomScale to 1.0 before doing any further calculations
    self.minimumZoomScale = .2;
    self.zoomScale = 1.0;
    
    // make a new UIImageView for the new image
    imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    
    self.contentSize = [image size];
    [self setMaxMinZoomScalesForCurrentBounds];
    //    self.zoomScale = self.minimumZoomScale;
}


- (void)setMaxMinZoomScalesForCurrentBounds
{
    
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = imageView.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 10.0 / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.maximumZoomScale = maxScale;
    //    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
}

#pragma mark -
#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image

// returns the center point, in image coordinate space, to try to restore after rotation.
- (CGPoint)pointToCenterAfterRotation
{
    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    return [self convertPoint:boundsCenter toView:imageView];
}

// returns the zoom scale to attempt to restore after rotation.
- (CGFloat)scaleToRestoreAfterRotation
{
    CGFloat contentScale = self.zoomScale;
    
    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
    // allowable scale when the scale is restored.
    if (contentScale <= self.minimumZoomScale + FLT_EPSILON)
        contentScale = 0;
    
    return contentScale;
}

- (CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
}

- (CGPoint)minimumContentOffset
{
    return CGPointZero;
}

// Adjusts content offset and scale to try to preserve the old zoomscale and center.
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale
{
    // Step 1: restore zoom scale, first making sure it is within the allowable range.
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    
    // Step 2: restore center point, first making sure it is within the allowable range.
    
    // 2a: convert our desired center point back to our own coordinate space
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:imageView];
    // 2b: calculate the content offset that would yield that center point
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
                                 boundsCenter.y - self.bounds.size.height / 2.0);
    // 2c: restore offset, adjusted to be within the allowable range
    CGPoint maxOffset = [self maximumContentOffset];
    CGPoint minOffset = [self minimumContentOffset];
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
    self.contentOffset = offset;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 2)
    {
        CGFloat zs = self.zoomScale;
        zs = (zs == 1.0) ? 2.0 : 1.0;
        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        [UIView beginAnimations:nil context:context];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.zoomScale = zs;
        [UIView commitAnimations];
    }
}

@end


//#import "ImageScrollView.h"
//#import "UIImageView+DispatchLoad.h"
//
//
//@implementation ImageScrollView
//
//- (id)initWithFrame:(CGRect)frame
//{
//    if ((self = [super initWithFrame:frame])) {
//        
//        
//        self.showsVerticalScrollIndicator = NO;
//        self.showsHorizontalScrollIndicator = NO;
//        self.bouncesZoom = YES;
//        self.decelerationRate = UIScrollViewDecelerationRateFast;
//        self.delegate = self;    
//        
//        loadable = YES;
//        
//        imageView = [[UIImageView alloc] init];
//        imageView.contentMode=UIViewContentModeScaleAspectFit;
//        [self addSubview:imageView];
//        
//        
//        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        loadingView.frame = CGRectMake(0, 0, 40, 40);
//        loadingView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//        [self addSubview:loadingView];
//        [loadingView startAnimating];
//        
//        
////        altImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 100)];
////        altImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
////        altImageView.image = [UIImage imageNamed:@"loading_back03.png"];
////        altImageView.contentMode = UIViewContentModeScaleAspectFit;
////        [self addSubview:altImageView];
////        [self bringSubviewToFront:altImageView];
////        [altImageView release];
//        
//    }
//    return self;
//}
//
//
//
//
//#pragma mark -
//#pragma mark Override layoutSubviews to center content
//
//- (void)layoutSubviews 
//{
//    [super layoutSubviews];
//    
//    // center the image as it becomes smaller than the size of the screen
//    
//    CGSize boundsSize = self.bounds.size;
//    CGRect frameToCenter = imageView.frame;
//    
//    // center horizontally
//    if (frameToCenter.size.width < boundsSize.width)
//        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
//    else
//        frameToCenter.origin.x = 0;
//    
//    // center vertically
//    if (frameToCenter.size.height < boundsSize.height)
//        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
//    else
//        frameToCenter.origin.y = 0;
//    
//    imageView.frame = frameToCenter;
//    
//}
//
//#pragma mark -
//#pragma mark UIScrollView delegate methods
//
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return imageView;
//}
//
////- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
////{
////    CGFloat offsetX = (aScrollView.bounds.size.width > aScrollView.contentSize.width)?
////    (aScrollView.bounds.size.width - aScrollView.contentSize.width) * 0.5 : 0.0;
////    CGFloat offsetY = (aScrollView.bounds.size.height > aScrollView.contentSize.height)?
////    (aScrollView.bounds.size.height - aScrollView.contentSize.height) * 0.5 : 0.0;
////    imageView.center = CGPointMake(aScrollView.contentSize.width * 0.5 + offsetX,
////                                   aScrollView.contentSize.height * 0.5 + offsetY);
////    
////}
//
//#pragma mark -
//#pragma mark Configure scrollView to display new image (tiled or not)
//- (UIImage *) showImage
//{
//    if(imageView&&imageView.image)
//    {
//        return imageView.image;
//    }
//    
//    return nil;
//}
////yxlong add;20120713
//- (CGRect) fitImagePositionToCenter:(UIImage *) image
//{
//    CGSize boundsSize = self.bounds.size;
//    
//    CGRect frameToCenter;
//    
//    if(image.size.width > boundsSize.width)
//    {        
//        int iWidth = boundsSize.width;
//        int iHeight = image.size.height*iWidth/image.size.width;
//        if (iHeight > boundsSize.height) {
//            
//            iWidth = iWidth*boundsSize.height/iHeight;
//            iHeight = boundsSize.height;
//        }
//        frameToCenter = CGRectMake(0, 0, iWidth, iHeight);
//        self.contentSize = CGSizeMake(iWidth, iHeight);//image.size;
//    }
//    else if(image.size.height > boundsSize.height)
//    {
//        frameToCenter = CGRectMake(0, 0, image.size.width*(boundsSize.height/image.size.height), boundsSize.height);
//        self.contentSize = CGSizeMake(image.size.width*(boundsSize.height/image.size.height), boundsSize.height);//image.size;
//    }
//    else{
//        frameToCenter = CGRectMake((boundsSize.width-image.size.width)/2, (boundsSize.height-image.size.height)/2, image.size.width, image.size.height);
//        self.contentSize = image.size;
//    }
//    
//    return frameToCenter;
//}
//
////yxlong add;20120713
//- (BOOL)shouldLoadImage
//{
//    if(imageView&&!imageView.image&&loadable)
//    {
//        return YES;
//    }
//    return NO;
//}
//
////yxlong add;20120713
//- (void)displayNetImage:(NSString *) imageUrl
//{
//    
//    loadable = NO;
//    
//    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    
//    
//    // reset our zoomScale to 1.0 before doing any further calculations
//    self.zoomScale = 1.0;
//    
//    [imageView setImageFromUrl:imageUrl completion:^{
//        
//        if(loadingView)
//        {
//            [loadingView stopAnimating];
//            [loadingView removeFromSuperview];
//            
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            
//        }
//        
//        if(altImageView)
//        {
//            //缓冲图片
//            [altImageView removeFromSuperview];
//        }
//        
//        imageView.frame = [self fitImagePositionToCenter:imageView.image];
//        
//        self.maximumZoomScale = 3;
//        self.minimumZoomScale = .5;
//        
//        self.zoomScale = 1.0;
//        
//    } downLoadFailed:^{
//        
//        if(loadingView)
//        {
//            [loadingView stopAnimating];
//            [loadingView removeFromSuperview];;
//            
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        }
//    }];
//    
//}
//
//
//
//#pragma origin methods
//- (void)displayImage:(UIImage *)image
//{
//    // clear the previous imageView
//    [imageView removeFromSuperview];
//  
//    imageView = nil;
//    
//    // reset our zoomScale to 1.0 before doing any further calculations
//    self.zoomScale = 1.0;
//    
//    // make a new UIImageView for the new image
//    imageView = [[UIImageView alloc] initWithImage:image];
//    imageView.contentMode=UIViewContentModeScaleAspectFit;
//    [self addSubview:imageView];
//    
//    self.contentSize = [image size];
//    [self setMaxMinZoomScalesForCurrentBounds];
//    self.zoomScale = self.minimumZoomScale;
//}
//
//
//- (void)setMaxMinZoomScalesForCurrentBounds
//{
//    
//    CGSize boundsSize = self.bounds.size;
//    CGSize imageSize = imageView.bounds.size;
//    
//    // calculate min/max zoomscale
//    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
//    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
//    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
//    
//    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
//    // maximum zoom scale to 0.5.
//    CGFloat maxScale = 3.0 / [[UIScreen mainScreen] scale];
//    
//    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
//    if (minScale > maxScale) {
//        minScale = maxScale;
//    }
//    
//    self.maximumZoomScale = maxScale;
//    self.minimumZoomScale = minScale;
//    
//}
//
//#pragma mark -
//#pragma mark Methods called during rotation to preserve the zoomScale and the visible portion of the image
//
//// returns the center point, in image coordinate space, to try to restore after rotation. 
//- (CGPoint)pointToCenterAfterRotation
//{
//    CGPoint boundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
//    return [self convertPoint:boundsCenter toView:imageView];
//}
//
//// returns the zoom scale to attempt to restore after rotation. 
//- (CGFloat)scaleToRestoreAfterRotation
//{
//    CGFloat contentScale = self.zoomScale;
//    
//    // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
//    // allowable scale when the scale is restored.
//    if (contentScale <= self.minimumZoomScale + FLT_EPSILON)
//        contentScale = 0;
//    
//    return contentScale;
//}
//
//- (CGPoint)maximumContentOffset
//{
//    CGSize contentSize = self.contentSize;
//    CGSize boundsSize = self.bounds.size;
//    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
//}
//
//- (CGPoint)minimumContentOffset
//{
//    return CGPointZero;
//}
//
//// Adjusts content offset and scale to try to preserve the old zoomscale and center.
//- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale
//{    
//    // Step 1: restore zoom scale, first making sure it is within the allowable range.
//    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
//    
//    
//    // Step 2: restore center point, first making sure it is within the allowable range.
//    
//    // 2a: convert our desired center point back to our own coordinate space
//    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:imageView];
//    // 2b: calculate the content offset that would yield that center point
//    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0, 
//                                 boundsCenter.y - self.bounds.size.height / 2.0);
//    // 2c: restore offset, adjusted to be within the allowable range
//    CGPoint maxOffset = [self maximumContentOffset];
//    CGPoint minOffset = [self minimumContentOffset];
//    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
//    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
//    self.contentOffset = offset;
//}
//
//@end
