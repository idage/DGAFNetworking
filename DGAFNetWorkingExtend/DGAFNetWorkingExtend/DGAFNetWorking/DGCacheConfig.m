//
//  DGCacheConfig.m
//  DGAFNetWorkingExtend
//
//  Created by 冯亮 on 16/8/29.
//  Copyright © 2016年 idage. All rights reserved.
//

#import "DGCacheConfig.h"
#import "DGFileHandleFactory.h"
/*--------------缓存配置参数项-----------------------------*/

NSString* const CACHE_ITEM_DURATION = @"duration";
NSString* const CACHE_ITEM_VERSION  = @"version";

/**
 *  内存缓存的缓存配置
 */
static NSMutableDictionary *configDic;
/**
 *  配置文件名字
 */
static NSString *CONGIH_NAME = @"cacheConfig";



@implementation DGCacheConfig
/**
 *  根据请求地址获取缓存配置
 *
 *  @param apiStr 网络请求地址
 *
 *  @return 配置内容
 */
+(NSDictionary*)getConfig:(NSString*)apiStr{
    
    //如果有配置则直接返回
    if (configDic ||[configDic valueForKey:apiStr]) {
        return [configDic valueForKey:apiStr];
    }
    //从本地plist文件获取
    NSString *userFilePath = [DGFileHandleFactory getCacheConfigPathByFileName:CONGIH_NAME];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:userFilePath];
    if (dic ||[dic valueForKey:apiStr]) {
        return [dic valueForKey:apiStr];
    }
    return nil;
}
/**
 *  添加一个API的缓存配置
 *
 *  @param apiStr   网络请求地址
 *  @param duration 根据时间差缓存 （几秒钟之内请求网络返回的是缓存内容）
 *  @param version  根据版本缓存    （版本变化则请求 否则返回的是缓存内容）
 */
+(void)setConfigApi:(NSString*)apiStr duration:(NSInteger)duration versionStr:(NSString*)version{

    NSMutableDictionary *configItem =  [[NSMutableDictionary alloc]init];
    //判空
    if(duration<0){
        duration = 0;
    }
    //设置时间
    [configItem setValue:@(duration) forKey:CACHE_ITEM_DURATION];
    if(version && version.length){
        //设置版本
        [configItem setValue:version forKey:CACHE_ITEM_VERSION];
    }
    //设置缓存配置
    if(configDic){
        [configDic setValue:configItem forKey:apiStr];
    }else{
        configDic = [[NSMutableDictionary alloc]init];
        [configDic setValue:configItem forKey:apiStr];
    }
    //保存本地
    NSString *userFilePath = [DGFileHandleFactory getCacheConfigPathByFileName:CONGIH_NAME ];
    [configDic writeToFile:userFilePath atomically:YES];
    
}

@end

