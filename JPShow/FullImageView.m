//
//  FullImageView.m
//  智慧旅游
//
//  Created by madao on 13-7-29.
//  Copyright (c) 2013年 madao. All rights reserved.
//

#import "FullImageView.h"
#import "ImageScrollView.h"
#import <ShareSDK/ShareSDK.h>
#import "ArticleEntity.h"

@implementation FullImageView
{
    CGFloat viewHeight;
}

- (id)initWithFrame:(CGRect)frame andPictures:(NSArray *)array;
{
    self = [super init];
    if (self) {
      
        
        if (iPhone5)
        {
            viewHeight = HeightFOR5;
        }
        else
        {
            viewHeight = HeightFOR4;
        }
        
       
        sourceArr = array;
        self.backgroundColor = [UIColor blackColor];
        [self CustomViewAppearUP_WithFrame:frame BlockING:nil andBlockED:^{
                   
        }];
        self.toolbar.alpha = 0.5;
        
        UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        leftButton.frame=CGRectMake(10, 10, 22, 22);
        leftButton.showsTouchWhenHighlighted = YES;
        [leftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        
        //增加触发区域
        UIButton* onButton = [UIButton buttonWithType:UIButtonTypeCustom];
        onButton.frame=CGRectMake(-5, 2, 60, 40);
        onButton.showsTouchWhenHighlighted = YES;
        [onButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:onButton];
//        UIButton *backbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backbutton setImage:[UIImage imageNamed:@"contenttoolbar_hd_back_light@2x.jpg"] forState:UIControlStateNormal];
//        [backbutton setImage:[UIImage imageNamed:@"contenttoolbar_hd_back@2x.jpg"] forState:UIControlStateHighlighted];
//        backbutton.frame = CGRectMake(5, 8, 30, 30);
//        [backbutton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:backbutton];
        /*backButtonActio*/
        
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        
        [self showPicture];

        [self loadinfo];
    }
    return self;
}
-(void)showPicture{
    sum = [sourceArr count];
    
    [self initMainContentWithPosition:0];
    
}
- (void)loadinfo{
  
    UIImageView *bview = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 130, 320, 130)];
    //[bview setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"mashup_headimage_cover@2x.png"]]];
    [bview setImage:[UIImage imageNamed:@"mashup_headimage_cover@2x.png"]];
    [self addSubview:bview];
    _title = [[UILabel alloc] initWithFrame:CGRectMake(50, 12,220, 20)];
    [_title setBackgroundColor:[UIColor clearColor]];
    _title.text = @"阿拉法特";
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = [UIColor colorWithRed:253.00/255.00 green:245.00/255.00 blue:230.00/255.00 alpha:1];
    _title.font = [UIFont boldSystemFontOfSize:18];
    
    
    _author = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 250, 20)];
    [_author setBackgroundColor:[UIColor clearColor]];
    _author.text = @"作者:阿拉法特";
    _author.textColor = [UIColor colorWithRed:253.00/255.00 green:245.00/255.00 blue:230.00/255.00 alpha:1];
    _author.font = [UIFont boldSystemFontOfSize:16];
    
    _info = [[UITextView alloc] initWithFrame:CGRectMake(0, viewHeight - 105, 320, 60)]; //355
    _info.textColor = [UIColor colorWithRed:250.00/255.00 green:235.00/255.00 blue:215.00/255.00 alpha:1];
    _info.font = [UIFont systemFontOfSize:15];
    [_info setBackgroundColor: [UIColor clearColor]];
    _info.text = @"我说的几分时间防腐剂手机费i哦书法家哦i欧式哦i方式　是偶发还是哦海鸥后佛和哦回复耦合方式哦废话沙鸥废话欧安会佛活佛啊活佛活佛撒谎佛说法哦说法哦活佛护发素和";
    _info.scrollEnabled = YES;
    _info.editable = NO;
    
    pagenum = [[UILabel alloc] initWithFrame:CGRectMake(270, 3,50, 20)];
    pagenum.textAlignment = NSTextAlignmentCenter;
    [pagenum setBackgroundColor:[UIColor clearColor]];
    pagenum.text = [NSString stringWithFormat:@"1/%d",sum];
    pagenum.textAlignment = NSTextAlignmentCenter;
    pagenum.textColor = [UIColor colorWithRed:253.00/255.00 green:245.00/255.00 blue:230.00/255.00 alpha:1];
    pagenum.font = [UIFont boldSystemFontOfSize:16];
    /*下载按钮*/
    UIButton *down_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [down_button setImage:[UIImage imageNamed:@"contenttoolbar_hd_download_light@2x.png"] forState:UIControlStateNormal];
    down_button.frame = CGRectMake(185, self.frame.size.height - 40, 30, 30);
    /*分享按钮*/
    UIButton *share_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [share_button setImage:[UIImage imageNamed:@"contenttoolbar_hd_share_light@2x.png"] forState:UIControlStateNormal];
    share_button.frame = CGRectMake(235, self.frame.size.height - 40, 30, 30);
    [share_button addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    /*收藏按钮*/
    UIButton *collect_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [collect_button setImage:[UIImage imageNamed:@"contenttoolbar_hd_fav_light@2x.png"] forState:UIControlStateNormal];
    collect_button.frame = CGRectMake(285, self.frame.size.height - 40, 30, 30);
    
    [bview addSubview:_author];
    [bview addSubview:pagenum];
    [self addSubview:_info];
    [self addSubview:_title];
//    [self addSubview:down_button];
//    [self addSubview:share_button];
//    [self addSubview:collect_button];
    

}
- (void)share{

//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:_info.text
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithUrl:@"http://img1.bdstatic.com/img/image/67037d3d539b6003af38f5c4c4f372ac65c1038b63f.jpg"]//[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:NO
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];

}

- (void)initMainContentWithPosition:(int)pos
{
    currentPos = pos;
    
    for(int i =0;i<sum;i++)
    {
        CGRect rect = CGRectMake(0+320*i, 0, 320, viewHeight);
        ImageScrollView * imageScroll = [[ImageScrollView alloc] initWithFrame:rect];
        imageScroll.tag = 10001+i;
        [self.scrollView addSubview:imageScroll];
        
        NSString *uString=[sourceArr objectAtIndex:i];
        if ([uString rangeOfString:@"http://"].location != NSNotFound)//[searchPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
        {
            [imageScroll displayNetImage:[uString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            [imageScroll displayLoadImage:[uString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(320*sum, 390);
    self.scrollView.contentOffset = CGPointMake(pos*320, 0);
}

- (void)backButtonAction{
    //eaadsdsadsa[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self CustomViewDisappearDown_WithBlockING:nil andBlockED:^{ [self removeFromSuperview];
    
    }];

}
#pragma UIScrollViewDelegate methods
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pagenum.text = [NSString stringWithFormat:@"%d/%d",(int)(scrollView.contentOffset.x/scrollView.frame.size.width)+1,sum];
    
    if (currentPage == (int)(scrollView.contentOffset.x/scrollView.frame.size.width)) {
        return;
    }
    
//    ImageScrollView * imageScroll1 = (ImageScrollView *)([scrollView viewWithTag:10001+(int)(scrollView.contentOffset.x/scrollView.frame.size.width)]);
    ImageScrollView * imageScroll1 = (ImageScrollView *)([scrollView viewWithTag:10001 + currentPage]);
    [imageScroll1 formerFrameView];
    
    currentPage = (int)(scrollView.contentOffset.x/scrollView.frame.size.width);
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"111111");
//}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//     NSLog(@"333333");
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//     NSLog(@"555555");
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView 
//{
//     NSLog(@"6666666");
//}

@end
