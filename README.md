# DGAFNetworking
###一、简介
  DGAFNetWorking是我基于[AFNetworking](https://github.com/AFNetworking/AFNetworking)和[YYCache](https://github.com/ibireme/YYCache)封装的iOS网络库.除一般网络请求功能外支持按时间缓存网络请求内容和支持按版本号缓存网络请求内容。
###二、使用
#####1、网络状态
开始监听网络 在appdelegate里添加方法：
```
[DGAFNetWorking startMonitoring];
```
然后监听这个key可以收到网络状态改变的通知

```
DG_NOTI_NETWORK_CHANGE
```
也可以调用提供的接口获取当前的网络状态
```
/**
 *  当前有没有网络
 *
 *  @return 是否有网
 */
+ (BOOL)isConnectionAvailable;
/**
 *  当前的网络状态
 *
 *  @return 状态的描述
 */
+  (DGNetworkStatus)curentNetworkStatus;
```
#####2、缓存功能
自动缓存的GET请求和POST请求。responseCache是缓存的内容（是先返回缓存内容，然后再请求网络返回网络返回的数据，请求成功后自动更新缓存内容）
```
+ (NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                          cacheKey:(NSString*)cacheKey
                   isResponseCache:(BOOL)isResponseCache
                     responseCache:(void (^)(id cacheObject))responseCache
                           success:(void (^)(id responseObject))success
                           failure:(void (^)(id error))failure;

+ (NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                           cacheKey:(NSString*)cacheKey
                    isResponseCache:(BOOL)isResponseCache
                      responseCache:(void (^)(id cacheObject))responseCache
                            success:(void (^)(id responseObject))success
                            failure:(void (^)(id error))failure;
```
#####3、按时间和版本缓存功能
项目里会有一些需求，比如服务器数据版本变化才需要请求网络，或者某个接口更新的不是很频繁，在某个时间内请求可以直接返回本地缓存的内容，比如个人信息。这个时候就可以用到下面的方法。
version 是当前的版本 如果版本和缓存的版本不是一个的话则进行网络请求，否则返回本地缓存的内容
durtion 是缓存的时间，单位是秒。如果请求和上次请求的时间差少于这个时间就返回缓存的内容，否则请求网络
```
+ (void)GET:(NSString *)URL
                  parameters:(NSDictionary *)parameters
                    cacheKey:(NSString*)cacheKey
                versionCache:(NSString*)version
                durtionCache:(NSInteger)durtion
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(id error))failure;

+ (void)POST:(NSString *)URL
                      parameters:(NSDictionary *)parameters
                         cacheKey:(NSString*)cacheKey
                    versionCache:(NSString*)version
                    durtionCache:(NSInteger)durtion
                         success:(void (^)(id responseObject))success
                         failure:(void (^)(id error))failure;
```
#####4、一般网络请求
对于一般的网络请求比如不缓存数据的GET、不缓存数据的POST、图片上传、数据下载等功能，项目仅对AfNetwoking进行了简单的二次封装在DGAFNetWorking头文件里写的很清楚，这里不多做介绍。数据下载目录定在/Library/Caches/download/文件夹。可以在DGFileHandleFactory类里面修改。
###三、项目类介绍
项目里共有4个类
######1、DGAFNetWorking
这个类是封装了AfNetwoking的请求方法，所有的网络请求都要通过这个类来操作。
######2、DGNetworkCache
这个类调用YYCache.处理缓存的添加和缓存的获取
######3、DGCacheConfig
这个类处理按时间缓存和按版本缓存的缓存配置，如果想添加新的缓存方式，可以再这个类里添加一个key.
######4、DGFileHandleFactory
这个类处理一些数据存储的地址，如缓存配置文件的地址、网络下载数据的地址等。
###四 提醒
在使用缓存功能的时候 尽量把url拼接上用户的标识，否则在切换用户的时候会出现问题 
###五、鸣谢
DGAFNetWorking基于[AFNetworking](https://github.com/AFNetworking/AFNetworking)和[YYCache](https://github.com/ibireme/YYCache)完成。感谢他们对开源社区做出的贡献。
