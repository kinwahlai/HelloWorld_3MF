//
//  ViewController.m
//  HelloWorld_3MF
//
//  Created by kazaana_developer on 3/24/13.
//  Copyright (c) 2013 kinwah. All rights reserved.
//

#import "ViewController.h"
#import "TMFKeyValueCommand.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *responseReceived;
@property (strong,nonatomic) TMFConnector *connector;
@property (strong, nonatomic) TMFKeyValueCommand *kvCmd;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.connector = [TMFConnector new];
    
    // as a provider, you publish the command that app can provide :)
    self.kvCmd = [TMFKeyValueCommand new];
    [self.connector publishCommand:self.kvCmd];
    
    // at the same time you also subscribe to the same command provided by others.
    [self.connector startDiscoveryWithCapabilities:@[ [TMFKeyValueCommand name] ] delegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connector:(TMFConnector *)tmf didChangeDiscoveringPeer:(TMFPeer *)peer forChangeType:(TMFPeerChangeType)type
{
    if(type == TMFPeerChangeFound) {
        [self.connector subscribe:[TMFKeyValueCommand class] peer:peer receive:^(id arguments, TMFPeer *peer) {
            TMFKeyValueCommandArguments *tmfKVArgument = (TMFKeyValueCommandArguments*)arguments;
            _responseReceived.text = tmfKVArgument.value;
        } completion:^(NSError *error) {
            if(error) { // handle error
                NSLog(@"%@", error);
            }
        }];
    }
}

- (IBAction)publishButton:(id)sender
{
    TMFKeyValueCommandArguments *kvArguments = [TMFKeyValueCommandArguments new];
    kvArguments.key = @"msg";
    kvArguments.value = [NSString stringWithFormat:@"Hello! I'm %@",[[UIDevice currentDevice] name]];
    [self.kvCmd sendWithArguments:kvArguments];
}

@end
