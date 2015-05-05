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
#import "CustomIOSAlertView.h"

@interface FRListingViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) CustomIOSAlertView *alertView;
@end

@implementation FRListingViewController
//@synthesize loadingView = _loadingView;
@synthesize alertView = _alertView;
@synthesize parseResults = _parseResults;

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

    [self createLoadingView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:@"updateUI"
                                               object:nil];
    //if ([[DataManager sharedInstance] deleteAllFeeds]) {
        [self showLoadingView];
        [[FeedManager sharedInstance] getAllFeeds];
    //}
    
}

-(void)createLoadingView
{
    _alertView = [[CustomIOSAlertView alloc] init];
    
    UIView *dialog = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 130)];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10.f, dialog.frame.size.width, 24.f)];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    title.text = @"Please wait";
    
    [dialog addSubview:title];
    
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(15, 32.f, dialog.frame.size.width - 30, 44.f)];
    message.textAlignment = NSTextAlignmentCenter;
    message.numberOfLines = 0;
    message.font = [UIFont fontWithName:@"Helvetica" size:14.f];
    message.text = @"We are downloading the latest news for you...";
    
    [dialog addSubview:message];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    indicator.frame=CGRectMake(dialog.frame.size.width/2 - indicator.frame.size.width/2,
                               dialog.frame.size.height - indicator.frame.size.height*2,
                               indicator.frame.size.width,
                               indicator.frame.size.height);
    
    [indicator startAnimating];
    
    [dialog addSubview:indicator];
    
    
    // Add some custom content to the alert view
    [_alertView setContainerView:dialog];
    
    
    [_alertView setButtonTitles:[NSMutableArray arrayWithObjects: nil]];
    //[alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [_alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    
    [_alertView setUseMotionEffects:true];
    
    //[_alertView show];
}

-(void)showLoadingView
{
    [_alertView show];
}

-(void)removeLoadingView
{
    [_alertView close];
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
    //[_parseResults removeAllObjects];
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
    Feed *item = [_parseResults objectAtIndex:[indexPath row]];
    
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
        Feed *item = [_parseResults objectAtIndex:[indexPath row]];
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

- (IBAction)refreshClicked:(id)sender {
    [self showLoadingView];
    [[FeedManager sharedInstance] getAllFeeds];
}
@end
