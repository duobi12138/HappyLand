//
//  LoginViewController.m
//  HappyOnline
//
//  Created by 多比 on 2025/3/26.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "NetworkManager.h"
#import "HomeViewController.h"
#import "MainViewController.h"
#import "UserManager.h"
#import "NSString+Regex.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"image2_1.png"];
    // 获取视图的图层
    CALayer *layer = self.view.layer;
    // 设置图层的内容为图片
    layer.contents = (id)backgroundImage.CGImage;
    // 设置图层的内容模式
    layer.contentsGravity = kCAGravityResizeAspectFill;
    
    [self setupLoginUI];
  
//    //自动填充上次登录的账号
//    NSString *lastAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginAccount"];
    // Do any additional setup after loading the view.
}

- (void)setupLoginUI {
    self.loginButton.enabled = NO;
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordTextField.secureTextEntry = YES;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    [self.emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//}
//    NSURL *url = [NSURL URLWithString:@"http://192.168.194.32:8082/api/v1/login"];
//    // 昵称输入框
//    self.nicknameField = [[UITextField alloc] initWithFrame:CGRectMake(50, 150, 250, 40)];
//    self.nicknameField.placeholder = @"请输入昵称（不多于六个字）";
//    self.nicknameField.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:self.nicknameField];

    // 账号输入框
    self.accountField = [[UITextField alloc] initWithFrame:CGRectMake(50, 210, 250, 40)];
    self.accountField.placeholder = @"请输入8位数字账号";
    self.accountField.keyboardType = UIKeyboardTypeNumberPad;
    self.accountField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.accountField];

    // 密码输入框
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(50, 270, 250, 40)];
    self.passwordField.placeholder = @"请输入数字、字母混合密码";
    self.passwordField.secureTextEntry = YES;
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.passwordField];

    // 登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    loginBtn.frame = CGRectMake(50, 350, 100, 44);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.tintColor = [UIColor whiteColor];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];

    // 注册按钮
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame = CGRectMake(200, 350, 100, 44);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    registerBtn.tintColor = [UIColor whiteColor];
    [registerBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [registerBtn addTarget:self action:@selector(showRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

#pragma mark - 用户登录

- (IBAction)loginButtonTapped:(id)sender {
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [[NetworkManager sharedManager] loginWithEmail:email
                                         password:password
                                       completion:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self showAlertWithTitle:@"登录失败" message:error.localizedDescription];
                return;
            }
            
            if ([response[@"success"] boolValue]) {
                // 保存用户token和信息
                [self saveUserInfo:response];
                // 跳转到主界面
                MainViewController *mainVC = [[MainViewController alloc] init];
                mainVC.navigationItem.hidesBackButton = YES;
                [self.navigationController setNavigationBarHidden:YES animated:NO];
                [self.navigationController pushViewController:mainVC animated:YES];
//                [self navigateToMainScreen];
            } else {
                [self showAlertWithTitle:@"登录失败" message:response[@"message"] ?: @"未知错误"];
            }
        });
    }];
}

- (void)saveUserInfo:(NSDictionary *)response {
    // 保存认证token
    NSString *token = response[@"token"];
    if (token) {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"AuthToken"];
    }
    
    // 保存用户信息
    NSDictionary *userInfo = response[@"user"];
    if (userInfo) {
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"UserInfo"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 表单验证

- (void)textFieldDidChange:(UITextField *)textField {
    [self validateForm];
}

- (void)validateForm {
    BOOL emailValid = [self isValidEmail:self.emailTextField.text];
    BOOL passwordValid = self.passwordTextField.text.length >= 6;
    
    self.loginButton.enabled = emailValid && passwordValid;
}

- (BOOL)isValidEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - 辅助方法

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        if (self.loginButton.enabled) {
            [self loginButtonTapped:nil];
        }
    }
    return YES;
}

#pragma mark - 按钮动作
- (void)loginAction {
    //验证输入
    if (![self validateInput])
    {
        return;
    }
    //检查用户是否存在
    User *user = [[UserManager shared] getUserByAccount:self.accountField.text];
    if (!user || ![user.password isEqualToString:self.passwordField.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号或密码不正确" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"用户点击了确定按钮");
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.accountField.text forKey:@"lastLoginAccount"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"恭喜你！登录成功！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        MainViewController *mainVC = [[MainViewController alloc] init];
        mainVC.navigationItem.hidesBackButton = YES;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.navigationController pushViewController:mainVC animated:YES];
        
//        HomeViewController *nextVC = [[HomeViewController alloc] init];
//        [self.navigationController pushViewController:nextVC animated:YES];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 验证输入
- (BOOL)validateInput {
    if (self.nicknameField.text.length > 6) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"昵称不能超过六个字" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"用户点击了确定按钮");
        }];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    if (self.accountField.text.length != 8 || ![self isAllNumber:self.accountField.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号必须为8位数字" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"用户点击了确定按钮");
        }];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    if (![self isAlphaNumeric:self.passwordField.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码必须为数字和字母混合" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"用户点击了确定按钮");
        }];
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (BOOL)isAllNumber:(NSString *)str {
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return [str rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

- (BOOL)isAlphaNumeric:(NSString *)str {
    NSCharacterSet *alphaNumericSet = [NSCharacterSet characterSetWithCharactersInString:
                                      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"];
    NSCharacterSet *inputSet = [NSCharacterSet characterSetWithCharactersInString:str];
    return [alphaNumericSet isSupersetOfSet:inputSet];
}

#pragma mark - RegisterViewControllerDelegate
- (void)didRegisterSuccessfullyWithUser:(User *)user {
    self.nicknameField.text = user.nickname;
    self.accountField.text = user.account;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showRegister {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self presentViewController:registerVC animated:YES completion:nil];
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
