//
//  TestRootViewController.m
//  Flickr
//
//  Created by Lei Cai on 9/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TestsRootViewController.h"
#import <objc/runtime.h>

#pragma mark - headers
#pragma mark -

@interface TestsRootViewController ()

@property (nonatomic, retain) NSDictionary *devActionDictionary;
@property (nonatomic, retain) NSArray *devlist;
@end

@implementation TestsRootViewController

#pragma mark - util APIs

- (NSString*)actionName:(NSIndexPath*)indexPath
{
    NSArray *testActionArray = [self.devActionDictionary objectForKey:[self.devlist objectAtIndex:indexPath.section]];
    NSString *actionName = [testActionArray objectAtIndex:indexPath.row];
    return actionName;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.devActionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                self.devTestActions, @"dev",
                                nil];
    
    self.devlist = [[NSArray alloc] initWithArray:[self.devActionDictionary allKeys]];
}

- (void)viewDidUnload
{
    self.devActionDictionary = nil;
    self.devlist = nil;
    
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.devlist count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *testActionArray = [self.devActionDictionary objectForKey:[self.devlist objectAtIndex:section]];
    return [testActionArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.devlist objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self actionName:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SEL selector = NSSelectorFromString([self actionName:indexPath]);
    if ([self respondsToSelector:selector])
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector];
#pragma clang diagnostic pop
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"No Implemented Yet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)doTest {
    DDLogDebug(@"test frame works");
}

@end
