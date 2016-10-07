//
//  CLTopicVoiceView.m
//  百思不得姐
//
//  Created by 杨博兴 on 16/10/5.
//  Copyright © 2016年 xx_cc. All rights reserved.
//

#import "CLTopicVoiceView.h"
#import "CLTopic.h"
#import <UIImageView+WebCache.h>


@interface CLTopicVoiceView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;

@end

@implementation CLTopicVoiceView

-(void)awakeFromNib
{
    // 从xib中加载进来的控件的autoresizingMask默认是UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ,会自动将控件根据父控件进行伸缩
    self.autoresizingMask = UIViewAutoresizingNone;
}

-(void)setTopic:(CLTopic *)topic
{
    _topic = topic;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    NSInteger minute = topic.voicetime / 60;
    NSInteger second = topic.voicetime % 60;
    
    self.voiceTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
    
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd次播放",topic.playcount];
    
}

@end
