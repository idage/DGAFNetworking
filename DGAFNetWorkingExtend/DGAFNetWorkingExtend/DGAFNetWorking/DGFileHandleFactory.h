//
//  DGDocumentHandleFactory.h
//  DGAFNetWorkingExtend
//
//  Created by 冯亮 on 16/8/29.
//  Copyright © 2016年 idage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGFileHandleFactory : NSObject
/**
 *  获取缓存配置文件路径
 *
 *  @param _fileName 文件名
 *  @return 文件路径
 */
+ (NSString*)getCacheConfigPathByFileName:(NSString *)_fileName;
/**
 *  获取下载文件路径
 *  @return 路径
 */
+ (NSString*)getDownLoadPath;

//删除文件
+ (BOOL)deleteFileAtPath:(NSString*)_path;
@end
