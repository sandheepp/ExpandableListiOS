//
//  ExpandableCell.h
//  UIExpandableListView
//
//  Created by Penchala, Sandeep Kumar on 5/7/15.
//  Copyright (c) 2015 Sandeep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpandableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *subLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spacingfromSuperView;

@end
