//
//  RWDescriptionView.m
//  WritePigeonDoctor
//
//  Created by zhongyu on 16/7/27.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWDescriptionView.h"

@interface RWDescriptionView ()

<
    UITableViewDelegate,
    UITableViewDataSource
>

@end

@implementation RWDescriptionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    
    if (self)
    {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

@end

@interface RWDescriptionCell ()

@property (nonatomic,strong)UIImageView *header;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UIButton *attention;
@property (nonatomic,strong)UILabel *professionalTitle;
@property (nonatomic,strong)UILabel *office;
@property (nonatomic,strong)UITextView *descriptionView;
@property (nonatomic,strong)RWPartitionView *partitionView;

@property (nonatomic,copy)void (^attentionResponce)(BOOL isAttention);

@end

@implementation RWDescriptionCell

- (void)setItem:(RWDoctorItem *)item attentionResponce:(void (^)(BOOL isAttention))attentionResponce isAttention:(BOOL)isAttention
{
    _item = item; _attentionResponce = attentionResponce; _isAttention = isAttention;
    
    if (_isAttention)
    {
        [_attention setTitle:@"已关注" forState:UIControlStateNormal];
    }
    else
    {
        [_attention setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    //more linker
}

- (void)initViews
{
    _header = [[UIImageView alloc] init];
    [self addSubview:_header];
    
    _name = [[UILabel alloc] init];
    [self addSubview:_name];
    
    _attention = [[UIButton alloc] init];
    [self addSubview:_attention];
    
    _professionalTitle = [[UILabel alloc] init];
    [self addSubview:_professionalTitle];
    
    _office = [[UILabel alloc] init];
    [self addSubview:_office];
    
    _descriptionView = [[UITextView alloc] init];
    [self addSubview:_descriptionView];
}

- (void)setDefaultSettings
{
    _name.textAlignment = NSTextAlignmentCenter;
    _professionalTitle.textAlignment = NSTextAlignmentCenter;
    _office.textAlignment = NSTextAlignmentCenter;
    
    [_attention addTarget:self
                   action:@selector(addAndRemoveAttention)
         forControlEvents:UIControlEventTouchUpInside];
    
    _descriptionView.editable = NO;
}

- (void)addAndRemoveAttention
{
    if (_isAttention)
    {
        _isAttention = NO;
        _attentionResponce(_isAttention);
    }
    else
    {
        _isAttention = YES;
        _attentionResponce(_isAttention);
    }
}

- (void)autoLayoutViews
{
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(50));
        make.height.equalTo(@(30));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(_header.mas_bottom).offset(20);
    }];
    
    [_attention mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(50));
        make.height.equalTo(@(25));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(_name.mas_bottom).offset(10);
    }];
    
    [_professionalTitle mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@(50));
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(_attention.mas_bottom).offset(10);
    }];
    
    _partitionView = [RWPartitionView partitionWithAutoLayout:^(MASConstraintMaker *make)
                      {
                          
                          make.left.equalTo(self.mas_left).offset(0);
                          make.right.equalTo(self.mas_right).offset(0);
                          make.top.equalTo(_professionalTitle.mas_bottom).offset(30);
                          make.bottom.equalTo(self.mas_bottom).offset(-30);
                          
                      } switchControl:^(BOOL isOpen) {
                          
                          if (isOpen)
                          {
                              
                          }
                          else
                          {
                              
                          }
                      }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initViews];
        [self setDefaultSettings];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self autoLayoutViews];
}

@end

@interface RWPartitionView ()

@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UIButton *openBtn;
@property (nonatomic,strong)UIImageView *arrowhead;

@property (nonatomic,assign)BOOL isOpen;

@property (nonatomic,copy)void(^autoLayout)(MASConstraintMaker *make);
@property (nonatomic,copy)void(^switchControl)(BOOL isOpen);

@end

@implementation RWPartitionView

+ (instancetype)partitionWithAutoLayout:(void(^)(MASConstraintMaker *make))autoLayout switchControl:(void(^)(BOOL isOpen))switchControl
{
    RWPartitionView *view = [[RWPartitionView alloc] init];
    
    view.autoLayout = autoLayout;
    view.switchControl = switchControl;
    
    return view;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _isOpen = NO;
        
        _line = [[UIView alloc] init];
        [self addSubview:_line];
        _line.backgroundColor = [UIColor grayColor];
        
        _openBtn = [[UIButton alloc] init];
        [self addSubview:_openBtn];
        [_openBtn setTitle:@"医生简介" forState:UIControlStateNormal];
        _openBtn.backgroundColor = [UIColor clearColor];
        
        [_openBtn addTarget:self
                     action:@selector(openAndClose)
           forControlEvents:UIControlEventTouchUpInside];
        
        _arrowhead = [[UIImageView alloc] init];
        [self addSubview:_arrowhead];
//        _arrowhead.image = [UIImage imageNamed:@""];
    }
    
    return self;
}

- (void)openAndClose
{
    if (_isOpen)
    {
        _isOpen = NO;
        //        _arrowhead.image = [UIImage imageNamed:@""];
        _switchControl(_isOpen);
    }
    else
    {
        _isOpen = YES;
        //        _arrowhead.image = [UIImage imageNamed:@""];
        _switchControl(_isOpen );
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (_autoLayout)
    {
        [self mas_makeConstraints:_autoLayout];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.width.equalTo(@(2));
            make.centerY.equalTo(self.mas_centerY).offset(0);
        }];
        
        [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.equalTo(@(40));
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.centerX.equalTo(self.mas_centerX).offset(-self.bounds.size.height);
        }];
        
        [_arrowhead mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.equalTo(@(self.bounds.size.height));
            make.height.equalTo(@(self.bounds.size.height));
            make.left.equalTo(_openBtn.mas_right).offset(0);
            make.centerX.equalTo(self.mas_centerY).offset(0);
        }];
    }
}

@end

@implementation RWRegisterOfficeCell

@end

@interface RWAnnouncementCell ()

@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *content;

@end

@implementation RWAnnouncementCell

- (void)setContext:(NSString *)context
{
    _context = context;
    
    _content.text = _context;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        _title = [[UILabel alloc] init];
        _title.text = @"    医生公告";
        _title.backgroundColor = [UIColor grayColor];
        [self addSubview:_title];
        
        _content = [[UILabel alloc] init];
        _content.backgroundColor = [UIColor clearColor];
        [self addSubview:_content];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.equalTo(@(frame.size.height/7*3));
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(_title.mas_bottom).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
    }];
}

@end

@interface RWVisitHomeCell ()

<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *detail;
@property (nonatomic,strong)UILabel *date;
@property (nonatomic,strong)UILabel *status;

@property (nonatomic,strong)UICollectionView *visitHomeList;

@end

@implementation RWVisitHomeCell

- (void)initViews
{
    _title = [[UILabel alloc] init];
    [self addSubview:_title];
    
    _detail = [[UILabel alloc] init];
    [self addSubview:_detail];
    
    _date = [[UILabel alloc] init];
    [self addSubview:_date];
    
    _status = [[UILabel alloc] init];
    [self addSubview:_status];
    
    [self initVisitHomeList];
}

- (void)initVisitHomeList
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollPositionCenteredHorizontally;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _visitHomeList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self addSubview:_visitHomeList];
    
    _visitHomeList.bounces = NO;
    _visitHomeList.showsVerticalScrollIndicator = NO;
    _visitHomeList.showsHorizontalScrollIndicator = NO;
    
    _visitHomeList.delegate = self;
    _visitHomeList.dataSource = self;
    
    [_visitHomeList registerClass:[RWVisitHomeItemCell class]
       forCellWithReuseIdentifier:NSStringFromClass([RWVisitHomeItemCell class])];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 32;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWVisitHomeItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RWVisitHomeItemCell class]) forIndexPath:indexPath];
    
    if (indexPath.row < 4)
    {
        switch (indexPath.row)
        {
            case 0:break;
            case 1:cell.titleLabel.text = @"上午";break;
            case 2:cell.titleLabel.text = @"下午";break;
            case 3:cell.titleLabel.text = @"晚上";break;
            default: break;
        }
    }
    else if (indexPath.row % 4 == 0)
    {
        switch (indexPath.row / 4)
        {
            case 0:break;
            case 1:cell.titleLabel.text = @"周一";break;
            case 2:cell.titleLabel.text = @"周二";break;
            case 3:cell.titleLabel.text = @"周三";break;
            case 4:cell.titleLabel.text = @"周四";break;
            case 5:cell.titleLabel.text = @"周五";break;
            case 6:cell.titleLabel.text = @"周六";break;
            case 7:cell.titleLabel.text = @"周日";break;
            default:break;
        }
    }
    else
    {
        switch (indexPath.row / 4)
        {
            case 1:
            {
                if (indexPath.row % 4 == 1) {}
                else if (indexPath.row % 4 == 2) {}
                else if (indexPath.row % 4 == 3) {}
                
                break;
            }
            case 2:
            {
                if (indexPath.row % 4 == 1) {}
                else if (indexPath.row % 4 == 2) {}
                else if (indexPath.row % 4 == 3) {}
                
                break;
            }
            case 3:
            {
                if (indexPath.row % 4 == 1) {}
                else if (indexPath.row % 4 == 2) {}
                else if (indexPath.row % 4 == 3) {}
                
                break;
            }
            case 4:
            {
                if (indexPath.row % 4 == 1) {}
                else if (indexPath.row % 4 == 2) {}
                else if (indexPath.row % 4 == 3) {}
                
                break;
            }
            case 5:
            {
                if (indexPath.row % 4 == 1) {}
                else if (indexPath.row % 4 == 2) {}
                else if (indexPath.row % 4 == 3) {}
                
                break;
            }
            case 6:
            {
                if (indexPath.row % 4 == 1) {}
                else if (indexPath.row % 4 == 2) {}
                else if (indexPath.row % 4 == 3) {}
                
                break;
            }
            case 7:
            {
                if (indexPath.row % 4 == 1) {}
                else if (indexPath.row % 4 == 2) {}
                else if (indexPath.row % 4 == 3) {}
                
                break;
            }
                
            default: break;
        }
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width/8, collectionView.bounds.size.height/4);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 4 || indexPath.row % 4 == 0)
    {
        return;
    }
    
    // get source
    
    if (indexPath.row % 4 == 1)
    {
        
    }
    else if (indexPath.row % 4 == 2)
    {
        
    }
    else if (indexPath.row % 4 == 3)
    {
        
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self initViews];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self autoLayoutViews];
}

- (void)autoLayoutViews
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat titleHeight = height / 50 * 6;
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.equalTo(@(titleHeight));
    }];
    
    CGFloat margin = 5.0f;
    CGFloat itemLength = (width - margin * 2) / 8;
    
    CGFloat heightList = itemLength * 4;
    
    [_visitHomeList mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(margin);
        make.top.equalTo(_title.mas_bottom).offset(margin);
        make.right.equalTo(self.mas_right).offset(margin);
        make.height.equalTo(@(heightList));
    }];
    
}

@end

@implementation RWVisitHomeItemCell

- (UILabel *)titleLabel
{
    [_imageLabel removeFromSuperview];
    _imageLabel = nil;
    
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
    }
    
    return _titleLabel;
}

- (UIImageView *)imageLabel
{
    [_titleLabel removeFromSuperview];
    _titleLabel = nil;
    
    if (!_imageLabel)
    {
        _imageLabel = [[UIImageView alloc] init];
        [self addSubview:_imageLabel];
        
        [_imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
    }
    
    return _imageLabel;
}

@end