//
//  ViewController.m
//  UIExpandableListView
//
//  Created by Penchala, Sandeep Kumar on 5/6/15.
//  Copyright (c) 2015 Sandeep. All rights reserved.
//

#import "ExpandableListViewController.h"
#import "SubCellData.h"
#import "ExpandableCell.h"
#import "CellData.h"

@interface ExpandableListViewController ()

@end

@implementation ExpandableListViewController

const int listViewCellsSize = 25;
const int subCellsSize = 6;
const int subViewSpacingFromSuperView = 20;
const int defaultSpacing = 5;

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
    if(!tableViewCellObjects)
    {
        tableViewCellObjects = [self fillMockObjectsWithSize:listViewCellsSize];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSMutableArray *)fillMockObjectsWithSize:(int) size
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithCapacity:size];
    for (int x = 0; x < size; x++) {
        NSMutableArray *childArray = [[NSMutableArray alloc]init];
        CellData *cellData = [[CellData alloc]init];
        [cellData setImagePath:@"Album Art"];
        [cellData setHeader:@"Album Name"];
        [cellData setSubLabel:@"Music Director"];
        [cellData setSectionId:x];
        for (int y = 0; y < subCellsSize; y++) {
            SubCellData *obj = [[SubCellData alloc]init];
            [obj setImagePath:@"Album Art"];
            [obj setHeader:@"SongName"];
            [obj setSubLabel:@"Singer"];
            [obj setSubSectionId:y];
            [childArray addObject:obj];
        }
        [cellData setSublist:childArray];
        [mutableArray addObject:cellData];
    }
    return mutableArray;
}

#pragma mark - Expanding

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return listViewCellsSize;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            return subCellsSize; // return rows when expanded
        }
        
        return 1; // only top row showing
    }
    
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ExpandableCell *cell = (ExpandableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ExpandableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            CellData *cellData = [tableViewCellObjects objectAtIndex:indexPath.section];
            cell.headerLabel.text = cellData.header;
            cell.subLabel.text    = cellData.subLabel;
            cell.headerLabel.textColor = [UIColor blueColor];
            cell.subLabel.textColor = [UIColor brownColor];
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.spacingfromSuperView.constant = 5;
            [cell.image setImage:[UIImage imageNamed:@"album.png"]];
            [UIView animateWithDuration:1.5 animations:^{
                cell.headerLabel.alpha = 1;
                cell.subLabel.alpha    = 1;
            }];
        }
        else
        {
            CellData *cellData = [tableViewCellObjects objectAtIndex:indexPath.section];
            SubCellData *obj = [cellData.sublist objectAtIndex:indexPath.row];
            cell.headerLabel.text = obj.header;
            cell.subLabel.text = obj.subLabel;
            cell.headerLabel.textColor = [UIColor brownColor];
            cell.subLabel.textColor = [UIColor blueColor];
            cell.spacingfromSuperView.constant = subViewSpacingFromSuperView;
            cell.accessoryView = nil;
            [cell.image setImage:[UIImage imageNamed:@"song_icon.png"]];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            [UIView animateWithDuration:1.5 animations:^{
                cell.headerLabel.alpha = 1;
                cell.subLabel.alpha    = 1;
            }];
        }
    }
    else
    {
        cell.accessoryView = nil;
        
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            [self.tableView beginUpdates];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            NSInteger section = indexPath.section;
            CellData *cellData = [tableViewCellObjects objectAtIndex:section];
            BOOL currentlyExpanded = [cellData iscurrentlyExpanded];
            NSInteger rows;
            NSMutableArray *tmpArray = [NSMutableArray array];
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i < rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            if (currentlyExpanded)
            {
                for(NSIndexPath *indexPath in tmpArray)
                {
                    ExpandableCell *cell = (ExpandableCell *)[tableView cellForRowAtIndexPath:indexPath];
                    cell.headerLabel.alpha = 0;
                    cell.subLabel.alpha = 0;
                }
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                [cellData setIscurrentlyExpanded:NO];
                
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                [cellData setIscurrentlyExpanded:YES];
                
            }
            
            [self.tableView endUpdates];
        }
    }
}

@end
