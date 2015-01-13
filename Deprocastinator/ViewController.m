//
//  ViewController.m
//  Deprocrastinator
//
//  Created by Gabriel Borri de Azevedo on 1/12/15.
//  Copyright (c) 2015 Gabriel Enterprises. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property BOOL deleteButton;
@property NSIndexPath *alertViewIndexPath;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [NSMutableArray arrayWithObjects:
                  @"1",
                  @"2",
                  @"3",
                  @"4",
                  nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.editButton.title isEqualToString:@"Done"])
    {
        [self removeCell:cell];
    }
    else
    {
        cell.textLabel.textColor = [UIColor greenColor];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [UIAlertView new];
    alert.delegate = self;
    [alert addButtonWithTitle:@"Delete"];
    [alert addButtonWithTitle:@"CANCEL"];
    alert.title = @"Are you sure you want to delete this row ?";
    self.alertViewIndexPath = indexPath;
    [alert show];

}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *stringToMove = self.array[sourceIndexPath.row];
    [self.array removeObjectAtIndex:sourceIndexPath.row];
    [self.array insertObject:stringToMove atIndex:destinationIndexPath.row];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.array removeObjectAtIndex:self.alertViewIndexPath.row];

        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[self.alertViewIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    [self.tableView reloadData];
}



- (IBAction)onAddButtonPressed:(UIButton *)sender
{
    UIAlertView *addAlert = [UIAlertView new];
    addAlert.title = @"Enter a text!";
    [addAlert addButtonWithTitle:@"Dismiss"];
    if (![self.textField.text isEqualToString:[NSString stringWithFormat:@""]])
    {
        NSLog(@"%@",self.textField.text);
        [self.array addObject:self.textField.text];
        NSLog(@"%@",self.array.description);
        self.textField.text = @"";
        [self.tableView reloadData];
    }
    else
    {
        [addAlert show];
    }
    [self.textField resignFirstResponder];
}

- (IBAction)onEditButtonTapped:(UIBarButtonItem *)sender
{
    if (self.editing)
    {
        self.editing = false;
        [self.tableView setEditing:false animated:true];
        sender.style = UIBarButtonItemStylePlain;
        sender.title = @"Edit";    }
    else
    {
        self.editing = true;
        [self.tableView setEditing:true animated:true];
        sender.style = UIBarButtonItemStyleDone;
        self.editButton.title = @"Done";
    }
}

-(void)removeCell:(UITableViewCell *)cell
{
    [self.array removeObject:cell.textLabel.text];
    [self.tableView reloadData];
}



@end
