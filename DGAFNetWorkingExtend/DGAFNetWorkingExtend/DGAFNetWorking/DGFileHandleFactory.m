//
//  DGDocumentHandleFactory.m
//  DGAFNetWorkingExtend
//
//  Created by 冯亮 on 16/8/29.
//  Copyright © 2016年 idage. All rights reserved.
//

#import "DGFileHandleFactory.h"
/**
 *  路径
 */
static NSString *CONGIH_PATH = @"cachePath";
static NSString *LOAD_PATH   = @"download";

@implementation DGFileHandleFactory

+ (NSString*)getCacheConfigPathByFileName:(NSString *)_fileName
{
    NSString* fileDirectory = [[[DGFileHandleFactory getCacheDirectory:CONGIH_PATH] stringByAppendingPathComponent:_fileName] stringByAppendingPathExtension:@"plist"];
    return fileDirectory;
}
+ (NSString*)getDownLoadPath{
    
    NSString* fileDirectory = [DGFileHandleFactory getLoadDirectory:LOAD_PATH];
    return fileDirectory;

}

+ (NSString*)getCacheDirectory:(NSString *)groupName
{
    //1、存在/documents/appendingName
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *audioDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:groupName];
    BOOL isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioDir isDirectory:&isDir] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:audioDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:groupName];
    
}
+ (NSString*)getLoadDirectory:(NSString *)groupName
{
    // /Library/Caches/download/
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *audioDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:groupName];
    BOOL isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioDir isDirectory:&isDir] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:audioDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:groupName];
}

+ (BOOL)deleteFileAtPath:(NSString*)_path{
    if ([[self class] fileExistsAtPath:_path]) {
        return [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
    }else{
        return YES;
    }
}
/**
 *  判断文件是否存在
 *
 *  @param _path 文件路径
 *
 *  @return 存在返回YES
 */
+ (BOOL)fileExistsAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:_path];
}

@end
