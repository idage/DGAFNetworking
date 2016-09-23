//
//  DGNetworkHelper.m
//  DGAFNetWorkingExtend
//
//  Created by 冯亮 on 16/8/29.
//  Copyright © 2016年 idage. All rights reserved.
//  

#import "DGAFNetWorking.h"
#import "AFNetworking.h"
#import "DGNetworkCache.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "DGCacheConfig.h"
#import "DGFileHandleFactory.h"

//超时时间
static const NSTimeInterval  REQUEST_OUTTIME = 20;
//网络变化的通知名
NSString* const DG_NOTI_NETWORK_CHANGE  =@"DG_NOTI_NETWORK_CHANGE";
//网络状态
static  DGNetworkStatus _status;
@implementation DGAFNetWorking

//开始监听网络变化
+(void)startMonitoring
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                _status = DGNetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                 _status = DGNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _status = DGNetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _status = DGNetworkStatusReachableViaWiFi;
                break;
        }
        //发出网络更改通知广播
        [[NSNotificationCenter defaultCenter] postNotificationName:DG_NOTI_NETWORK_CHANGE object:[NSNumber numberWithInt:status]];
    }];
    [manager startMonitoring];
}
//停止监听网络状态
+(void)stopMonitoring{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}
//有无网络
+ (BOOL)isConnectionAvailable
{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    if (reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }else{
        return YES;
    }
}
//网络状态
+  (DGNetworkStatus)curentNetworkStatus{
    return _status;
}

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(id error))failure
{
    return [self GET:URL parameters:parameters cacheKey:nil isResponseCache:NO  responseCache:nil success:success failure:failure];
}


+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(id error))failure
{
    return [self POST:URL parameters:parameters cacheKey:nil isResponseCache:NO  responseCache:nil success:success failure:failure];
}

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
                 cacheKey:(NSString*)cacheKey
          isResponseCache:(BOOL)isResponseCache
            responseCache:(void (^)(id cacheObject))responseCache
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(id error))failure
{
    if (cacheKey==nil ||!cacheKey.length) {
        cacheKey = URL;
    }
    
    id  cahceData = [DGNetworkCache getCacheDataForKey:cacheKey];
    //获取缓存 先返回换粗 再去请求
    responseCache ? responseCache(cahceData) : nil;
    //如果只返回缓存数据就不请求网络了
    if (isResponseCache && cahceData !=nil) {
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self setUpAFHTTPSessionManager];
    return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success ? success(responseObject) : nil;
        //如果需要缓存则设置缓存
        responseCache ? [DGNetworkCache saveCacheData:responseObject forKey:cacheKey] : nil;
        
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error) : nil;
        
    }];
}


+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
                  cacheKey:(NSString*)cacheKey
           isResponseCache:(BOOL)isResponseCache
             responseCache:(void (^)(id cacheObject))responseCache
                   success:(void (^)(id responseObject))success
                   failure:(void (^)(id error))failure
{
    if (cacheKey==nil ||!cacheKey.length) {
        cacheKey = URL;
    }
    
    id  cahceData = [DGNetworkCache getCacheDataForKey:cacheKey];
    //获取缓存 先返回换粗 再去请求
    responseCache ? responseCache(cahceData) : nil;
    //如果只返回缓存数据就不请求网络了
    if (isResponseCache && cahceData !=nil) {
        return nil;
    }
    
    AFHTTPSessionManager *manager = [self setUpAFHTTPSessionManager];
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success ? success(responseObject) : nil;
        // 如果需要缓存则设置缓存
        responseCache ? [DGNetworkCache saveCacheData:responseObject forKey:cacheKey] : nil;
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error) : nil;
     
    }];
    
}
+ (void)GET:(NSString *)URL
                  parameters:(NSDictionary *)parameters
                    cacheKey:(NSString*)cacheKey
                versionCache:(NSString*)version
                durtionCache:(NSInteger)durtion
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(id error))failure{
    
    if (cacheKey==nil ||!cacheKey.length) {
        cacheKey = URL;
    }
    /**
     *  请求参数为：是否设置缓存配置文件  时间  版本
     */
    void(^request)(BOOL, double,NSString*) =^(BOOL isSetConfig, double currentTime,NSString *currentVersion){
        
        AFHTTPSessionManager *manager = [self setUpAFHTTPSessionManager];
        [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            success ? success(responseObject) : nil;
            
            //对数据进行缓存
            [DGNetworkCache saveCacheData:responseObject forKey:cacheKey];
            //配置缓存配置文件
            if (isSetConfig) {
                [DGCacheConfig setConfigApi:cacheKey duration:currentTime versionStr:currentVersion];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure ? failure(error) : nil;
        }];
        
    };
   
    //获取当前时间
    double currTime = [[NSDate date]timeIntervalSince1970];
    double nextTime = 0.0;
    //如果选择版本或者时间了
    if (version.length || durtion) {
        //获取配置
        NSDictionary *configD = [DGCacheConfig getConfig:cacheKey];
        
        if (configD) {
            nextTime = [[configD valueForKey:CACHE_ITEM_DURATION] doubleValue];
            //如果时间差大于durtion 则请求
            if (nextTime && (currTime-nextTime)>durtion) {
                //请求
                request(YES,currTime,version);
            }else if(version &&![[configD valueForKey:CACHE_ITEM_VERSION] isEqualToString:version]){
                //请求
                request(YES,currTime,version);
            }else{
                //获取缓存
                success ? success([DGNetworkCache getCacheDataForKey:cacheKey]) : nil;
            }
            
        }else{
            //请求
            request(YES,currTime,version);
        }
    }else{
        //请求 没有设置任何请求
        request(NO,currTime,version);
    }

}
+ (void)POST:(NSString *)URL
                      parameters:(NSDictionary *)parameters
                        cacheKey:(NSString*)cacheKey
                    versionCache:(NSString*)version
                    durtionCache:(NSInteger)durtion
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(id error))failure{
   
    if (cacheKey==nil ||!cacheKey.length) {
        cacheKey = URL;
    }
    /**
     *  请求参数为：是否设置缓存配置文件  时间  版本
     */
    void(^request)(BOOL, double,NSString*) =^(BOOL isSetConfig, double currentTime,NSString *currentVersion){
        
        AFHTTPSessionManager *manager = [self setUpAFHTTPSessionManager];
        [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            success ? success(responseObject) : nil;
            
            //对数据进行缓存
            [DGNetworkCache saveCacheData:responseObject forKey:cacheKey];
            //配置缓存配置文件
            if (isSetConfig) {
                [DGCacheConfig setConfigApi:cacheKey duration:currentTime versionStr:currentVersion];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure ? failure(error) : nil;
        }];
        
    };
    
    //获取当前时间
    double currTime = [[NSDate date]timeIntervalSince1970];
    double nextTime = 0.0;
    //如果选择版本或者时间了
    if (version.length || durtion) {
        //获取配置
        NSDictionary *configD = [DGCacheConfig getConfig:cacheKey];
        
        if (configD) {
            nextTime = [[configD valueForKey:CACHE_ITEM_DURATION] doubleValue];
            //如果时间差大于durtion 则请求
            if (nextTime && (currTime-nextTime)>durtion) {
                //请求
                request(YES,currTime,version);
            }else if(version &&![[configD valueForKey:CACHE_ITEM_VERSION] isEqualToString:version]){
                //请求
                request(YES,currTime,version);
            }else{
                //获取缓存
                success ? success([DGNetworkCache getCacheDataForKey:cacheKey]) : nil;
            }
            
        }else{
            //请求
            request(YES,currTime,version);
        }
    }else{
        //请求 没有设置任何请求
        request(NO,currTime,version);
    }
}

+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           fileName:(NSString *)fileName
                           mimeType:(NSString *)mimeType
                                img:(CGFloat)quality
                           progress:(void (^)(NSProgress *progress))progress
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(id error))failure
{
    
    AFHTTPSessionManager *manager = [self setUpAFHTTPSessionManager];
    return [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSData *imageData = UIImageJPEGRepresentation(image, quality?quality:0.5);
            [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@%lu.%@",fileName,(unsigned long)idx,mimeType?mimeType:@"jpeg"] mimeType:[NSString stringWithFormat:@"image/%@",mimeType?mimeType:@"jpeg"]];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        progress ? progress(uploadProgress) : nil;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success ? success(responseObject) : nil;
      
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error) : nil;
       
    }];
}

+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(void (^)(NSProgress *progress))progress
                              success:(void(^)(NSString *))success
                              failure:(void (^)(id error))failure
{
    AFHTTPSessionManager *manager = [self setUpAFHTTPSessionManager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        progress ? progress(downloadProgress) : nil;
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //获取下载目录
        NSString *loadDir = [DGFileHandleFactory getDownLoadPath];
        //拼接文件路径
        NSString *filePath = [loadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        failure && error ? failure(error) : nil;
        
    }];
    
    //开始下载
    [downloadTask resume];
    
    return downloadTask;
    
}


/**
 *  做一些基础设置
 *
 *  @return AFHTTPSessionManager
 */
+ (AFHTTPSessionManager *)setUpAFHTTPSessionManager
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  
    manager.requestSerializer.timeoutInterval = REQUEST_OUTTIME;
  
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    return manager;
}

@end
