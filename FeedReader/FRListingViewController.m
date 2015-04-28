//
//  FRViewController.m
//  FeedReader
//
//  Created by Salil Wadnerkar on 23/4/13.
//  Copyright (c) 2013 Salil Wadnerkar. All rights reserved.
//

#import "FRListingViewController.h"
#import "FRCell.h"
#import "KMXMLParser.h"
#import "FRArticleViewController.h"
#import "FeedManager.h"
#import "DataManager.h"
#import "Feed.h"

@interface FRListingViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@end

@implementation FRListingViewController
@synthesize loadingView = _loadingView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:@"updateUI"
                                               object:nil];
    if ([[DataManager sharedInstance] deleteAllFeeds]) {
        [self addLoadingView];
        [[FeedManager sharedInstance] getAllFeeds];
    }
}

-(void)addLoadingView
{
    if (_loadingView == nil) {
        _loadingView = [[UIAlertView alloc] initWithTitle:@"Please wait..."
                                                  message:@"Please wait untill we are getting lastest updates for you"
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:nil];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        // Adjust the indicator so it is up a few pixels from the bottom of the alert
        /*indicator.center = CGPointMake(_loadingView.bounds.size.width / 2,
                                       _loadingView.bounds.size.height - 70);*/
        
        indicator.frame=CGRectMake(_loadingView.frame.size.width/2 - indicator.frame.size.width,
                                   _loadingView.frame.size.height - indicator.frame.size.height*2,
                                   indicator.frame.size.width,
                                   indicator.frame.size.height);
        [indicator startAnimating];
        [_loadingView addSubview:indicator];
    }
  
    [_loadingView show];
}

-(void)removeLoadingView
{
    [_loadingView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshData:(NSNotification *) notification
{
    NSLog(@"Update UI");
    [self removeLoadingView];
    _parseResults = [[DataManager sharedInstance] readAllFeeds];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_parseResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"feedCell";
    FRCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Feed *item = [self.parseResults objectAtIndex:[indexPath row]];
    
    cell.title.text = item.title; //[item objectForKey:@"title"];
    [cell.title sizeToFit];
    
    cell.description.text =  [NSString stringWithFormat:@"%@: %@",
                              [NSDateFormatter localizedStringFromDate:item.pubDate
                                                             dateStyle:NSDateFormatterShortStyle
                                                             timeStyle:NSDateFormatterShortStyle],
                              item.feed_description];
//    NSString *url = item.thumbnail; //[item objectForKey:@"thumbnail"];
//    
//    if (url != NULL) {
//        NSLog(@"Downloading image from URL %@", url);
//        cell.thumbnail.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
//    }

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"Article"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Feed *item = [self.parseResults objectAtIndex:[indexPath row]];
        NSString *url =  item.link;//[item objectForKey:@"link"];
        FRArticleViewController *articleViewController = (FRArticleViewController*)segue.destinationViewController;
        articleViewController.url = url;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
