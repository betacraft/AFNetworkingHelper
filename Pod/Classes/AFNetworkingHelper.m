//
//  IPWTHttpUtils.m
//  ipWorldTv
//
//  Created by my full name on 5/14/14.
//  Copyright (c) 2014 IPWorldTv. All rights reserved.
//

#import "AFNetworkingHelper.h"


@implementation AFNetworkingHelper

static NSMutableArray *networkQueue = nil;

+ (NSMutableArray *) getNetworkQueue{
    if(networkQueue != nil)
        return networkQueue;
    networkQueue =  [[NSMutableArray alloc]init];
    return networkQueue;
}

+ (void)cancelAllRunningNetworkOperations{
    for (AFHTTPRequestOperation *operation in [self getNetworkQueue]){
        @try {
            [operation cancel];
        }
        @catch (NSException *exception) {
            NSLog(@"Error while cancelling the operation");
        }
        @finally {
            
        }
    }
}

+ (void)executePostWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers andAuthorizationHeaderUser:(NSString *)user andAuthrozationHeaderPassword:(NSString *)password withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [[manager securityPolicy]setAllowInvalidCertificates:YES];
    [[manager requestSerializer]setAuthorizationHeaderFieldWithUsername:user password:password];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
      operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            failure(operation, error);
        }];
    }
    else {
        [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure %ld",[error code]);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            failure(operation, error);
        }];
    }
    [[self getNetworkQueue]addObject:operation];
}


+ (void) executeDeleteWithUrl:(NSString *)url AndParameters:(NSDictionary *)parameters AndHeaders:(NSDictionary *)headers withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
    else {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        operation = [manager DELETE:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
    [[self getNetworkQueue]addObject:operation];
}

+ (void)executePostWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // hack to allow 'text/plain' content-type to work
    NSMutableSet *contentTypes = [NSMutableSet setWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager POST:url parameters:parameters constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
    [[self getNetworkQueue]addObject:operation];
}

+ (void)executePostWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    NSLog(@"Executing post request for %@",url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            //      NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        operation = [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure %@ - %@", operation, error);
            [[self getNetworkQueue]removeObject:operation];
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
    [[self getNetworkQueue]addObject:operation];
}

+ (void)executePutWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        operation = [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = [[responseObject objectForKey:@"success"] isEqual:@YES];
            success(operation, responseObject, apiSuccess);
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
    [[self getNetworkQueue]addObject:operation];
}


+ (void)executeGetWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    // if failure is nil then its an indication to handle it with default flow that is showing message
    // in alert dialog
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                @try {
                    if(failure)
                        failure(operation, error);
                    [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
                }
                @catch (NSException *exception) {
                    NSLog(@"exception handling timeout %@",exception);
                }
            }
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        operation = [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                @try {
                    if(failure)
                        failure(operation, error);
                    [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
                }
                @catch (NSException *exception) {
                    NSLog(@"exception handling timeout %@",exception);
                }
            }
        }];
    }
    [[self getNetworkQueue]addObject:operation];
}

+ (void)executePatchWithUrl:(NSString *)url andParameters:(NSDictionary *)parameters andHeaders:(NSDictionary *)headers withSuccessHandler:(void (^)(AFHTTPRequestOperation *, id, bool))success withFailureHandler:(void (^)(AFHTTPRequestOperation *, NSError *))failure withLoadingViewOn:(UIView *)parentView {
    if(![self isDataConnectionAvailable]){
        NSLog(@"No data connection is available");
        [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
        failure(nil,[[NSError alloc]initWithDomain:@"Data connection not available" code:0 userInfo:@{}]);
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [[manager requestSerializer] setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // check if custom headers are present and add them
    if (headers != nil) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [[manager requestSerializer] setValue:obj forHTTPHeaderField:key];
        }];
    }
    AFHTTPRequestOperation *operation;
    if (parentView == nil) {
        operation = [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            bool apiSuccess = YES;
            success(operation, responseObject, apiSuccess);
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
        [hud setLabelText:@"Loading"];
        operation = [manager PATCH:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [[self getNetworkQueue]removeObject:operation];
            NSLog(@"success %@ - %@", operation, responseObject);
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            bool apiSuccess = [[responseObject objectForKey:@"success"] isEqual:@YES];
            success(operation, responseObject, apiSuccess);
        }    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[self getNetworkQueue]removeObject:operation];
            [MBProgressHUD hideAllHUDsForView:parentView animated:YES];
            NSLog(@"failure %@ - %@", operation, error);
            if(![operation isEqual:nil] & ![error isEqual:nil]){
                failure(operation, error);
            }
        }];
    }
    [[self getNetworkQueue]addObject:operation];
}

#warning This function is not working as expected
+ (BOOL)isDataConnectionAvailable {
    return [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
}

@end
