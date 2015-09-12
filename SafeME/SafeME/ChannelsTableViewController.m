//
//  ChannelsTableViewController.m
//  Kaizen
//
//  Created by Ponnie Rohith on 28/03/15.
//  Copyright (c) 2015 PR. All rights reserved.
//

#import "ChannelsTableViewController.h"
#import "ServiceChatsViewController.h"
#import "Message.h"
@interface ChannelsTableViewController ()

@end

@implementation ChannelsTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.channels = [NSArray arrayWithObjects:@"Travel", nil];
    self.title = @"Servon";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:70/255.f green:135/255.f blue:256/255.f alpha:1.0]}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.channels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.imageView.image = [UIImage imageNamed:@"taxi.png"];
    cell.imageView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y  - 10, cell.imageView.image.size.width, cell.imageView.image.size.height - 20);
    cell.textLabel.text = self.channels[indexPath.row];
    return cell;
 
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Channel channel = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ServiceChatsViewController *service = [[ServiceChatsViewController alloc]initWithChannel:channel];
    NSManagedObjectContext *context;
    switch (channel) {
        case DriveChannel:
            context = self.driveManagedObjectContext;
            break;
    }
    service.managedObjectContext = context;
    [self.navigationController pushViewController:service animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
@end
