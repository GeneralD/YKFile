# YKFile
## Utility to deal filepath as an object

YKFile's all functions are here!!  
How to use: Please read the sources yourself.

    @property(nonatomic, copy) NSString *fullPath;
    @property(nonatomic, strong, readonly) NSString *name;
    @property(nonatomic, strong, readonly) NSString *extension;
    @property(nonatomic, strong, readonly) NSString *parentName;
    @property(nonatomic, strong, readonly) NSArray *pathComponents;
    @property(nonatomic, assign, readonly) BOOL exists;
    @property(nonatomic, assign, readonly) BOOL isFile;
    @property(nonatomic, assign, readonly) BOOL isEmptyDirectory;
    @property(nonatomic, assign, readonly) BOOL isDirectory;
    @property(nonatomic, assign, readonly) BOOL isHidden;
    @property(nonatomic, assign, readonly) NSInteger depth;
    
    + (instancetype)fileWithPath:(NSString *)fullPath;
    - (instancetype)initWithPath:(NSString *)fullPath;
    - (instancetype)fileWithAppending:(NSString *)path;
    - (YKFileArray *)filesWithAppending:(NSArray *)paths;
    - (instancetype)parentFile;
    - (void)changeDirectory:(NSString *)path;
    - (BOOL)makeDirectory;
    - (BOOL)makeDirectories;
    - (BOOL)makeDirectory:(NSString *)dirName;
    - (BOOL)makeDirectories:(NSString *)dirName;
    - (BOOL)remove;
    - (BOOL)remove:(NSString *)name;
    - (BOOL)copyTo:(YKFile *)destination;
    - (BOOL)moveTo:(YKFile *)destination;
    - (NSArray *)list;
    - (YKFileArray *)listFiles;
    - (YKFileArray *)listRecursively:(BOOL)recursively files:(BOOL)includeFiles directories:(BOOL)includeDirs;
    - (NSString *)cropPathFromDepth:(NSInteger)from toDepth:(NSInteger)to;
    - (NSString *)cropPathFromDepth:(NSInteger)from;
    - (NSString *)cropPathToDepth:(NSInteger)to;
    - (NSString *)cropPathFromTail:(NSInteger)numOfComponents;
    - (NSString *)pathComponentFromTail:(NSInteger)whatTh;
    - (NSComparisonResult)compare:(YKFile *)file pathFromDepth:(NSInteger)from toDepth:(NSInteger)to;
    - (NSComparisonResult)compare:(YKFile *)file pathFromDepth:(NSInteger)from;
    - (NSComparisonResult)compare:(YKFile *)file pathToDepth:(NSInteger)to;
    - (NSComparisonResult)compare:(YKFile *)file pathFromTail:(int)numOfComponents;
    - (NSComparisonResult)compareWithName:(YKFile *)file;
    - (NSString *)text;
    - (NSURL *)url;
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
    - (BOOL)isInSameDirectoryAs:(YKFile *)file;