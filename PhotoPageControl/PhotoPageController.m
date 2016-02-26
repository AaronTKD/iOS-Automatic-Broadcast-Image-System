//
//  PhotoPageController.m
//  PhotoPageControl
//
//  Created by Lucky on 16/2/25.
//  Copyright © 2016年 AaronTKD_GEELY. All rights reserved.
//

#import "PhotoPageController.h"

#define kScrollViewWidth [UIScreen mainScreen].bounds.size.width
#define kScrollViewHeight [UIScreen mainScreen].bounds.size.width*0.68
#define ShowPicCount 4

typedef UIImageView* (^ImageViewBlock) (NSString *picName);
typedef CATransition * (^TransAnimateBlock)(NSString *type);

@interface PhotoPageController()<UIScrollViewDelegate>
{
    NSTimer *timer;
}
@property (nonatomic,strong) ImageViewBlock imageBlock;
@property (nonatomic,strong) TransAnimateBlock animateBlock;
@property (nonatomic,copy) NSArray *picArray;
@property (nonatomic,strong) UIScrollView *photoScrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,assign) NSInteger currentPage;

- (void)pageAction:(UIPageControl *)pageControl;

@end

@implementation PhotoPageController

- (void)viewDidLoad
{
    [self creatBlocks];
    
    _picArray = [NSArray arrayWithObjects:_imageBlock(@"4"),_imageBlock(@"1"),_imageBlock(@"2"),_imageBlock(@"3"),_imageBlock(@"4"), _imageBlock(@"1"),nil];
    
    [self creatScrollView];
    [self creatPageControll];
    
    for (int i = 0; i < _picArray.count; i ++) {
        UIImageView *currentImageView = _picArray[i];
        currentImageView.frame = CGRectMake(kScrollViewWidth*(i-1), 0, kScrollViewWidth, kScrollViewHeight);
        [_photoScrollView addSubview:currentImageView];
    }
    
    [self creatNSTimer];
}
#pragma mark - CREAT BASIC
- (void)creatBlocks
{
    _imageBlock = ^(NSString *picName){
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:picName]];
        return imageView;
    };
    
    _animateBlock = ^(NSString *type){
        CATransition *trans = [CATransition animation];
        trans.type = type;
        trans.duration = 1;
        return trans;
    };

}
- (void)creatScrollView
{
    _photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 66, kScrollViewWidth, kScrollViewHeight)];
    [self.view addSubview:_photoScrollView];
    _photoScrollView.backgroundColor = [UIColor grayColor];
    _photoScrollView.contentSize = CGSizeMake(kScrollViewWidth*ShowPicCount, kScrollViewHeight);
    _photoScrollView.delegate = self;
    _photoScrollView.pagingEnabled = YES;
}
- (void)creatPageControll
{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kScrollViewWidth-60, 66+kScrollViewHeight-10, 60, 10)];
    [self.view addSubview:_pageControl];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    _pageControl.backgroundColor = [UIColor grayColor];
    
    [_pageControl addTarget:self action:@selector(pageAction:) forControlEvents:UIControlEventValueChanged];
}
- (void)creatNSTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showNextPhoto) userInfo:nil repeats:YES];
}

#pragma mark - CONTROL
//pageControl控制ScrollView
- (void)pageAction:(UIPageControl *)pageControl
{

    [_photoScrollView setContentOffset:CGPointMake(pageControl.currentPage * kScrollViewWidth, 0) animated:YES];
}

//scrollView控制pageView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _currentPage = _photoScrollView.contentOffset.x / kScrollViewWidth;
    if (_currentPage == 3 && _pageControl
        .currentPage == 3) {
        _currentPage = 0;
        //从右往左
        
        [_photoScrollView.layer addAnimation:_animateBlock(@"suckEffect") forKey:nil];
        [_photoScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        
    }
    else if (_currentPage == 0 && _pageControl.currentPage == 0) {
        _currentPage = 3;
        [_photoScrollView.layer addAnimation:_animateBlock(@"rippleEffect") forKey:nil];
        [_photoScrollView setContentOffset:CGPointMake(kScrollViewWidth*_currentPage, 0) animated:YES];
    }
    _pageControl.currentPage = _currentPage;
    
    
//    [self performSelector:@selector(creatNSTimer) withObject:nil afterDelay:1.5];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [timer invalidate];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self creatNSTimer];
}

- (void)showNextPhoto
{
    NSInteger page = _pageControl.currentPage;
    page += 1;
    if (page == 4 && _pageControl.currentPage==3) {
        page = 0;
    }
    _pageControl.currentPage = page;
    [_photoScrollView.layer addAnimation:_animateBlock(@"rippleEffect") forKey:nil];
    [_photoScrollView setContentOffset:CGPointMake(_pageControl.currentPage * kScrollViewWidth, 0) animated:YES];
}

@end
