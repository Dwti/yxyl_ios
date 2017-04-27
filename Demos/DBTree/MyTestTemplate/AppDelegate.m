//
//  AppDelegate.m
//  MyTestTemplate
//
//  Created by Lei Cai on 10/30/15.
//  Copyright © 2015 yanxiu. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/runtime.h>

#import "YXTreeNode.h"
#import "YXAnotherNode.h"
#import "YXTreeMappingHelper.h"

// DB
#import "VolumeEntity.h"
#import "ChapterEntity.h"
#import "SectionEntity.h"
#import "UnitEntity.h"
#import "ExerciseEntity.h"

// ~~~~~~~~ ~~~~~~~~ ~~~~~~~~ ~~~~~~~~
#include <stdio.h>
#include <stdlib.h>

#define DEPTH 4
#define NUM_CHILDREN 6

typedef struct node
{
    struct node* child;
    struct node* next;
    int val;
    char* name;
} node;

char depth[ 2056 ];
int di;

void Build( node* tree, int n )
{
    tree->val = rand( ) % 10;
    tree->name = (char *)"haha";
    tree->child = NULL;
    
    if ( n )
    {
        int children = rand( ) % NUM_CHILDREN;
        
        for ( int i = 0; i < children; ++i )
        {
            node* child = (node*)malloc( sizeof( node ) );
            child->next = tree->child;
            tree->child = child;
            
            Build( child, n - 1 );
        }
    }
}

void Push( char c )
{
    depth[ di++ ] = ' ';
    depth[ di++ ] = c;
    depth[ di++ ] = ' ';
    depth[ di++ ] = ' ';
    depth[ di ] = 0;
}

void Pop( )
{
    depth[ di -= 4 ] = 0;
}

void Print( node* tree )
{
    printf( "(%s)\n", tree->name );
    node* child = tree->child;
    
    while ( child )
    {
        node* next = child->next;
        printf( "%s `--", depth );
        Push( next ? '|' : ' ' );
        Print( child );
        Pop( );
        child = next;
    }
}

void buildNextLevel(YXTreeNode *treeNode, node *tree) {
    tree->val = rand( ) % 10;
    NSString *name = [NSString stringWithFormat:@"%@(%@)", treeNode.uid, treeNode.name];
    tree->name = (char *)[name cStringUsingEncoding:NSUTF8StringEncoding];
    tree->child = NULL;
    
    if ( !isEmpty(treeNode.subNodes) )
    {
        int children = (int)[treeNode.subNodes count];
        
        for ( int i = children - 1; i >= 0; --i )
        {
            node* child = (node*)malloc( sizeof( node ) );
            child->next = tree->child;
            tree->child = child;
            buildNextLevel(treeNode.subNodes[i], child);
        }
    }
    
}

void printWithNode(YXTreeNode *treeNode) {
    node *root = (node *)malloc(sizeof(node));
    root->next = NULL;
    buildNextLevel(treeNode, root);
    Print(root);
}

// ~~~~~~~~ ~~~~~~~~ ~~~~~~~~ ~~~~~~~~





@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GlobalUtils setupCore];
    
    [self clearMock];
    [self setupMock];
    
    [self tests];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [GlobalUtils clearCore];
}

#pragma mark - DB 相关
- (void)clearMock {
    [VolumeEntity MR_truncateAll];
    [ChapterEntity MR_truncateAll];
    [SectionEntity MR_truncateAll];
    [UnitEntity MR_truncateAll];
    [ExerciseEntity MR_truncateAll];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)setupMock {
    [self setupVolume];
    [self setupChapter];
    [self setupSection];
    [self setupUnit];
    [self setupExercise];
}

- (void)setupVolume {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        VolumeEntity *v1 = [VolumeEntity MR_createEntityInContext:localContext];
        v1.volumeID = @"v1";
        v1.volumeName = @"v1name";
        
        VolumeEntity *v2 = [VolumeEntity MR_createEntityInContext:localContext];
        v2.volumeID = @"v2";
        v2.volumeName = @"v2name";
    }];
}

- (void)setupChapter {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        ChapterEntity *c1 = [ChapterEntity MR_createEntityInContext:localContext];
        c1.chapterID = @"c1";
        c1.chapterName = @"c1name";
        
        ChapterEntity *c2 = [ChapterEntity MR_createEntityInContext:localContext];
        c2.chapterID = @"c2";
        c2.chapterName = @"c2name";
        
        ChapterEntity *c3 = [ChapterEntity MR_createEntityInContext:localContext];
        c3.chapterID = @"c3";
        c3.chapterName = @"c3name";
    }];
}

- (void)setupSection {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        SectionEntity *s1 = [SectionEntity MR_createEntityInContext:localContext];
        s1.sectionID = @"s1";
        s1.sectionName = @"s1name";
        
        SectionEntity *s2 = [SectionEntity MR_createEntityInContext:localContext];
        s2.sectionID = @"s2";
        s2.sectionName = @"s2name";
        
        SectionEntity *s3 = [SectionEntity MR_createEntityInContext:localContext];
        s3.sectionID = @"s3";
        s3.sectionName = @"s3name";
        
        SectionEntity *s4 = [SectionEntity MR_createEntityInContext:localContext];
        s4.sectionID = @"s4";
        s4.sectionName = @"s4name";
        
        SectionEntity *s5 = [SectionEntity MR_createEntityInContext:localContext];
        s5.sectionID = @"s5";
        s5.sectionName = @"s5name";
    }];
}

- (void)setupUnit {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        UnitEntity *u1 = [UnitEntity MR_createEntityInContext:localContext];
        u1.unitID = @"u1";
        u1.unitName = @"u1name";
        
        UnitEntity *u2 = [UnitEntity MR_createEntityInContext:localContext];
        u2.unitID = @"u2";
        u2.unitName = @"u2name";
        
        UnitEntity *u3 = [UnitEntity MR_createEntityInContext:localContext];
        u3.unitID = @"u3";
        u3.unitName = @"u3name";
        
        UnitEntity *u4 = [UnitEntity MR_createEntityInContext:localContext];
        u4.unitID = @"u4";
        u4.unitName = @"u4name";
    }];
}

- (void)setupExercise {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        ExerciseEntity *e1 = [ExerciseEntity MR_createEntityInContext:localContext];
        e1.volumeID = @"v1";
        e1.chapterID = @"c1";
        e1.sectionID = @"s1";
        e1.exerciseID = @"e1";
        [self setupRelationshipForExercise:e1 inContext:localContext];
        
        ExerciseEntity *e2 = [ExerciseEntity MR_createEntityInContext:localContext];
        e2.volumeID = @"v1";
        e2.chapterID = @"c1";
        e2.sectionID = @"s1";
        e2.exerciseID = @"e2";
        [self setupRelationshipForExercise:e2 inContext:localContext];
        
        ExerciseEntity *e3 = [ExerciseEntity MR_createEntityInContext:localContext];
        e3.volumeID = @"v1";
        e3.chapterID = @"c1";
        e3.sectionID = @"s2";
        e3.exerciseID = @"e3";
        [self setupRelationshipForExercise:e3 inContext:localContext];
        
        ExerciseEntity *e4 = [ExerciseEntity MR_createEntityInContext:localContext];
        e4.volumeID = @"v1";
        e4.chapterID = @"c1";
        e4.sectionID = @"s1";
        e4.unitID = @"u1";
        e4.exerciseID = @"e4";
        [self setupRelationshipForExercise:e4 inContext:localContext];
        
        ExerciseEntity *e5 = [ExerciseEntity MR_createEntityInContext:localContext];
        e5.volumeID = @"v1";
        e5.chapterID = @"c1";
        e5.sectionID = @"s1";
        e5.unitID = @"u2";
        e5.exerciseID = @"e5";
        [self setupRelationshipForExercise:e5 inContext:localContext];
        
        ExerciseEntity *e6 = [ExerciseEntity MR_createEntityInContext:localContext];
        e6.volumeID = @"v1";
        e6.chapterID = @"c1";
        e6.sectionID = @"s1";
        e6.unitID = @"u2";
        e6.exerciseID = @"e6";
        [self setupRelationshipForExercise:e6 inContext:localContext];
        
        ExerciseEntity *e7 = [ExerciseEntity MR_createEntityInContext:localContext];
        e7.volumeID = @"v2";
        e7.chapterID = @"c2";
        e7.exerciseID = @"e7";
        [self setupRelationshipForExercise:e7 inContext:localContext];
        
        ExerciseEntity *e8 = [ExerciseEntity MR_createEntityInContext:localContext];
        e8.volumeID = @"v2";
        e8.chapterID = @"c2";
        e8.sectionID = @"s3";
        e8.exerciseID = @"e8";
        [self setupRelationshipForExercise:e8 inContext:localContext];
        
        ExerciseEntity *e9 = [ExerciseEntity MR_createEntityInContext:localContext];
        e9.volumeID = @"v2";
        e9.chapterID = @"c2";
        e9.sectionID = @"s3";
        e9.exerciseID = @"e9";
        [self setupRelationshipForExercise:e9 inContext:localContext];
        
        ExerciseEntity *e10 = [ExerciseEntity MR_createEntityInContext:localContext];
        e10.volumeID = @"v2";
        e10.chapterID = @"c2";
        e10.sectionID = @"s5";
        e10.exerciseID = @"e10";
        [self setupRelationshipForExercise:e10 inContext:localContext];
        
        ExerciseEntity *e11 = [ExerciseEntity MR_createEntityInContext:localContext];
        e11.volumeID = @"v2";
        e11.chapterID = @"c2";
        e11.sectionID = @"s4";
        e11.unitID = @"u3";
        e11.exerciseID = @"e11";
        [self setupRelationshipForExercise:e11 inContext:localContext];
        
        ExerciseEntity *e12 = [ExerciseEntity MR_createEntityInContext:localContext];
        e12.volumeID = @"v2";
        e12.chapterID = @"c2";
        e12.sectionID = @"s4";
        e12.unitID = @"u3";
        e12.exerciseID = @"e12";
        [self setupRelationshipForExercise:e12 inContext:localContext];
        
        ExerciseEntity *e13 = [ExerciseEntity MR_createEntityInContext:localContext];
        e13.volumeID = @"v2";
        e13.chapterID = @"c2";
        e13.sectionID = @"s4";
        e13.unitID = @"u4";
        e13.exerciseID = @"e13";
        [self setupRelationshipForExercise:e13 inContext:localContext];
        
        ExerciseEntity *e14 = [ExerciseEntity MR_createEntityInContext:localContext];
        e14.volumeID = @"v1";
        e14.chapterID = @"c3";
        e14.exerciseID = @"e14";
        [self setupRelationshipForExercise:e14 inContext:localContext];
        
        ExerciseEntity *e15 = [ExerciseEntity MR_createEntityInContext:localContext];
        e15.volumeID = @"v1";
        e15.chapterID = @"c3";
        e15.exerciseID = @"e15";
        [self setupRelationshipForExercise:e15 inContext:localContext];
    }];
}

- (void)setupRelationshipForExercise:(ExerciseEntity *)e inContext:(NSManagedObjectContext *)localContext {
    VolumeEntity *v = [VolumeEntity MR_findFirstByAttribute:@"volumeID" withValue:e.volumeID inContext:localContext];
    e.volume = v;
    
    ChapterEntity *c = [ChapterEntity MR_findFirstByAttribute:@"chapterID" withValue:e.chapterID inContext:localContext];
    e.chapter = c;
    
    SectionEntity *s = [SectionEntity MR_findFirstByAttribute:@"sectionID" withValue:e.sectionID inContext:localContext];
    e.section = s;
    
    UnitEntity *u = [UnitEntity MR_findFirstByAttribute:@"unitID" withValue:e.unitID inContext:localContext];
    e.unit = u;
}

#pragma mark - Tree
static NSArray *levelMappingArray;

- (YXTreeNode *)nodeWithKeySequence:(NSArray *)keySequence {
    return [self nodeWithKeySequence:keySequence deepLevel:NSIntegerMax];
}

- (YXTreeNode *)nodeWithKeySequence:(NSArray *)keySequence deepLevel:(NSInteger)deep {
    if ([keySequence count] > [levelMappingArray count]) {
        DDLogError(@"wrong key sequence provided");
        return nil;
    }
    
    if (deep == 0) {
        return nil;
    }
    
    NSArray *allExe = [self allExerciseUnderKeySequence:keySequence];
    ExerciseEntity *e = allExe.firstObject;
    if (isEmpty(e)) {
        return nil;
    }
    
    YXTreeNode *root = [[YXTreeNode alloc] init];
    root.uid = [keySequence lastObject];
    NSString *nodeName = levelMappingArray[[keySequence count] - 1];
    NSString *nodeNameName = [nodeName stringByAppendingString:@"Name"];
    
    @try {
        root.name = [[e valueForKey:nodeName] valueForKey:nodeNameName];
    }
    @catch (NSException *exception) {
        DDLogError(@"not implement : %@ %@", nodeName, nodeNameName);
    }
    //    root.name = [[e valueForKey:nodeName] valueForKey:nodeNameID];
    
    NSString *subNodeName = nil;
    if ([keySequence count] < [levelMappingArray count]) {
        subNodeName = levelMappingArray[[keySequence count]];
    }
    
    NSMutableArray *qarray = [NSMutableArray array];
    for (int i = 0; i < [keySequence count]; i++) {
        NSString *key = levelMappingArray[i];
        NSString *value = keySequence[i];
        NSString *q = [NSString stringWithFormat:@"%@ID = '%@'", key, value];
        [qarray addObject:q];
    }
    NSString *qstring = [qarray componentsJoinedByString:@" AND "];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:qstring];
    
    if (subNodeName) { // 不是最后一级，递归
        NSString *subNodeNameID = [subNodeName stringByAppendingString:@"ID"];
        NSFetchedResultsController *rc =  [ExerciseEntity MR_fetchAllGroupedBy:subNodeNameID
                                                                 withPredicate:predicate
                                                                      sortedBy:subNodeNameID ascending:YES];
        NSMutableArray *subNodes = [NSMutableArray array];
        if (isEmpty([rc sections])) {
            // 不存在
            return nil;
        }
        
        for (id<NSFetchedResultsSectionInfo> item in [rc sections]) {
            if (isEmpty(item.name)) {
                // 可能直接从任何节点出题，只有节点进树结构，最后一层题目不会进树结构
                continue;
            }
            NSMutableArray *keySequenceForNextLevel = [NSMutableArray arrayWithArray:keySequence];
            [keySequenceForNextLevel addObject:item.name];
            YXTreeNode *subnode = [self nodeWithKeySequence:keySequenceForNextLevel deepLevel:deep - 1];
            if (!subnode) {
                continue;
            }
            [subNodes addObject:subnode];
        }
        root.subNodes = subNodes;
    } else {
        // 最后一级，没有找到任何满足sequence的节点
        if (isEmpty([ExerciseEntity MR_findAllWithPredicate:predicate])) {
            return nil;
        }
    }
    
    return root;
}

- (NSArray *)allExerciseUnderKeySequence:(NSArray *)keySequence {
    if ([keySequence count] > [levelMappingArray count]) {
        DDLogError(@"wrong key sequence provided");
        return nil;
    }
    NSMutableArray *qarray = [NSMutableArray array];
    for (int i = 0; i < [keySequence count]; i++) {
        NSString *key = levelMappingArray[i];
        NSString *value = keySequence[i];
        NSString *q = [NSString stringWithFormat:@"%@ID = '%@'", key, value];
        [qarray addObject:q];
    }
    NSString *qstring = [qarray componentsJoinedByString:@" AND "];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:qstring];
    //return [ExerciseEntity MR_findAllWithPredicate:predicate];
    return [ExerciseEntity MR_findAllSortedBy:@"exerciseID" ascending:YES withPredicate:predicate];
}

- (NSArray *)exerciseUnderKeySequence:(NSArray *)keySequence {
    if ([keySequence count] > [levelMappingArray count]) {
        DDLogError(@"wrong key sequence provided");
        return nil;
    }
    NSMutableArray *qarray = [NSMutableArray array];
    for (int i = 0; i < [keySequence count]; i++) {
        NSString *key = levelMappingArray[i];
        NSString *value = keySequence[i];
        NSString *q = [NSString stringWithFormat:@"%@ID = '%@'", key, value];
        [qarray addObject:q];
    }
    NSString *qstring = [qarray componentsJoinedByString:@" AND "];
    
    [qarray removeAllObjects];
    for (int i = (int)[keySequence count]; i < [levelMappingArray count]; i++) {
        NSString *key = levelMappingArray[i];
        NSString *q = [NSString stringWithFormat:@"%@ID = %@", key, nil];
        [qarray addObject:q];
    }
    NSString *qstring2 = [qarray componentsJoinedByString:@" AND "];
    
    if (!isEmpty(qarray)) {
        qstring = [qstring stringByAppendingString:@" AND "];
        qstring = [qstring stringByAppendingString:qstring2];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:qstring];
    return [ExerciseEntity MR_findAllWithPredicate:predicate];
}

- (NSString *)entityFromLevelString:(NSString *)level {
    if (isEmpty(level)) {
        return nil;
    }
    
    NSString *firstChar = [level substringToIndex:1];
    NSString *followingChars = [level substringFromIndex:1];
    
    return [NSString stringWithFormat:@"%@%@Entity", [firstChar uppercaseString], followingChars];
}

- (void)updateWithTree:(YXTreeNode *)root startLevel:(NSString *)level {
    int n = (int)[levelMappingArray indexOfObject:level];
    [self updateForLevel:level withUid:root.uid name:root.name];
    
    for (YXTreeNode *subnode in root.subNodes) {
        if ((n + 1) >= [levelMappingArray count]) {
            // in case 传入的树过深
            return;
        }
        [self updateWithTree:subnode startLevel:levelMappingArray[n + 1]];
    }
}

- (void)updateForLevel:(NSString *)level withUid:(NSString *)uid name:(NSString *)name {
    NSString *className = [self entityFromLevelString:level];
    NSString *itemIDName = [level stringByAppendingString:@"ID"];
    NSString *itemNameName = [level stringByAppendingString:@"Name"];
    
    // 取表中所有元素
    Class c = NSClassFromString(className);
    NSMethodSignature *signture = [c methodSignatureForSelector:@selector(MR_findAll)];
    NSInvocation *invocaiton = [NSInvocation invocationWithMethodSignature:signture];
    [invocaiton setSelector:@selector(MR_findAll)];
    [invocaiton setTarget:c];
    [invocaiton invoke];
    __unsafe_unretained NSArray *result;
    [invocaiton getReturnValue:&result];
    
    // 查看是否有相同uid的item
    id newItem = nil;
    for (id item in result) {
        NSString *itemID = [item valueForKey:itemIDName];
        if ([itemID isEqualToString:uid]) {
            newItem = item;
            break;
        }
    }
    
    // 如果没有则新建item
    if (!newItem) {
        NSMethodSignature *signture2 = [c methodSignatureForSelector:@selector(MR_createEntity)];
        NSInvocation *invocaiton2 = [NSInvocation invocationWithMethodSignature:signture2];
        [invocaiton2 setSelector:@selector(MR_createEntity)];
        [invocaiton2 setTarget:c];
        [invocaiton2 invoke];
        id __unsafe_unretained result2;
        [invocaiton2 getReturnValue:&result2];
        
        newItem = result2;
    }
    
    // 赋值并保存
    [newItem setValue:uid forKey:itemIDName];
    [newItem setValue:name forKey:itemNameName];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}


#pragma mark - tests
- (void)testWithSequence:(NSArray *)sequence {
    YXTreeNode *node = [self nodeWithKeySequence:sequence];
    printWithNode(node);
    
    YXTreeNode *node1 = [self nodeWithKeySequence:sequence deepLevel:1];
    printWithNode(node1);
    
    YXTreeNode *node2 = [self nodeWithKeySequence:sequence deepLevel:2];
    printWithNode(node2);
    
    YXTreeNode *node3 = [self nodeWithKeySequence:sequence deepLevel:3];
    printWithNode(node3);
    
    NSArray *arr = [self exerciseUnderKeySequence:sequence];
    NSLog(@"~~~~此节点出的题~~~~");
    for (ExerciseEntity *e in arr) {
        NSLog(@"%@", e.exerciseID);
    }
    
    NSLog(@"~~~~此节点下所有出的题~~~~");
    NSArray *arr2 = [self allExerciseUnderKeySequence:sequence];
    for (ExerciseEntity *e in arr2) {
        NSLog(@"%@", e.exerciseID);
    }
}

- (void)tests {
    [self testDBTree];
    [self testDBTree2];
    [self testUpdateTable];
    [self testChangeTableWithTree];
    [self testMappingTree];
}

- (void)testDBTree {
    levelMappingArray = @[
                          @"volume",
                          @"chapter",
                          @"section",
                          @"unit"
                          ];
    
    [self testWithSequence:@[@"v2"]];
    
    // 下面这些如果想测，需要改变levelMappingArray
    //    levelMappingArray = @[
    //                          @"chapter",
    //                          @"section",
    //                          @"unit"
    //                          ];

    //    [self testWithSequence:@[@"c1"]];
    //    [self testWithSequence:@[@"c1", @"s1"]];
    //    [self testWithSequence:@[@"c1", @"s1", @"u1"]];
    //    [self testWithSequence:@[@"c1", @"s1", @"u2"]];
    //    [self testWithSequence:@[@"c2"]];
    //    [self testWithSequence:@[@"c2", @"s3"]];
    //    [self testWithSequence:@[@"c2", @"s4"]];
    //    [self testWithSequence:@[@"c2", @"s1"]];
    //    [self testWithSequence:@[@"c3"]];
    //    [self testWithSequence:@[@"c5", @"s8"]];
}

- (void)testDBTree2 {
    levelMappingArray = @[@"section",
                          @"chapter",
                          @"unit"
                          ];
    
    [self testWithSequence:@[@"s1", @"c1"]];
    
    // 我们来从第一节出道题吧 ！
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        ExerciseEntity *e = [ExerciseEntity MR_createEntityInContext:localContext];
        e.sectionID = @"s1";
        e.exerciseID = @"e逆天";
        [self setupRelationshipForExercise:e inContext:localContext];
    }];
    
    [self testWithSequence:@[@"s1"]];
}

- (void)testUpdateTable {
    levelMappingArray = @[@"section",
                          @"chapter",
                          @"unit"
                          ];

    [self updateForLevel:@"section" withUid:@"s1" name:@"sssss"];
    NSArray *arr = [SectionEntity MR_findAll];
    for (SectionEntity *s in arr) {
        NSLog(@"%@(%@)", s.sectionID, s.sectionName);
    }
    
    [self updateForLevel:@"section" withUid:@"abc" name:@"abc"];
    NSArray *arr2 = [SectionEntity MR_findAll];
    for (SectionEntity *s in arr2) {
        NSLog(@"%@(%@)", s.sectionID, s.sectionName);
    }
}

- (void)testChangeTableWithTree {
    levelMappingArray = @[
                          @"volume",
                          @"chapter",
                          @"section",
                          @"unit"
                          ];

    
    YXTreeNode *node = [self nodeWithKeySequence:@[@"v1", @"c1"]];
    YXTreeNode *subnode = node.subNodes.firstObject;
    subnode.name = @"我改了";
    YXTreeNode *subnode2 = subnode.subNodes.firstObject;
    subnode2.name = @"我也改了";
    
    [self updateWithTree:node startLevel:@"chapter"];
    YXTreeNode *newNode = [self nodeWithKeySequence:@[@"v1", @"c1"]];
    printWithNode(newNode);
}

- (void)testMappingTree {
    levelMappingArray = @[
                          @"volume",
                          @"chapter",
                          @"section",
                          @"unit"
                          ];
    
    YXTreeNode *node = [self nodeWithKeySequence:@[@"v2"]];
    printWithNode(node);
    
    YXTreeMappingHelper *map = [[YXTreeMappingHelper alloc] init];
    map.fromClassName = @"YXTreeNode";
    map.fromIDName = @"uid";
    map.fromNameName = @"name";
    map.fromSubNodesName = @"subNodes";
    
    map.toClassName = @"YXAnotherNode";
    map.toIDName = @"anotherID";
    map.toNameName = @"anotherName";
    map.toSubNodesName = @"anotherSubNodeArray";
    
    YXAnotherNode *toNode = [map giveMeTreeFromTree:node];
    
    [map swipeFromTo];
    
    YXTreeNode *node2 = [map giveMeTreeFromTree:toNode];
    printWithNode(node2);
}

@end