/*
 * Created by Yumenosuke Koukata on 3/7/14.
 * Copyright (c) 2014 ZYXW. All rights reserved.
 */

#import "YKFile.h"

@implementation YKFile {
}

#pragma mark - Create New Instance

+ (instancetype)fileWithPath:(NSString *)fullPath {
	return [[self alloc] initWithPath:fullPath];
}

- (instancetype)initWithPath:(NSString *)fullPath {
	if (self = [super init]) {
		[self setFullPath:fullPath];
	}
	return self;
}

- (instancetype)fileWithAppending:(NSString *)path {
	return [self.class fileWithPath:[self.fullPath stringByAppendingPathComponent:path]];
}

- (YKFileArray *)filesWithAppending:(NSArray *)paths {
	YKFileArray *files = [YKFileArray new];
	for (int i = 0; i < [paths count]; i++) [files addObject:[self fileWithAppending:paths[i]]];
	return files;
}

- (instancetype)parentFile {
	return [self.class fileWithPath:_fullPath.stringByDeletingLastPathComponent];
}

#pragma mark - NSCoding Methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:_fullPath forKey:@"FullPath"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		NSString *fullPath = [aDecoder decodeObjectForKey:@"FullPath"];
		[self setFullPath:fullPath];
	}
	return self;
}

#pragma mark - Overridden Methods

- (id)copy {
	return [self.class fileWithPath:[NSString stringWithString:self.fullPath]];
}

#pragma mark - Properties

- (NSString *)name {
	return [_fullPath lastPathComponent];
}

- (NSString *)extension {
	return [_fullPath pathExtension];
}

- (NSString *)parentName {
	return [self parentFile].name;
}

- (NSArray *)pathComponents {
	return _fullPath.pathComponents;
}

- (BOOL)exists {
	if (!_fullPath) return NO;
	return [[NSFileManager defaultManager] fileExistsAtPath:_fullPath];
}

- (BOOL)isFile {
	if (!_fullPath) return NO;
	BOOL b;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:_fullPath isDirectory:&b];
	return exists && !b;
}

- (BOOL)isDirectory {
	if (!_fullPath) return NO;
	BOOL b;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:_fullPath isDirectory:&b];
	return exists && b;
}

- (BOOL)isEmptyDirectory {
	if (!self.isDirectory) return NO;
	return ([[self list] count] == 0);
}

- (BOOL)isHidden {
	return [self.name hasPrefix:@"."];
}

- (NSInteger)depth {
	return [[_fullPath pathComponents] count];
}

- (NSMutableDictionary *)tag {
	if (!_tag) _tag = [NSMutableDictionary dictionary];
	return _tag;
}

#pragma mark - 'cd' Method

- (void)changeDirectory:(NSString *)path {
	NSArray *components = path.pathComponents;
	for (int i = 0; i < [components count]; i++) {
		NSString *component = components[i];
		if (i == 0 && [component isEqualToString:@"~"]) { // cd ~
			_fullPath = NSHomeDirectory();
		} else if ([component isEqualToString:@".."]) { // cd ..
			_fullPath = self.parentFile.fullPath;
		} else if ([component isEqualToString:@"."]) { // cd .
		} else if ([component isEqualToString:@"*"]) { // cd to first found file or directory
			YKFileArray *list = [self listFiles];
			for (YKFile *file in list) {
				if ([file.name isEqual:@".DS_Store"]) continue;
				if ([file.name isEqual:@"Thumbs.db"]) continue;
				_fullPath = file.fullPath;
				break;
			}
		} else { // cd component
			_fullPath = [_fullPath stringByAppendingPathComponent:component];
		}
	}
}

#pragma mark - Control File System

- (BOOL)makeDirectory {
	NSError *error = nil;
	return [[NSFileManager defaultManager] createDirectoryAtPath:self.fullPath withIntermediateDirectories:NO attributes:nil error:&error];
}

- (BOOL)makeDirectories {
	NSError *error = nil;
	return [[NSFileManager defaultManager] createDirectoryAtPath:self.fullPath withIntermediateDirectories:YES attributes:nil error:&error];
}

- (BOOL)makeDirectory:(NSString *)dirName {
	id copied = [self copy];
	[copied cd:dirName];
	return [copied makeDirectory];
}

- (BOOL)makeDirectories:(NSString *)dirName {
	id copied = [self copy];
	[copied cd:dirName];
	return [copied makeDirectories];
}

- (BOOL)remove {
	NSError *error = nil;
	return [[NSFileManager defaultManager] removeItemAtPath:self.fullPath error:&error];
}

- (BOOL)remove:(NSString *)name {
	id copied = [self copy];
	[copied cd:name];
	return [copied remove];
}

- (BOOL)copyTo:(YKFile *)destination {
	NSError *error = nil;
	return [[NSFileManager defaultManager] copyItemAtPath:self.fullPath toPath:destination.fullPath error:&error];
}

- (BOOL)moveTo:(YKFile *)destination {
	NSError *error = nil;
	return [[NSFileManager defaultManager] moveItemAtPath:self.fullPath toPath:destination.fullPath error:&error];
}

#pragma mark - List Files

- (NSArray *)list {
	if (!self.isDirectory) return nil; // if directory doesn't exist, return nil
	NSError *error = nil;
	return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_fullPath error:&error];
}

- (YKFileArray *)listFiles {
	if (!self.isDirectory) return nil; // if directory doesn't exist, return nil
	return [self filesWithAppending:[self list]];
}

- (YKFileArray *)listRecursively:(BOOL)recursively files:(BOOL)includeFiles directories:(BOOL)includeDirs {
	YKFileArray *resultFiles = [YKFileArray new];
	YKFileArray *files = [self listFiles];
	for (int i = 0; i < [files count]; i++) {
		id file = files[i];
		if ((includeFiles && [file isFile]) || (includeDirs && [file isDirectory])) [resultFiles addObject:file];
		if (recursively && [file isDirectory]) {
			[resultFiles addObjectsFromArray:[file listRecursively:recursively files:includeFiles directories:includeDirs]];
		}
	}
	return resultFiles;
}

#pragma mark - Crop Path

- (NSString *)cropPathFromDepth:(NSInteger)from toDepth:(NSInteger)to {
	from = MAX(from, 0);
	to = MIN(to, self.depth);
	NSArray *components = self.pathComponents;
	NSString *result = nil;
	for (int i = from; i < to; i++) {
		if (!result) result = @"";
		result = [result stringByAppendingPathComponent:components[i]];
	}
	return result;
}

- (NSString *)cropPathFromDepth:(NSInteger)from {
	return [self cropPathFromDepth:from toDepth:NSIntegerMax];
}

- (NSString *)cropPathToDepth:(NSInteger)to {
	return [self cropPathFromDepth:0 toDepth:to];
}

- (NSString *)cropPathFromTail:(NSInteger)numOfComponents {
	return [self cropPathFromDepth:self.depth - numOfComponents];
}

- (NSString *)pathComponentFromTail:(NSInteger)whatTh {
	NSArray *components = [[self cropPathFromTail:whatTh] pathComponents];
	if ([components count] > 0) return components[0];
	return nil;
}

#pragma mark - Methods return NSComparisonResult

- (NSComparisonResult)compare:(YKFile *)file pathFromDepth:(NSInteger)from toDepth:(NSInteger)to {
	NSString *path1 = [self cropPathFromDepth:from toDepth:to];
	NSString *path2 = [file cropPathFromDepth:from toDepth:to];
	return [path1 compare:path2];
}

- (NSComparisonResult)compare:(YKFile *)file pathFromDepth:(NSInteger)from {
	NSString *path1 = [self cropPathFromDepth:from];
	NSString *path2 = [file cropPathFromDepth:from];
	return [path1 compare:path2];
}

- (NSComparisonResult)compare:(YKFile *)file pathToDepth:(NSInteger)to {
	NSString *path1 = [self cropPathToDepth:to];
	NSString *path2 = [file cropPathToDepth:to];
	return [path1 compare:path2];
}

- (NSComparisonResult)compare:(YKFile *)file pathFromTail:(int)numOfComponents {
	NSString *path1 = [self cropPathFromTail:numOfComponents];
	NSString *path2 = [file cropPathFromTail:numOfComponents];
	return [path1 compare:path2];
}

- (NSComparisonResult)compareWithName:(YKFile *)file {
	return [self compare:file pathFromTail:1];
}

#pragma mark - Utilities About File Contents

- (NSString *)text {
	NSError *error = nil;
	return [NSString stringWithContentsOfFile:self.fullPath encoding:NSUTF8StringEncoding error:&error];
}

- (NSURL *)url {
	return [NSURL fileURLWithPath:self.fullPath];
}

#pragma mark - Aliases

- (void)cd:(NSString *)path {
	return [self changeDirectory:path];
}

- (void)cd {
	return [self cd:@"~"];
}

- (BOOL)mkdir:(NSString *)dirName {
	return [self makeDirectory:dirName];
}

- (BOOL)mkdirs:(NSString *)dirName {
	return [self makeDirectories:dirName];
}

- (BOOL)mkdir {
	return [self makeDirectory];
}

- (BOOL)mkdirs {
	return [self makeDirectories];
}

- (BOOL)rm:(NSString *)name {
	return [self remove:name];
}

- (BOOL)rm {
	return [self remove];
}

- (BOOL)cp:(YKFile *)destination {
	return [self copyTo:destination];
}

- (BOOL)mv:(YKFile *)destination {
	return [self moveTo:destination];
}

#pragma mark - Other Methods

- (BOOL)isInSameDirectoryAs:(YKFile *)file {
	return [self.parentFile.fullPath isEqualToString:file.parentFile.fullPath];
}

@end
