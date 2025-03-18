//
//  ProfileViewController.m
//  HappyOnline
//
//  Created by 多比 on 2025/3/12.
//

#import "ProfileViewController.h"
#import "ProfileView.h"

@interface ProfileViewController ()

//@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.itemSize = CGSizeMake(WIDTH / 2 - 10, 3 * WIDTH / 2 - 10);
//    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
//    
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//    [self.view addSubview:_collectionView];
    
    ProfileView *profileView = [[ProfileView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:profileView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
