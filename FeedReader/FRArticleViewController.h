//
//  FRArticleViewController.h
//  FeedReader
//
//  Created by Salil Wadnerkar on 10/5/13.
//  Copyright (c) 2013 Salil Wadnerkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRArticleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) NSString *url;
@end
