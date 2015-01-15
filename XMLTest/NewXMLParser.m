//
//  NewXMLParser.m
//  XMLTest
//
//  Created by Wang Long on 1/15/15.
//  Copyright (c) 2015 Wang Long. All rights reserved.
//

#import "NewXMLParser.h"
#import "GDataXMLNode.h"

#import "AFNetworking.h"


@implementation NewXMLParser
{
    NSURL *_downloadFilePathURL;
}

- (NSString *)loadXMLFile
{
    return [[NSBundle mainBundle] pathForResource:@"products" ofType:@"xml"];
}

- (void)loadXMLFromServer
{
    NSString *urlString = @"http://omsmb.syslive.cn/qyhpmanage/mylistqyproduct_xml.ds";
    //NSURL *url = [NSURL URLWithString:urlString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //NSDictionary *parameter = @{@"user":self.managerTextField.text, @"password":self.passwordTextField.text};
    //NSLog(@"Parameter: %@", parameter);
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/xml"];
    
    [manager POST:urlString
       parameters:nil
          success:^(NSURLSessionDataTask *task, id responseObject) {
              
              NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
              NSLog(@"Response: %@", responseString);
          }failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"Error: %@", [error description]);
          }];
}

- (void)downloadXMLFromServer
{
    NSString *urlString = @"http://omsmb.syslive.cn/qyhpmanage/mylistqyproduct_xml.ds";
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/xml"];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        //NSData *xmlData = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        //NSString *xmlString = [NSString stringWithContentsOfFile:filePath usedEncoding:NSUTF8StringEncoding error:nil];
        //[NSThread sleepForTimeInterval:2];
        _downloadFilePathURL = filePath;
        //NSString *xmlString = [NSString stringWithContentsOfURL:filePath encoding:NSUTF8StringEncoding error:nil];
        //NSLog(@"xmlString: %@", xmlString);
        //NSLog(@"filePath: %@", _downloadFilePathURL);
        NSData *xmlData = [NSData dataWithContentsOfURL:_downloadFilePathURL];
        //NSLog(@"Data: %@", xmlData);
        
        const char* CString = (const char *)[xmlData bytes];
        
        NSLog(@"CString: %s", CString);
        NSString *str = [NSString stringWithCString:CString encoding:NSISOLatin1StringEncoding];
        
        NSLog(@"xmlString: %@", [NSString stringWithCString:[str UTF8String] encoding:NSUTF8StringEncoding]);
        
    }];
    [downloadTask resume];
}

- (void)getElement
{
    NSString *SKU;
    NSString *productName;
    NSString *brandCategory;
    NSString *productCategory;
    float     price;
    
    NSString *filePath = [self loadXMLFile];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if(doc == nil)
    {
        return;
    }
    
    NSArray *columnMembers;
    
    NSArray *dataMembers = [doc.rootElement elementsForName:@"data"];
    //NSArray *partyMembers = [doc nodesForXPath:@"//Party/Player" error:nil];

    for(GDataXMLElement *dataMember in dataMembers)
    {
        // Name
        NSArray *rows = [dataMember elementsForName:@"row"];
        if([rows count] > 0)
        {
            for(GDataXMLElement *row in rows)
            {
                columnMembers = [row elementsForName:@"column"];
                
                SKU = [(GDataXMLElement *)[columnMembers objectAtIndex:0] stringValue];
                productName = [(GDataXMLElement *)[columnMembers objectAtIndex:1] stringValue];
                brandCategory = [(GDataXMLElement *)[columnMembers objectAtIndex:2] stringValue];
                productCategory = [(GDataXMLElement *)[columnMembers objectAtIndex:3] stringValue];
                price = [[(GDataXMLElement *)[columnMembers objectAtIndex:4] stringValue] floatValue];
                
                NSLog(@"\n");
                NSLog(@"SKU: %@", SKU);
                NSLog(@"Product Name: %@", productName);
                NSLog(@"Brand Category: %@", brandCategory);
                NSLog(@"Product Category: %@", productCategory);
                NSLog(@"Price: %.2f", price);
            }
        } else {
            continue;
        }
    }
}

@end
