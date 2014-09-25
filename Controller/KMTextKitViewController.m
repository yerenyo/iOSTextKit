//
//  KMTextKitViewController.m
//  TextKitDemo
//
//  Created by Jinyou Gu on 13-6-22.
//  Copyright (c) 2013年 kdanmobile. All rights reserved.
//

#import "KMTextKitViewController.h"
#import "UIIOS7TextView.h"
#import "PCMTextObject.h"
#import "TextkitSettingView.h"
#import "UIImportView.h"
@interface KMTextKitViewController ()<NSTextStorageDelegate,UIPopoverControllerDelegate,
 TextkitSettingViewDelegate, UITableViewDataSource, UITableViewDelegate,
UIImportViewDelegate>{
    UIIOS7TextView *_textView;
    TextkitSettingView *_settingView;
    UIImportView *_importView;
}
@property(nonatomic, retain) UIPopoverController *myPopoverController;
@end

@implementation KMTextKitViewController
@synthesize myPopoverController=_myPopoverController;
- (void)dealloc{
    [_myPopoverController release];
    [_textView release];
    [_importView release];
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //测试
//    NSLog(@"%@",[NSValue valueWithCGRect:self.view.frame]);//0,0,320,568
//    CGRect rect = [UIApplication sharedApplication].statusBarFrame;
//    NSLog(@"%@",[NSValue valueWithCGRect:rect]);//0,0,320,20
//    CGRect navRect = self.navigationController.navigationBar.frame;
//    NSLog(@"%@",[NSValue valueWithCGRect:navRect]);//0,20,320,44asdf
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Setting"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(onSetting:)] autorelease];
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [imageBtn setTitle:@"AddImage" forState:UIControlStateNormal];
    imageBtn.frame = CGRectMake(0, 0, 80, 44);
    [imageBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(addObject:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [starBtn setTitle:@"AddStar" forState:UIControlStateNormal];
    [starBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [starBtn setFrame:CGRectMake(80, 0, 60, 44)];
    [starBtn addTarget:self action:@selector(addStar:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *roundBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [roundBtn setTitle:@"AddRound" forState:UIControlStateNormal];
    [roundBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [roundBtn setFrame:CGRectMake(140, 0, 80, 44)];
    [roundBtn addTarget:self action:@selector(addRound:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *arcBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [arcBtn setTitle:@"AddArc" forState:UIControlStateNormal];
    [arcBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [arcBtn setFrame:CGRectMake(220, 0, 60, 44)];
    [arcBtn addTarget:self  action:@selector(addArc:) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 44)] autorelease];
    [view addSubview:imageBtn];
    [view addSubview:starBtn];
    [view addSubview:roundBtn];
    [view addSubview:arcBtn];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
    CGRect textRect = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
    PCMTextObject *textObj = [[[PCMTextObject alloc] initWithDataText] autorelease];
//    PCMTextObject *textObj = [[[PCMTextObject alloc] initByRandom] autorelease];
    _textView = [[UIIOS7TextView alloc] initWithFrame:textRect TextObject:textObj];
    [self.view addSubview:_textView];
}
- (void)addType:(NSUInteger)type{
    if (_importView) {
        [_importView removeFromSuperview];
        [_importView release];
    }
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(onCancel:)] autorelease];
    
    _importView = [[UIImportView alloc] initWithType:type];
    _importView.delegate = self;
    _importView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
    [self.view addSubview:_importView];
}
- (void)onCancel:(id)sender{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Setting"
                                                                               style:UIBarButtonItemStyleDone
                                                                              target:self
                                                                              action:@selector(onSetting:)] autorelease];
    [_importView removeFromSuperview];
    [_importView release];
    _importView = nil;
}
- (void)addArc:(id)sender{
    [self addType:2];
}
- (void)addRound:(id)sender{
    [self addType:1];
}
- (void)addStar:(id)sender{
    [self addType:0];
}
- (void)addObject:(id)sender{
    UITableView *tableview = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 133, 125*5)] autorelease];
    tableview.delegate = self;
    tableview.dataSource = self;
    UIViewController *vc = [[[UIViewController alloc] init] autorelease];
    vc.view = tableview;
    self.myPopoverController = [[[UIPopoverController alloc] initWithContentViewController:vc] autorelease];
    self.myPopoverController.popoverContentSize = CGSizeMake(113, 125*5);
    self.myPopoverController.delegate = self;
    [self.myPopoverController presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem
                                     permittedArrowDirections:UIPopoverArrowDirectionUp
                                                     animated:YES];
}
- (void)onSetting:(id)sender{
    if (_settingView) {
        return;
    }
    UIViewController *vc = [[[UIViewController alloc] init] autorelease];
    self.myPopoverController = [[[UIPopoverController alloc] initWithContentViewController:vc] autorelease];
    _settingView = [[TextkitSettingView alloc] initWithXib];
    vc.view = _settingView;
    _settingView.delegate = self;
    [_settingView attributeString:_textView.textView.textStorage Select:_textView.textView.selectedRange Attribute:_textView.attributes];
    _settingView.frame = CGRectMake(self.view.bounds.size.width-_settingView.bounds.size.width, 64, _settingView.bounds.size.width, _settingView.bounds.size.height);
    self.myPopoverController.popoverContentSize = CGSizeMake(334, 460);
    self.myPopoverController.delegate = self;
    [self.myPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)refresh:(TextkitSettingView *)view Attribute:(NSDictionary *)attribute{
    NSLog(@"%@",attribute);
    _textView.attributes = attribute;
}
- (void)refresh:(TextkitSettingView *)view AttributeString:(NSAttributedString *)attibutedStr{
    [_textView.textView.textStorage setAttributedString:attibutedStr];
    NSRange range = _textView.textView.selectedRange;
    _textView.textView.selectedRange = NSMakeRange(0, 0);
    _textView.textView.selectedRange = range;
}
- (void)addTextAttechment:(TextkitSettingView *)view AttributeString:(NSAttributedString *)attibutedStr{
    [_textView.textView.textStorage setAttributedString:attibutedStr];
    NSRange range = _textView.textView.selectedRange;
    _textView.textView.selectedRange = NSMakeRange(0, 0);
    _textView.textView.selectedRange = NSMakeRange(range.location, 1);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)import:(UIImportView *)view Image:(UIImage *)image BezierPath:(UIBezierPath *)bezierPath{
    [_textView addImage:image WithBezierPath:bezierPath];
    [self onCancel:nil];
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    self.myPopoverController = nil;
    [_settingView release];
    _settingView = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Kdan Mobile Logo%d.png", indexPath.row+1]]];
    [imageView sizeToFit];
    cell.backgroundView = imageView;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Kdan Mobile Logo%d.png", indexPath.row+1]];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [_textView addImage:image WithBezierPath:bezierPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
