/*
 * Created by Yumenosuke Koukata on 3/7/14.
 * Copyright (c) 2014 ZYXW. All rights reserved.
 */

#import <Foundation/Foundation.h>

typedef NSMutableArray YKFileArray;

@interface YKFile : NSObject <NSCoding> {}

#pragma mark - Properties About File Name

@property(nonatomic, copy) NSString *fullPath;
@property(nonatomic, strong, readonly) NSString *name;
@property(nonatomic, strong, readonly) NSString *extension;
@property(nonatomic, strong, readonly) NSString *parentName;
@property(nonatomic, strong, readonly) NSArray *pathComponents;

#pragma mark - Properties About File State

@property(nonatomic, assign, readonly) BOOL exists;
@property(nonatomic, assign, readonly) BOOL isFile;
@property(nonatomic, assign, readonly) BOOL isEmptyDirectory;
@property(nonatomic, assign, readonly) BOOL isDirectory;
@property(nonatomic, assign, readonly) BOOL isHidden;
@property(nonatomic, assign, readonly) NSInteger depth;

#pragma mark - Extra Properties

@property(nonatomic, strong) NSMutableDictionary *tag;

#pragma mark - Create New Instance

+ (instancetype)fileWithPath:(NSString *)fullPath;

- (instancetype)initWithPath:(NSString *)fullPath;

- (instancetype)fileWithAppending:(NSString *)path;

- (YKFileArray *)filesWithAppending:(NSArray *)paths;

- (instancetype)parentFile;

#pragma mark - 'cd' Method

- (void)changeDirectory:(NSString *)path;

#pragma mark - Control File System

- (BOOL)makeDirectory;

- (BOOL)makeDirectories;

- (BOOL)makeDirectory:(NSString *)dirName;

- (BOOL)makeDirectories:(NSString *)dirName;

- (BOOL)remove;

- (BOOL)remove:(NSString *)name;

- (BOOL)copyTo:(YKFile *)destination;

- (BOOL)moveTo:(YKFile *)destination;

#pragma mark - List Files

- (NSArray *)list;

- (YKFileArray *)listFiles;

- (YKFileArray *)listRecursively:(BOOL)recursively files:(BOOL)includeFiles directories:(BOOL)includeDirs;

#pragma mark - Utilities About File Path

- (NSString *)cropPathFromDepth:(NSInteger)from toDepth:(NSInteger)to;

- (NSString *)cropPathFromDepth:(NSInteger)from;

- (NSString *)cropPathToDepth:(NSInteger)to;

- (NSString *)cropPathFromTail:(NSInteger)numOfComponents;

- (NSString *)pathComponentFromTail:(NSInteger)whatTh;

#pragma mark - Comparator

- (NSComparisonResult)compare:(YKFile *)file pathFromDepth:(NSInteger)from toDepth:(NSInteger)to;

- (NSComparisonResult)compare:(YKFile *)file pathFromDepth:(NSInteger)from;

- (NSComparisonResult)compare:(YKFile *)file pathToDepth:(NSInteger)to;

- (NSComparisonResult)compare:(YKFile *)file pathFromTail:(int)numOfComponents;

- (NSComparisonResult)compareWithName:(YKFile *)file;

#pragma mark - Utilities About File Contents

- (NSString *)text;

- (NSURL *)url;

#pragma mark - Aliases

- (void)cd:(NSString *)path;

- (void)cd;

- (BOOL)mkdir:(NSString *)dirName;

- (BOOL)mkdirs:(NSString *)dirName;

- (BOOL)mkdir;

- (BOOL)mkdirs;

- (BOOL)rm:(NSString *)name;

- (BOOL)rm;

- (BOOL)cp:(YKFile *)destination;

- (BOOL)mv:(YKFile *)destination;

#pragma mark - Other Methods
- (BOOL)isInSameDirectoryAs:(YKFile *)file;

@end

