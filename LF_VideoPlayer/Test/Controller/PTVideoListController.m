//
//  PTVideoListController.m
//  PTApp
//
//  Created by 王林芳 on 2018/4/19.
//  Copyright © 2018年 王林芳. All rights reserved.
//

#import "PTVideoListController.h"
#import "LFVideoPlayer.h"
#import "PTVideoListCell.h"
#import "PTVideoListModel.h"
#import "PTVideoDetailController.h"
@interface PTVideoListController ()<PTVideoListCellDelegate>
@property (nonatomic, strong) UITableView *tableview_list;
@property (nonatomic, strong) NSMutableArray *arr_dataSource;
@property (nonatomic, strong) PTVideoListCell *cell_playing;
@property (nonatomic, strong) LFVideoPlayer *player;
@end

@implementation PTVideoListController
{
    BOOL isFullScreen;
}
- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}
- (void)createUI{
    [self.view addSubview:self.tableview_list];
//    [self prefersStatusBarHidden];
}
#pragma mark--懒加载
- (UITableView *)tableview_list{
    if(!_tableview_list){
        _tableview_list = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,PTScreenWidth , PTScreenHeight) style:UITableViewStylePlain];
        _tableview_list.delegate = self;
        _tableview_list.dataSource = self;
        _tableview_list.separatorColor = [UIColor clearColor];
        _tableview_list.tableFooterView = [[UIView alloc]init];
    }
    return _tableview_list;
}
- (NSMutableArray *)arr_dataSource{
    if(!_arr_dataSource){
        _arr_dataSource = [[NSMutableArray alloc]init];
        NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Data" ofType:@"json"]];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        _arr_dataSource = [PTVideoListModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _arr_dataSource;
}
#pragma mark-- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr_dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cell";
    PTVideoListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell){
        cell = [[PTVideoListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    [cell setModel:self.arr_dataSource[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PTScreenWidth / 116.0 * 90 + 50;
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_cell_playing isEqual:cell]){
        [_player removeFromSuperview];
        _player = nil;
        _cell_playing = nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PTVideoListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setModel:self.arr_dataSource[indexPath.row]];
    [self lf_tablViewCellPlayVideoWithCell:cell];
}
#pragma mark-- 点击播放视频的cell
- (void)lf_tablViewCellPlayVideoWithCell:(PTVideoListCell *)cell{
    if([_cell_playing isEqual:cell]){
        return;//避免重复播放
    }
    _cell_playing = cell;
    // 销毁播放器
    [_player removeFromSuperview];
    _player = nil;
    NSIndexPath *indexPath = [self.tableview_list indexPathForCell:cell];
    PTVideoListModel *model = self.arr_dataSource[indexPath.row];
    _player = [[LFVideoPlayer alloc]init];
    _player.frame = CGRectMake(0, 0, PTScreenWidth, PTScreenWidth / 116.0 * 90);
    _player.mediaURL = [NSURL URLWithString:model.videoUrl];
    _player.isPlayImmdiately = YES;
    _player.isHideReturnBtn = YES;
    [_player showInView:cell.contentView];
}
#pragma mark-- PTVideoListCellDelegate
- (void)showVideoDetailForCell:(id)cell{
    [self lf_tablViewCellPlayVideoWithCell:cell];
    PTVideoDetailController *vc = [[PTVideoDetailController alloc]init];
    vc.view_playerFather = self.cell_playing.contentView;
    vc.player = self.player;
    [vc.view addSubview:self.player];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
