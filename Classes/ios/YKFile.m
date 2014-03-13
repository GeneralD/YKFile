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
	[self setFullPath:fullPath];
	return self;
}

- (instancetype)fileWithAppending:(NSString *)path {
	return [self.class fileWithPath:[self.fullPath stringByAppendingPathComponent:path]];
}

- (YKFileArray *)filesWithAppending:(NSArray *)paths {
	return [self.class fileWithPath:[self.fullPath stringsByAppendingPaths:paths]];
}

- (instancetype)parentFile {
	return [self.class fileWithPath:_fullPath.stringByDeletingLastPathComponent];
}

#pragma mark - NSDirectories

+ (instancetype)mainBundleDirectory {
	return [self fileWithPath:[NSBundle mainBundle].resourcePath];
}

+ (instancetype)cachesDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cachePath = [paths firstObject];
	return [self fileWithPath:cachePath];
}

+ (instancetype)documentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths firstObject];
	return [self fileWithPath:documentsDirectoryPath];
}

+ (instancetype)temporaryDirectory {
	return [self fileWithPath:NSTemporaryDirectory()];
}

#pragma mark - Overridden Methods

- (id)copy {
	return [self.class fileWithPath:[NSString stringWithString:self.fullPath]];
}

#pragma mark - Properties

- (void)setFullPath:(NSString *)fullPath {
	_fullPath = fullPath;
}

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

#pragma mark - 'cd' Method

- (void)changeDirectory:(NSString *)path {
	NSArray *components = path.pathComponents;
	for (int i = 0; i < [components count]; i++) {
		NSString *component = components[i];
		if ([component isEqualToString:@".."]) {
			self.fullPath = self.parentFile.fullPath;
			continue;
		} else if ([component isEqualToString:@"."]) {
			continue;
		} else {
			self.fullPath = [self.fullPath stringByAppendingPathComponent:component];
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

- (BOOL)remove {
	NSError *error = nil;
	return [[NSFileManager defaultManager] removeItemAtPath:self.fullPath error:&error];
}

- (BOOL)copyTo:(YKFile *)destination {
	NSError *error = nil;
	return [[NSFileManager defaultManager] copyItemAtPath:self.fullPath toPath:destination error:&error];
}

- (BOOL)moveTo:(YKFile *)destination {
	NSError *error = nil;
	return [[NSFileManager defaultManager] moveItemAtPath:self.fullPath toPath:destination error:&error];
}

#pragma mark - List Files

- (NSArray *)list {
	if (!self.isDirectory) return nil; // if directory doesn't exist, return nil
	NSError *error = nil;
	return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_fullPath error:&error];
}

- (YKFileArray *)listFiles {
	if (!self.isDirectory) return nil; // if directory doesn't exist, return nil
	YKFileArray *resultFiles = [YKFileArray new];
	NSArray *fullPaths = [_fullPath stringsByAppendingPaths:[self list]];
	for (int i = 0; i < [fullPaths count]; i++) [resultFiles addObject:[YKFile fileWithPath:fullPaths[i]]];
	return resultFiles; // if no file exists in the directory, return empty array
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

- (NSComparisonResult)compare:(YKFile *)file pathFromTail:(int)num {
	NSString *path1 = [self cropPathFromTail:num];
	NSString *path2 = [file cropPathFromTail:num];
	return [path1 compare:path2];
}

#pragma mark - Aliases

- (void)cd:(NSString *)path {
	return [self changeDirectory:path];
}

- (BOOL)mkdir {
	return [self makeDirectory];
}

- (BOOL)mkdirs {
	return [self makeDirectories];
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

@end
