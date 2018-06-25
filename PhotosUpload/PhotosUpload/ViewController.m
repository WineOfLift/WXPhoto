//
//  ViewController.m
//  PhotosUpload
//
//  Created by apple001 on 2018/6/25.
//  Copyright © 2018年 HJTech. All rights reserved.
//

#import "ViewController.h"
#import "WPhotoViewController.h"
#import "ManagerTool.h"
#import <UIImageView+WebCache.h>

#define ImageUrl @"http://121.40.188.122:8101/"
#define phoneScale [UIScreen mainScreen].bounds.size.width/720.0

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIButton *_addBut;
    UITableView *_tableView;
    NSMutableArray *_photosArr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _photosArr = [NSMutableArray  array];
    [self createTableView];
    
    _addBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBut.frame = CGRectMake((self.view.frame.size.width-160*phoneScale)/2, self.view.frame.size.height-(60+160)*phoneScale, 160*phoneScale, 160*phoneScale);
    _addBut.layer.cornerRadius = 160*phoneScale/2;
    _addBut.layer.masksToBounds = YES;
    [_addBut setImage:[UIImage imageNamed:@"1.2.1-CreateNew"] forState:UIControlStateNormal];
    [_addBut addTarget:self action:@selector(addButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addBut];
    
}

-(void)addButClick
{
    WPhotoViewController *WphotoVC = [[WPhotoViewController alloc] init];
    //选择图片的最大数
    WphotoVC.selectPhotoOfMax = 8;
    [WphotoVC setSelectPhotosBack:^(NSMutableArray *phostsArr) {
        
        NSMutableArray * dataImageArr = [NSMutableArray  array];
        for (int i=0; i<phostsArr.count; i++) {
            
            NSDictionary * imageDic =  phostsArr[i];
            UIImage * image = imageDic[@"image"];
            //图片
            NSData *photoData=UIImageJPEGRepresentation(image,0.0001);
            [dataImageArr  addObject:photoData];
        }
        
        [ManagerTool  updatePhotos:dataImageArr block:^(NSDictionary *  receiveDic) {
            NSArray * receiveArr = receiveDic[@"picUrl"];
            for (NSString * picUrl in receiveArr) {
                [_photosArr addObject:picUrl];
                [_tableView reloadData];
            }
            //            int code=[receiveDic[@"code"]intValue];
            //            if(code!=100){
            //                NSString *message=receiveDic[@"message"];
            //                [Manager alert:message view:self.view];
            //                return ;
            //            }
            //            //将返回的图片路径添加到图片数组中
            //            NSString *imageUrl=[NSString stringWithFormat:@"%@",receiveDic[@"url"]];
            //            [_photosArr addObject:imageUrl];
            //            [Manager alert:@"上传成功" view:self.view];
            //            [_tableView reloadData];
            
        } fail:^{
            NSLog(@"发挥失败");
        }];
    }];
    [self presentViewController:WphotoVC animated:YES completion:nil];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _photosArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"cellId%ld", (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat photoSize = [UIScreen mainScreen].bounds.size.width - 20;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(10, 10, photoSize, photoSize);
    imageView.backgroundColor = [UIColor  redColor];
    [imageView sd_setImageWithURL:[NSURL  URLWithString:[NSString  stringWithFormat:@"%@%@",ImageUrl,_photosArr[indexPath.row]]] placeholderImage:[UIImage  imageNamed:@""]];
    //    imageView.image = [[_photosArr objectAtIndex:indexPath.row] objectForKey:@"image"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    [cell addSubview:imageView];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.width;
}
@end
