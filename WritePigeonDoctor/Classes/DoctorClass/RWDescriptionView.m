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

- (void)setItem:(RWDoctorItem *)item
{
    _item = item;
    
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    
    if (self)
    {
        _isOpenDescription = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        
        self.allowsSelection = NO;
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[RWDescriptionCell class] forCellReuseIdentifier:NSStringFromClass([RWDescriptionCell class])];
        
        [self registerClass:[RWAnnouncementCell class] forCellReuseIdentifier:NSStringFromClass([RWAnnouncementCell class])];
        
        [self registerClass:[RWVisitHomeCell class] forCellReuseIdentifier:NSStringFromClass([RWVisitHomeCell class])];
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            RWDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWDescriptionCell class]) forIndexPath:indexPath];
            
            [cell setItem:_item attentionResponce:^(BOOL isAttention) {
                
                _isAttention = isAttention;
                [_eventSource isAttentionAtDescriptionView:self];
                
            } isAttention:_item.relation isOpen:^(BOOL isOpen) {
                
                _isOpenDescription = isOpen;
                [_eventSource isShowDoctorDescription:self];
                self.contentOffset = CGPointMake(0, 0);
                [self reloadData];
            }];
            
            return cell;
        }
        case 1:
        {
            RWAnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWAnnouncementCell  class]) forIndexPath:indexPath];
            
            cell.context = _item.announcement;
            
            return cell;
        }
        default:
        {
            RWVisitHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RWVisitHomeCell class]) forIndexPath:indexPath];
            
            cell.item = _item.homeVisitList;
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (_isOpenDescription)
        {
            tableView.scrollEnabled = NO;
            return __DESCRIPTION_HEIGHT_OPEN__;
        }

        tableView.scrollEnabled = YES;
        return __DESCRIPTION_HEIGHT_CLOSE__;
    }
    else if (indexPath.section == 1) return __ANNOUNCEMENT_HEIGHT__;
    else return __VISIT_HEIGHT__;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2)
    {
        return 1;
    }
    
    return 5;
}

@end

@interface RWDescriptionCell ()

@property (nonatomic,strong)UIImageView *header;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *professionalTitle;
@property (nonatomic,strong)UILabel *office;
@property (nonatomic,strong)UITextView *descriptionView;
@property (nonatomic,strong)RWPartitionView *partitionView;

@property (nonatomic,copy)void (^attentionResponce)(BOOL isAttention);
@property (nonatomic,copy)void (^openControl)(BOOL isOpen);

@end

@implementation RWDescriptionCell

- (void)setItem:(RWDoctorItem *)item attentionResponce:(void (^)(BOOL isAttention))attentionResponce isAttention:(BOOL)isAttention isOpen:(void (^)(BOOL isOpen))isOpen
{
    _item = item; _attentionResponce = attentionResponce; _isAttention = isAttention;
    _openControl = isOpen;
    
    if (_isAttention)
    {
        [_attention setTitle:@"已关注" forState:UIControlStateNormal];
    }
    else
    {
        [_attention setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    [_header setImageWithURL:[NSURL URLWithString:_item.header] placeholder:[UIImage imageNamed:@"user_image"]];
    _name.text = _item.name;
    _professionalTitle.text = _item.professionalTitle;
    _office.text = _item.office;
    _descriptionView.text = _item.doctorDescription;
}

- (void)setCard:(RWCard *)card attentionResponce:(void (^)(BOOL))attentionResponce isAttention:(BOOL)isAttention isOpen:(void (^)(BOOL))isOpen
{
    _card = card; _attentionResponce = attentionResponce; _isAttention = isAttention;
    _openControl = isOpen;
    
    if (_isAttention)
    {
        [_attention setTitle:@"已关注" forState:UIControlStateNormal];
    }
    else
    {
        [_attention setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    _header.image = _card.header?[UIImage imageWithData:_card.header]:[UIImage imageNamed:@"user_image"];
    _name.text = _card.name;
    _professionalTitle.text = _card.professionTitle;
    _office.text = _card.office;
    _descriptionView.text = _card.doctorDescription;
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
    
    _partitionView = [RWPartitionView partitionWithAutoLayout:nil
                                                switchControl:^(BOOL isOpen) {
                          
                              _isOpen = isOpen;
                              _openControl(_isOpen);
                      }];
    
    [self addSubview:_partitionView];
}

- (void)setDefaultSettings
{
    _isOpen = NO;
    
    _header.layer.cornerRadius = 30;
    _header.clipsToBounds = YES;
    
    _name.textAlignment = NSTextAlignmentCenter;
    _professionalTitle.textAlignment = NSTextAlignmentCenter;
    _professionalTitle.textColor = [UIColor grayColor];
    _professionalTitle.font = __RWGET_SYSFONT(14.f);
    _office.textAlignment = NSTextAlignmentCenter;
    _office.textColor = [UIColor grayColor];
    _office.font = __RWGET_SYSFONT(14.f);
    
    [_attention setTitleColor:__WPD_MAIN_COLOR__ forState:UIControlStateNormal];
    _attention.layer.cornerRadius = 3.f;
    _attention.layer.borderWidth = 1.f;
    _attention.layer.borderColor = [__WPD_MAIN_COLOR__ CGColor];
    _attention.titleLabel.font = __RWGET_SYSFONT(13.f);
    
    [_attention addTarget:self
                   action:@selector(addAndRemoveAttention)
         forControlEvents:UIControlEventTouchUpInside];
    
    _descriptionView.editable = NO;
}

- (void)addAndRemoveAttention
{
    _attentionResponce(_isAttention);
}

- (void)autoLayoutViews
{
    [_header mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    
    [_name mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(80));
        make.height.equalTo(@(20));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(_header.mas_bottom).offset(20);
    }];
    
    [_attention mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(50));
        make.height.equalTo(@(20));
        make.centerX.equalTo(self.mas_centerX).offset(0);
        make.top.equalTo(_name.mas_bottom).offset(10);
    }];
    
    [_professionalTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@(30));
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(_attention.mas_bottom).offset(10);
    }];
    
    [_office mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(_professionalTitle.mas_bottom).offset(0);
        make.height.equalTo(@(30));
    }];
    
    if (_isOpen)
    {
        _descriptionView.hidden = NO;
        [_descriptionView mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(_office.mas_bottom).offset(5);
            make.bottom.equalTo(_partitionView .mas_top).offset(-5);
            make.left.equalTo(self.mas_left).offset(5);
            make.right.equalTo(self.mas_right).offset(-5);
        }];
    }
    else
    {
        _descriptionView.hidden = YES;
    }
    
    __weak RWDescriptionCell *weakSelf = self;
    
    [_partitionView setAutoLayout:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.mas_left).offset(0);
        make.right.equalTo(weakSelf.mas_right).offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.height.equalTo(@(30));
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
        _line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.f];
        
        _openBtn = [[UIButton alloc] init];
        [self addSubview:_openBtn];
        [_openBtn setTitle:@"医生简介" forState:UIControlStateNormal];
        _openBtn.backgroundColor = [UIColor clearColor];
        [_openBtn setTitleColor:__WPD_MAIN_COLOR__ forState:UIControlStateNormal];
        _openBtn.titleLabel.font = __RWGET_SYSFONT(14.f);
        _openBtn.backgroundColor = [UIColor whiteColor];
        
        [_openBtn addTarget:self
                     action:@selector(openAndClose)
           forControlEvents:UIControlEventTouchUpInside];
        
        _arrowhead = [[UIImageView alloc] init];
        [self addSubview:_arrowhead];
        _arrowhead.image = [UIImage imageNamed:@"closedescription"];
        _arrowhead.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAndClose)];
        tap.numberOfTapsRequired = 1;
        
        [_arrowhead addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)openAndClose
{
    if (_isOpen)
    {
        _isOpen = NO;
        _arrowhead.image = [UIImage imageNamed:@"closedescription"];
        _switchControl(_isOpen);
    }
    else
    {
        _isOpen = YES;
        _arrowhead.image = [UIImage imageNamed:@"opendescription"];
        _switchControl(_isOpen );
    }
}

- (void)setAutoLayout:(void (^)(MASConstraintMaker *))autoLayout
{
    _autoLayout = autoLayout;
    
    if (!_autoLayout) { return; }
    
    if (self.superview.window)
    {
        [self mas_remakeConstraints:_autoLayout];
        
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.equalTo(@(3));
            make.centerY.equalTo(self.mas_centerY).offset(0);
        }];
        
        [_openBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@(70));
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.centerX.equalTo(self.mas_centerX).offset(-15);
        }];
        
        [_arrowhead mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
            make.left.equalTo(_openBtn.mas_right).offset(0);
            make.centerY.equalTo(self.mas_centerY).offset(0);
        }];
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (_autoLayout)
    {
        [self mas_remakeConstraints:_autoLayout];
        
        [_line mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.equalTo(@(3));
            make.centerY.equalTo(self.mas_centerY).offset(0);
        }];
        
        [_openBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.width.equalTo(@(70));
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.centerX.equalTo(self.mas_centerX).offset(-15);
        }];
        
        [_arrowhead mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
            make.left.equalTo(_openBtn.mas_right).offset(0);
            make.centerY.equalTo(self.mas_centerY).offset(0);
        }];
    }
}

@end

@interface RWRegisterOfficeView ()

@end

@implementation RWRegisterOfficeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.layer.borderColor = [[UIColor colorWithWhite:0.9f alpha:1.f] CGColor];
        self.layer.borderWidth = 0.5f;
        self.backgroundColor = [UIColor whiteColor];
        
        _startBtn = [[UIButton alloc] init];
        [self addSubview:_startBtn];
        
        [_startBtn setTitle:@"开始咨询" forState:UIControlStateNormal];
        [_startBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _startBtn.backgroundColor = __WPD_MAIN_COLOR__;
        _startBtn.titleLabel.font = __RWGET_SYSFONT(14.f);
        
        [_startBtn addTarget:self action:@selector(startConsult) forControlEvents:UIControlEventTouchUpInside];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor whiteColor];
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.font = __RWGET_SYSFONT(13.f);
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_contentLabel];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeConsultWay)];
        tapGesture.numberOfTapsRequired = 1;
        
        [_contentLabel addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)changeConsultWay
{
    if (found_response(_delegate,@"consultWayAtRegisterOffice:"))
    {
        [_delegate consultWayAtRegisterOffice:self];
    }
}

- (void)startConsult
{
    if (found_response(_delegate,@"startConsultAtRegisterOffice:"))
    {
        [_delegate startConsultAtRegisterOffice:self];
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    [_startBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.width.equalTo(@(100));
    }];
    
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(0);
        make.right.equalTo(_startBtn.mas_left).offset(-20);
    }];
}

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
        _title.font = __RWGET_SYSFONT(15.f);
        _title.backgroundColor = __WPD_MAIN_COLOR__;
        _title.textColor = [UIColor whiteColor];
        [self addSubview:_title];
        
        _content = [[UILabel alloc] init];
        _content.backgroundColor = [UIColor clearColor];
        _content.textColor = [UIColor grayColor];
        _content.font = __RWGET_SYSFONT(14.f);
        _content.adjustsFontSizeToFitWidth = YES;
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
        make.height.equalTo(@(frame.size.height/7*2.5));
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

- (void)setVisitHomeSource:(NSArray *)visitHomeSource
{
    _visitHomeSource = visitHomeSource;
    
    [_visitHomeList reloadData];
}

- (void)setDefaultSettings
{
    _title.text = @"    出诊信息";
    _title.font = __RWGET_SYSFONT(15.f);
    _title.backgroundColor = __WPD_MAIN_COLOR__;
    _title.textColor = [UIColor whiteColor];
    
    _detail.text = @"点击查看详细内容";
    _detail.font = __RWGET_SYSFONT(14.f);
    _detail.textColor = [UIColor grayColor];
    
    _date.font = __RWGET_SYSFONT(14.f);
    
    _status.font = __RWGET_SYSFONT(14.f);
}

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
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _visitHomeList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                        collectionViewLayout:flowLayout];
    [self addSubview:_visitHomeList];
    
    _visitHomeList.backgroundColor = [UIColor whiteColor];
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
    
    cell.layer.borderWidth = 0.3f;
    cell.layer.borderColor = [[UIColor blackColor] CGColor];
    
    if (indexPath.row < 4)
    {
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
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
        cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
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
        UIImage *hasDay = [UIImage imageNamed:@"visitHomeYes"];
        
        switch (indexPath.row / 4)
        {
            case 1:
            {
                if (indexPath.row % 4 == 1)
                {
                    cell.imageLabel.image = _item.Monday.morning?hasDay:nil;
                }
                else if (indexPath.row % 4 == 2)
                {
                    cell.imageLabel.image = _item.Monday.afternoon?hasDay:nil;
                }
                else if (indexPath.row % 4 == 3)
                {
                    cell.imageLabel.image = _item.Monday.night?hasDay:nil;
                }
                
                break;
            }
            case 2:
            {
                if (indexPath.row % 4 == 1)
                {
                    cell.imageLabel.image = _item.Tuesday.morning?hasDay:nil;
                }
                else if (indexPath.row % 4 == 2)
                {
                    cell.imageLabel.image = _item.Tuesday.afternoon?hasDay:nil;
                }
                else if (indexPath.row % 4 == 3)
                {
                    cell.imageLabel.image = _item.Tuesday.night?hasDay:nil;
                }
                
                break;
            }
            case 3:
            {
                if (indexPath.row % 4 == 1)
                {
                    cell.imageLabel.image = _item.Wednesday.morning?hasDay:nil;
                }
                else if (indexPath.row % 4 == 2)
                {
                    cell.imageLabel.image = _item.Wednesday.afternoon?hasDay:nil;
                }
                else if (indexPath.row % 4 == 3)
                {
                    cell.imageLabel.image = _item.Wednesday.night?hasDay:nil;
                }
                
                break;
            }
            case 4:
            {
                if (indexPath.row % 4 == 1)
                {
                    cell.imageLabel.image = _item.Thursday.morning?hasDay:nil;
                }
                else if (indexPath.row % 4 == 2)
                {
                    cell.imageLabel.image = _item.Thursday.afternoon?hasDay:nil;
                }
                else if (indexPath.row % 4 == 3)
                {
                    cell.imageLabel.image = _item.Thursday.night?hasDay:nil;
                }
                
                break;
            }
            case 5:
            {
                if (indexPath.row % 4 == 1)
                {
                    cell.imageLabel.image = _item.Friday.morning?hasDay:nil;
                }
                else if (indexPath.row % 4 == 2)
                {
                    cell.imageLabel.image = _item.Friday.afternoon?hasDay:nil;
                }
                else if (indexPath.row % 4 == 3)
                {
                    cell.imageLabel.image = _item.Friday.night?hasDay:nil;
                }
                
                break;
            }
            case 6:
            {
                if (indexPath.row % 4 == 1)
                {
                    cell.imageLabel.image = _item.Saturday.morning?hasDay:nil;
                }
                else if (indexPath.row % 4 == 2)
                {
                    cell.imageLabel.image = _item.Saturday.afternoon?hasDay:nil;
                }
                else if (indexPath.row % 4 == 3)
                {
                    cell.imageLabel.image = _item.Saturday.night?hasDay:nil;
                }
                
                break;
            }
            case 7:
            {
                if (indexPath.row % 4 == 1)
                {
                    cell.imageLabel.image = _item.Sunday.morning?hasDay:nil;
                }
                else if (indexPath.row % 4 == 2)
                {
                    cell.imageLabel.image = _item.Sunday.afternoon?hasDay:nil;
                }
                else if (indexPath.row % 4 == 3)
                {
                    cell.imageLabel.image = _item.Sunday.night?hasDay:nil;
                }
                
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
    
    switch (indexPath.row / 4)
    {
        case 1:
        {
            if (indexPath.row % 4 == 1)
            {
                _date.text = [NSString stringWithFormat:@"星期一 上午"];
                _status.text = _item.Monday.morning?_item.Monday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 2)
            {
                _date.text = [NSString stringWithFormat:@"星期一 下午"];
                _status.text = _item.Monday.morning?_item.Monday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 3)
            {
                _date.text = [NSString stringWithFormat:@"星期一 晚上"];
                _status.text = _item.Monday.morning?_item.Monday.morning:@"停诊";
            }
            
            break;
        }
        case 2:
        {
            if (indexPath.row % 4 == 1)
            {
                _date.text = [NSString stringWithFormat:@"星期二 上午"];
                _status.text = _item.Tuesday.morning?_item.Tuesday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 2)
            {
                _date.text = [NSString stringWithFormat:@"星期二 下午"];
                _status.text = _item.Tuesday.morning?_item.Tuesday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 3)
            {
                _date.text = [NSString stringWithFormat:@"星期二 晚上"];
                _status.text = _item.Tuesday.morning?_item.Tuesday.morning:@"停诊";
            }
            
            break;
        }
        case 3:
        {
            if (indexPath.row % 4 == 1)
            {
                _date.text = [NSString stringWithFormat:@"星期三 上午"];
                _status.text = _item.Wednesday.morning?_item.Wednesday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 2)
            {
                _date.text = [NSString stringWithFormat:@"星期三 下午"];
                _status.text = _item.Wednesday.morning?_item.Wednesday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 3)
            {
                _date.text = [NSString stringWithFormat:@"星期三 晚上"];
                _status.text = _item.Wednesday.morning?_item.Wednesday.morning:@"停诊";
            }
            
            break;
        }
        case 4:
        {
            if (indexPath.row % 4 == 1)
            {
                _date.text = [NSString stringWithFormat:@"星期四 上午"];
                _status.text = _item.Thursday.morning?_item.Thursday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 2)
            {
                _date.text = [NSString stringWithFormat:@"星期四 下午"];
                _status.text = _item.Thursday.morning?_item.Thursday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 3)
            {
                _date.text = [NSString stringWithFormat:@"星期四 晚上"];
                _status.text = _item.Thursday.morning?_item.Thursday.morning:@"停诊";
            }
            
            break;
        }
        case 5:
        {
            if (indexPath.row % 4 == 1)
            {
                _date.text = [NSString stringWithFormat:@"星期五 上午"];
                _status.text = _item.Friday.morning?_item.Friday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 2)
            {
                _date.text = [NSString stringWithFormat:@"星期五 下午"];
                _status.text = _item.Friday.morning?_item.Friday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 3)
            {
                _date.text = [NSString stringWithFormat:@"星期五 晚上"];
                _status.text = _item.Friday.morning?_item.Friday.morning:@"停诊";
            }
            
            break;
        }
        case 6:
        {
            if (indexPath.row % 4 == 1)
            {
                _date.text = [NSString stringWithFormat:@"星期六 上午"];
                _status.text = _item.Saturday.morning?_item.Saturday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 2)
            {
                _date.text = [NSString stringWithFormat:@"星期六 下午"];
                _status.text = _item.Saturday.morning?_item.Saturday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 3)
            {
                _date.text = [NSString stringWithFormat:@"星期六 晚上"];
                _status.text = _item.Saturday.morning?_item.Saturday.morning:@"停诊";
            }
            
            break;
        }
        case 7:
        {
            if (indexPath.row % 4 == 1)
            {
                _date.text = [NSString stringWithFormat:@"星期日 上午"];
                _status.text = _item.Sunday.morning?_item.Sunday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 2)
            {
                _date.text = [NSString stringWithFormat:@"星期日 下午"];
                _status.text = _item.Sunday.morning?_item.Sunday.morning:@"停诊";
            }
            else if (indexPath.row % 4 == 3)
            {
                _date.text = [NSString stringWithFormat:@"星期日 晚上"];
                _status.text = _item.Sunday.morning?_item.Sunday.morning:@"停诊";
            }
            
            break;
        }

        default: break;
    }
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

- (void)autoLayoutViews
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat titleHeight = height / 50 * 4.6;
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.height.equalTo(@(titleHeight));
    }];
    
    CGFloat margin = 5.0f;
    CGFloat itemLength = (width - margin * 2) / 8;
    
    CGFloat heightList = itemLength * 4;
    
    [_visitHomeList mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(margin);
        make.top.equalTo(_title.mas_bottom).offset(margin);
        make.right.equalTo(self.mas_right).offset(-margin);
        make.height.equalTo(@(heightList));
    }];
    
    CGFloat oh = height - titleHeight - heightList - margin * 4;
    
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_visitHomeList.mas_bottom).offset(margin);
        make.height.equalTo(@(oh / 4));
    }];
    
    [_date mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_detail.mas_bottom).offset(0);
        make.height.equalTo(@(oh / 4));
    }];
    
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(_date.mas_bottom).offset(0);
        make.bottom.equalTo(self.mas_bottom).offset(-49);
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
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = __RWGET_SYSFONT(14.f);
        
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