//
//  MLSActivityViewController.m
//  MaxSocialShare
//
//  Created by Sun Jin on 3/16/16.
//  Copyright © 2016 maxleap. All rights reserved.
//

#import "MLSActivityViewController.h"
#import "MLSHorizontalPageCollectionViewLayout.h"
#import "MLSActivity+Private.h"
#import "MLShareItem.h"

#define CONTAINER_HEIGHT 290

@interface MLSActivityCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation MLSActivityCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, self.frame.size.height -15, self.frame.size.width, 15);
    CGFloat h = self.textLabel.frame.origin.y - 12;
    CGFloat w = self.frame.size.width -12;
    CGFloat size = MIN(h, w);
    self.imageView.frame = CGRectMake((self.frame.size.width - size) /2, (self.textLabel.frame.origin.y - size)/2, size, size);
    
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.imageView.highlighted = highlighted;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.imageView.image = nil;
    self.textLabel.text = nil;
}

- (void)configWithActivity:(MLSActivity *)activity {
    self.imageView.image = activity.image;
    self.textLabel.text = activity.title;
}

@end



@interface MLSActivityViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource>

// sheet
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *cancelButton;

// mask
@property (nonatomic, strong) UIView *mask;

// data
@property (nonatomic, strong) MLShareItem *item;
@property (nonatomic, strong) MLSActivity *activity;
@property (nonatomic, strong) NSArray *activities;

@end

@implementation MLSActivityViewController

- (instancetype)initWithItem:(MLShareItem *)item {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.item = item;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

#pragma mark -
#pragma mark view life-cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activities = [MLSActivity activitiesCanPerformWithActivityItem:self.item excludedActivityTypes:self.excludedActivityTypes];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self configTheSheet];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ( ! self.mask) {
        self.mask = [[UIView alloc] initWithFrame:self.presentingViewController.view.bounds];
        self.mask.backgroundColor = [UIColor blackColor];
        self.mask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.mask.alpha = 0;
        [self.presentingViewController.view addSubview:self.mask];
        [UIView animateWithDuration:0.25 animations:^{
            self.mask.alpha = 0.3;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        self.mask.alpha = 0;
    } completion:^(BOOL finished) {
        [self.mask removeFromSuperview];
        self.mask = nil;
    }];
}

- (void)configTheSheet {
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cancelButton.frame = self.view.bounds;
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-CONTAINER_HEIGHT, self.view.frame.size.width, CONTAINER_HEIGHT)];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    
    // the dynamic blur effect
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.contentView.bounds];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:toolbar];
    
    CGRect cvFrame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height - 60);
    self.collectionView = [[UICollectionView alloc] initWithFrame:cvFrame collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    MLSHorizontalPageCollectionViewLayout *layout = [[MLSHorizontalPageCollectionViewLayout alloc] init];
    layout.itemSize = CGSizeMake(70, 85);
    layout.sectionInset = UIEdgeInsetsMake(20, 30, 20, 30);
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    
    [self.collectionView registerClass:[MLSActivityCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(cvFrame.origin.x, cvFrame.size.height - 15, cvFrame.size.width, 30)];
    self.pageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.686 green:0.827 blue:0.973 alpha:1.00];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.075 green:0.424 blue:0.984 alpha:1.00];
    self.pageControl.hidesForSinglePage = YES;
    [self.contentView addSubview:self.pageControl];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.frame = CGRectMake(0, CGRectGetMaxY(self.pageControl.frame), cvFrame.size.width, self.contentView.frame.size.height - CGRectGetMaxY(self.pageControl.frame));
    self.cancelButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelButton];
    
    CGRect lineFrame = CGRectMake(0, CGRectGetMaxY(self.pageControl.frame) -0.5,
                                  self.contentView.frame.size.width, 0.5);
    UIView *line = [[UIView alloc] initWithFrame:lineFrame];
    line.backgroundColor = [UIColor lightGrayColor];
    line.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.contentView addSubview:line];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.pageControl.numberOfPages = ceil(self.collectionView.contentSize.width / self.collectionView.frame.size.width);
}

- (CGSize)preferredContentSize {
    return CGSizeMake(320, CONTAINER_HEIGHT);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Actions

- (void)cancelAction:(id)sender {
    if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint location = [(UITapGestureRecognizer *)sender locationInView:self.view];
        if (CGRectContainsPoint(self.contentView.frame, location)) {
            return;
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        // call completion callbacks
        NSError *error = [NSError errorWithDomain:@"SocialShareErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"User cancelled"}];
        if (self.completionHandler) {
            self.completionHandler(MLSActivityTypeNone, NO, error);
        }
    }];
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.activities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MLSActivityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell configWithActivity:self.activities[indexPath.item]];
    return cell;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = lround(scrollView.contentOffset.x / scrollView.frame.size.width);
}

#pragma mark -
#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.activity = self.activities[indexPath.item];
    [self.activity prepareWithActivityItem:self.item];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    // create a retain cycle to hold activity view controller
    [self.activity setCompletionHandler:^(NSError * _Nonnull error) {
        if (self.completionHandler) {
            self.completionHandler([self.activity.class type], !error, error);
        }
        // break the retain-cycle to release activity view controller
        self.activity = nil;
    }];
#pragma clang diagnostic pop
    [self dismissViewControllerAnimated:YES completion:^{
        [self.activity perform];
    }];
}

@end


