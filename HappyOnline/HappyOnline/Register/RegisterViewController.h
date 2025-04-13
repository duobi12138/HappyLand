//
//  RegisterViewController.h
//  HappyOnline
//
//  Created by 多比 on 2025/3/26.
//

#import <UIKit/UIKit.h>

//@class User;
//@protocol RegisterViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface RegisterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (strong, nonatomic) IBOutlet UITextField *userIDTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *verificationCodeTextField;

@property (strong, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;

@property (nonatomic, strong) UILabel *nicknameTipLabel;
@property (nonatomic, strong) UILabel *userIDTipLabel;
@property (nonatomic, strong) UILabel *passwordTipLabel;

//@property (nonatomic, weak)id<RegisterViewControllerDelegate> delegate;
//
//@end
//
//@protocol RegisterViewControllerDelegate <NSObject>
//
//- (void)didRegisterSuccessfullyWithUser:(User *)user;

@end

NS_ASSUME_NONNULL_END
