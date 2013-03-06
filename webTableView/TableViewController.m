//
//  TableViewController.m
//  webTableView
//
//  Created by NSCookbook on 3/4/13.
//  Copyright (c) 2013 NSCookbook. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "TableViewController.h"
#import "ViewController.h"
#import "AFNetworking.h"

@interface TableViewController ()

@end

@implementation TableViewController

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
    self.googlePlacesArrayFromAFNetworking = [[NSArray alloc] init];
    [self makeRestuarantsRequests];
}

#pragma mark - AFNetworking 

-(void)makeRestuarantsRequests{
    
    NSURL *url = [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=restuarants+in+sydney&sensor=false&key=Your Key"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject) {
                                                                                            self.googlePlacesArrayFromAFNetworking = [responseObject objectForKey:@"results"];
                                                                                            [self.tableView reloadData];
                                                                                        }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
                                                                                            NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                                                                        }];
    [operation start];
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
    return [self.googlePlacesArrayFromAFNetworking count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *tempDictionary= [self.googlePlacesArrayFromAFNetworking objectAtIndex:indexPath.row];
     
    cell.textLabel.text = [tempDictionary objectForKey:@"name"];
    
        if([tempDictionary objectForKey:@"rating"] != NULL)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Rating: %@ of 5",[tempDictionary objectForKey:@"rating"]];
        }   
        else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Not Rated"];
        }

    
    return cell;
}

#pragma mark - Prepare For Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    ViewController *detailViewController = (ViewController *)segue.destinationViewController;
    //set NSDictionary Item restuarantDetail in detailViewController
    detailViewController.restuarantDetail = [self.googlePlacesArrayFromAFNetworking objectAtIndex:indexPath.row];
}


@end
