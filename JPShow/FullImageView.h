//
//  FullImageView.h
//  智慧旅游
//
//  Created by madao on 13-7-29.
//  Copyright (c) 2013年 madao. All rights reserved.
//

#import "CustomView.h"
@class ArticleEntity;
@interface FullImageView : CustomView<UIScrollViewDelegate>
{


    NSArray*sourceArr;
    UIImageView*imageView;
    
    
    NSUInteger sum;
    NSInteger currentPage;
    NSInteger currentPos;
    UIImageView * altImageView;
    UILabel *pagenum;

}

@property (nonatomic,strong) UILabel *title;   /*标题*/
@property (nonatomic,strong) UILabel *author;  /*作者*/
@property (nonatomic,strong) UITextView *info; /*详细信息*/
@property (nonatomic,strong) ArticleEntity *entity;

- (id)initWithFrame:(CGRect)frame andPictures:(NSArray *)array;;
@end
