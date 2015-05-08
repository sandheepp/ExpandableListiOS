//
//  MockObjects.h
//  UIExpandableListView
//
//  Created by Penchala, Sandeep Kumar on 5/7/15.
//  Copyright (c) 2015 Sandeep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCellData : NSObject

@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *header;
@property (nonatomic, strong) NSString *subLabel;
@property (nonatomic) int subSectionId;
@end
