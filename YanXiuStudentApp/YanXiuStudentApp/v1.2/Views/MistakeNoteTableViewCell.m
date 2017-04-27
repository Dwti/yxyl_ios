//
//  MistakeNoteTableViewCell.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/8/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeNoteTableViewCell.h"
#import "YXQADashLineView.h"
#import "UIColor+YXColor.h"
#import "YXAddPhotoView.h"
#import "YXPhotoManager.h"
#import "YXPhotoModel.h"
#import "YXQADashLineView.h"

static NSInteger const MaxInputLength = 500;
static NSInteger const MaxPhotoNum = 4;

@interface MistakeNoteTableViewCell() <UITextViewDelegate, YXQASubjectiveAddPhotoDelegate>
@property (nonatomic, assign) BOOL addEnable;
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UIButton *editNoteButton;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) SAMTextView *textView;
@property (nonatomic, strong) YXQADashLineView *dashView;
@property (nonatomic, strong) YXQADashLineView *imgDashView;
@property (nonatomic, strong) YXAddPhotoView *addPhotoView;
@property (nonatomic, strong) YXAlbumViewModel *viewModel;
@end

@implementation MistakeNoteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.dashView = [[YXQADashLineView alloc]init];

    self.typeImageView = [[UIImageView alloc]init];
    self.typeImageView.contentMode = UIViewContentModeLeft;

    self.editNoteButton = [[UIButton alloc] init];
    self.editNoteButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.editNoteButton.titleLabel.shadowColor = [UIColor yx_colorWithHexString:@"ffff99"];
    self.editNoteButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [self.editNoteButton setTitle:@"编辑笔记 >" forState:UIControlStateNormal];
    [self.editNoteButton setTitleColor:[UIColor yx_colorWithHexString:@"805500"] forState:UIControlStateNormal];
    [self.editNoteButton addTarget:self action:@selector(editNoteButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    self.containerView = [[UIView alloc]init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.cornerRadius = 10;
    self.containerView.layer.borderWidth = 2;
    self.containerView.layer.borderColor = [UIColor colorWithHexString:@"ccc4a3"].CGColor;

    self.textView = [[SAMTextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.returnKeyType = UIReturnKeyDone;
    
    self.imgDashView = [[YXQADashLineView alloc] init];
    
    self.addPhotoView = [[YXAddPhotoView alloc] initWithFrame:CGRectZero addEnable:self.addEnable];
    self.addPhotoView.userInteractionEnabled = YES;
    self.addPhotoView.backgroundColor = [UIColor blueColor];
    [self.addPhotoView setAdjustAddButton:^(UIButton *btn) {
        [btn setTitle:@"上传照片" forState:UIControlStateNormal];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }];
    
    WEAK_SELF
    [self.addPhotoView setPhotoHandle:^(NSInteger nInteger) {
        STRONG_SELF
        if (self.delegate && [self.delegate respondsToSelector:@selector(photoClickedWithModel:index:canDelete:)]) {
            [self.delegate photoClickedWithModel:self.viewModel index:nInteger canDelete:self.addEnable];
        }
    }];
    
    [self.addPhotoView setAddHandle:^{
        STRONG_SELF
        if (!self.viewModel.albumListArray || [self.viewModel.albumListArray count] == 0) {
            [self.viewModel gotoGetAlbumListArray];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(addPhotoWithViewModel:)]) {
            [self.delegate addPhotoWithViewModel:self.viewModel];
        }
    }];
}

- (void)setupLayout {
    [self.contentView addSubview:self.dashView];
    [self.dashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(60, 18));
    }];
    
    [self.contentView addSubview:self.editNoteButton];
    [self.editNoteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.typeImageView.mas_centerY).offset(0);
    }];
    
    [self.contentView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(15);
        make.right.mas_equalTo(-20);
    }];
    
    [self.containerView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-12);
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-11);
    }];
    
    [self.contentView addSubview:self.imgDashView];
    [self.imgDashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.containerView.mas_bottom).offset(15);
    }];
    
    [self.contentView addSubview:self.addPhotoView];
    [self.addPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).offset(30);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)reloadViewWithArray:(NSArray *)array addEnable:(BOOL)enable {
    if (!self.viewModel) {
        self.viewModel = [[YXAlbumViewModel alloc] init];
    }
    
    NSMutableArray * newArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[QAImageAnswer class]]) {
            QAImageAnswer * data = obj;
            if (data.data) {
                [newArray addObject:data.data];
            }else{
                YXPhotoModel *model = [[YXPhotoModel alloc]initWithURL:[NSURL URLWithString:data.url]];
                model.thumbImageUrl = data.url;
                [newArray addObject:model];
            }
        }
    }];
    
    self.viewModel.selectPhotoArray = newArray;
    self.addEnable = enable;
    
    [self setupRAC];
}

- (NSArray *)getPhotoArray {
    NSMutableArray * array = [NSMutableArray array];
    [self.viewModel.selectPhotoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YXPhotoModel class]]) {
            QAImageAnswer * data = [[QAImageAnswer alloc] init];
            data.data = obj;
            [array addObject:data];
        }
    }];
    return array;
}

#pragma mark - Actions
- (void)editNoteButtonTapped {
    if (self.editButtonTapped) {
        self.editButtonTapped();
    }
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *toBeString = textView.text;
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        if (toBeString.length > MaxInputLength) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MaxInputLength];
            if (rangeIndex.length == 1) {
                textView.text = [toBeString substringToIndex:MaxInputLength];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MaxInputLength)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }

    if (self.textDidChange) {
        self.textDidChange(textView.text);
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [textView setContentOffset:CGPointZero animated:YES];
        return NO;
    }
    return YES;
}

#pragma mark - Setter
- (void)setItem:(YXQAAnalysisItem *)item {
    _item = item;
    self.typeImageView.image = [UIImage imageNamed:[item typeString]];
}

- (void)setQuestionItem:(QAQuestion *)questionItem {
    _questionItem = questionItem;
    
    self.textView.text = questionItem.noteText;
}

- (void)setIsEditable:(BOOL)isEditable {
    _isEditable = isEditable;

    if (isEditable) {
        self.dashView.hidden = YES;
        self.typeImageView.hidden = YES;
        self.editNoteButton.hidden = YES;
        self.containerView.alpha = 1;
        self.imgDashView.hidden = NO;
        self.textView.editable = YES;
        self.textView.userInteractionEnabled = YES;
        self.textView.attributedPlaceholder = [self attributedPlaceholderString];
        self.containerView.backgroundColor = [UIColor whiteColor];
        self.containerView.layer.borderColor = [UIColor colorWithHexString:@"ccc4a3"].CGColor;
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
        }];
    } else {
        self.dashView.hidden = NO;
        self.typeImageView.hidden = NO;
        self.editNoteButton.hidden = NO;
        self.containerView.alpha = 1;
        self.containerView.backgroundColor = [UIColor clearColor];
        self.containerView.layer.borderColor = [UIColor clearColor].CGColor;
        self.imgDashView.hidden = YES;
        self.textView.editable = NO;
        self.textView.userInteractionEnabled = NO;
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.typeImageView.mas_bottom).mas_offset(6);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
        }];
        [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.addPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_bottom).offset(8);
        }];
    }
}

- (NSAttributedString *)attributedPlaceholderString {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    attributes[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#999999"];
    return [[NSAttributedString alloc] initWithString:@"请编辑笔记内容(500字以内)..." attributes:attributes];
}

- (void)setupRAC {
    WEAK_SELF
    [[RACObserve(self.viewModel, selectPhotoArray) deliverOnMainThread] subscribeNext:^(NSArray * photosArray) {
        STRONG_SELF
        
        BLOCK_EXEC(self.photosChangedBlock,[self getPhotoArray]);
        
        if (self.addEnable) {
            self.addPhotoView.addEnable = photosArray.count == MaxPhotoNum? NO : YES;
        } else {
            self.addPhotoView.addEnable = NO;
        }
        
        [self.addPhotoView reloadWithPhotosArray:photosArray];
        
        [self.addPhotoView mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat height = MIN([self.addPhotoView getHight], 55 + 8);
            if (!self.isEditable && isEmpty(photosArray)) {
                height = 0;
            }
            make.height.mas_equalTo(height);
        }];
    }];
}

#pragma mark - Height
+ (CGFloat)heightForNoteWithQuestion:(QAQuestion *)item isEditable:(BOOL)isEditable {
    if (isEditable) {
        return  320 + 103;
    } else {
        CGFloat height = 30 + 18 + 15;
        
        if (!isEmpty(item.noteText)) {
            CGFloat maxTextWidth = [UIScreen mainScreen].bounds.size.width - 10 - 16 - 20 - 20;
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, maxTextWidth, MAXFLOAT)];
            textView.font = [UIFont systemFontOfSize:14];
            textView.text = item.noteText;
            [textView sizeToFit];
            height += textView.frame.size.height;
        }
     
        if (!isEmpty(item.noteImages)) {
            height += 68;
        }
        
        return ceilf(height);
    }
}

@end
