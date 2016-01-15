//
//  ChooseCell.m
//  zdnz
//
//  Created by babywolf on 15/12/31.
//  Copyright © 2015年 com.babywolf. All rights reserved.
//

#import "ChooseCell.h"
#import "UIViewExt.h"

@implementation ChooseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _chooseView = [[UIImageView alloc] init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    _chooseView.frame = CGRectMake(self.width-42, (self.height-22)/2, 22, 22);
    if (_isSelected) {
        _chooseView.image = [UIImage imageNamed:@"addclock_weekcycle_hint"];
    }else {
        _chooseView.image = [UIImage imageNamed:@"addclock_weekcycle_unchecked"];
    }
    [self addSubview:_chooseView];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
