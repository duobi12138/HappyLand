//
//  RegisterViewController.m
//  HappyOnline
//
//  Created by 多比 on 2025/3/26.
//

#import "RegisterViewController.h"
//#import "UserManager.h"
#import "NetworkManager.h"
#import <Masonry/Masonry.h>
#import "NSString+Regex.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) NSTimer *countdownTimer;
@property (nonatomic, assign) NSInteger countdownSeconds;

//@property (nonatomic, strong) UITextField *nicknameField;
//@property (nonatomic, strong) UITextField *accountField;
//@property (nonatomic, strong) UITextField *passwordField;
//
//@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *backgroundImage = [UIImage imageNamed:@"image2_1.png"];
    if (!backgroundImage) {
        NSLog(@"图片加载失败！请检查名称和资源是否存在");
    }
    // 获取视图的图层
    CALayer *layer = self.view.layer;
    // 设置图层的内容为图片
    layer.contents = (id)backgroundImage.CGImage;
    // 设置图层的内容模式
    layer.contentsGravity = kCAGravityResizeAspectFill;
    
    self.title = @"注册新用户";
    
    [self setupRegisterUI];
    
    //    // 添加关闭按钮
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    // Do any additional setup after loading the view.
}

- (void)setupRegisterUI {
    // 昵称输入框
    self.nicknameTextField = [[UITextField alloc] init];
    self.nicknameTextField.placeholder = @"请输入昵称(2～6个汉字或字母)";
    self.nicknameTextField.returnKeyType = UIReturnKeyNext;
    self.nicknameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.nicknameTextField];
    
    // 昵称提示标签
    self.nicknameTipLabel = [self createTipLabel];
    [self.view addSubview:self.nicknameTipLabel];
    
    // ID输入框
//    self.userIDTextField = [[UITextField alloc] init];
//    self.userIDTextField.placeholder = @"请输入8位数字ID";
//    self.userIDTextField.returnKeyType = UIReturnKeyNext;
//    self.userIDTextField.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:self.userIDTextField];
    
    // ID提示标签
//    self.userIDTipLabel = [self createTipLabel];
//    [self.view addSubview:self.userIDTipLabel];
    
    // 密码输入框
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"请输入数字、字母混合密码";
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.passwordTextField];
    
    // 密码提示标签
    self.passwordTipLabel = [self createTipLabel];
    [self.view addSubview:self.passwordTipLabel];
    
    // 邮箱输入框
    self.emailTextField = [[UITextField alloc] init];
    self.emailTextField.placeholder = @"请输入邮箱";
    self.emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.emailTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.emailTextField];
    
    // 验证码输入框
    self.verificationCodeTextField = [[UITextField alloc] init];
    self.verificationCodeTextField.placeholder = @"请输入验证码";
    self.verificationCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.verificationCodeTextField];

    // 发送验证码按钮
    self.sendCodeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.sendCodeButton.tintColor = [UIColor whiteColor];
    [self.sendCodeButton addTarget:self action:@selector(sendVerificationCodeTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendCodeButton];
    
    //倒计时标签
    self.countdownLabel = [[UILabel alloc] init];
    self.countdownLabel.textColor = [UIColor grayColor];
    self.countdownLabel.font = [UIFont systemFontOfSize:14];
    self.countdownLabel.hidden = YES;
    [self.view addSubview:self.countdownLabel];
    
    //注册按钮
    self.registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registerButton.tintColor = [UIColor whiteColor];
    [self.registerButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    self.registerButton.layer.cornerRadius = 5;
    [self.registerButton addTarget:self action:@selector(registerButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
    //布局
    [self.nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(100);
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.height.equalTo(@50);
    }];
    
    [self.nicknameTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameTextField.mas_bottom).offset(5);
        make.right.left.equalTo(self.nicknameTextField);
    }];
    
//    [self.userIDTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.nicknameTipLabel.mas_bottom).offset(10);
//        make.left.right.height.equalTo(self.nicknameTextField);
//    }];
    
//    [self.userIDTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.userIDTextField.mas_bottom).offset(5);
//        make.left.right.equalTo(self.userIDTextField);
//    }];
//    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nicknameTipLabel.mas_bottom).offset(10);
            make.left.right.height.equalTo(self.nicknameTextField);
    }];
    
    [self.passwordTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(5);
        make.left.right.equalTo(self.passwordTextField);
    }];
    
    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTipLabel.mas_bottom).offset(10);
        make.left.right.height.equalTo(self.nicknameTextField);
    }];
    
    [self.verificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emailTextField.mas_bottom).offset(15);
        make.left.equalTo(self.nicknameTextField);
        make.height.equalTo(@40);
    }];
    
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.verificationCodeTextField);
        make.left.equalTo(self.verificationCodeTextField.mas_right).offset(10);
        make.right.equalTo(self.nicknameTextField);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
    
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sendCodeButton);
        make.right.equalTo(self.sendCodeButton);
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationCodeTextField.mas_bottom).offset(30);
        make.left.right.equalTo(self.nicknameTextField);
        make.height.equalTo(@45);
    }];
    
    // 设置文本输入框代理
    self.nicknameTextField.delegate = self;
//    self.userIDTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.verificationCodeTextField.delegate = self;
    
    // 添加编辑变化监听
    [self.nicknameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self.userIDTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.emailTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.verificationCodeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 初始状态
    self.registerButton.enabled = NO;
    self.registerButton.alpha = 0.5;
    self.sendCodeButton.enabled = NO;
}

- (UITextField *)createTextFieldWithPlaceholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

- (UILabel *)createTipLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor redColor];
    label.hidden = YES;
    return label;
}

//- (void)registerButtonTapped {
    
//}

//- (void)sendVerificationCodeTapped {
    
//}

//    //昵称输入框
//    self.nicknameField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, 300, 40)];
//    self.nicknameField.placeholder = @"请输入昵称(不超过6个字)";
//    self.nicknameField.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:self.nicknameField];
//
//    //账号输入框
//    self.accountField = [[UITextField alloc] initWithFrame:CGRectMake(30, 160, 300, 40)];
//    self.accountField.placeholder = @"请输入8位数字账号";
//    self.accountField.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:self.accountField];
//
//    //密码输入框
//    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(30, 220, 300, 40)];
//    self.passwordField.placeholder = @"请输入字母数字混和密码";
//    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
//    [self.view addSubview:self.passwordField];
//
//    //注册按钮
//    self.registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    _registerBtn.frame = CGRectMake(30, 300, 300, 44);
//    [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
//    [_registerBtn setBackgroundColor:[UIColor systemBlueColor]];
//    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _registerBtn.layer.cornerRadius = 5;
//    [_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_registerBtn];
//}

#pragma mark - 验证码发送与倒计时
- (IBAction)sendVerificationCodeTapped:(id)sender {
    NSString *email = self.emailTextField.text;
    
    if (![self isValidEmail:email]) {
        [self showAlertWithTitle:@"错误" message:@"请输入有效的邮箱地址"];
        return;
    }
    
    // 禁用发送按钮并开始倒计时
    self.sendCodeButton.enabled = NO;
    [self startCountdown];
    
    // 发送验证码请求
    // 显示加载状态
//    [self showLoadingIndicator];

    [[NetworkManager sharedManager] sendVerificationCodeToEmail:email completion:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{            
            if (error) {
                // 网络错误处理
                NSString *errorMessage;
                switch (error.code) {
                    case NSURLErrorTimedOut:
                        errorMessage = @"请求超时，请检查网络";
                        break;
                    case NSURLErrorNotConnectedToInternet:
                        errorMessage = @"网络连接不可用";
                        break;
                    default:
                        errorMessage = error.localizedDescription ?: @"发送验证码失败";
                        break;
                }
                [self showAlertWithTitle:@"发送失败" message:errorMessage];
                [self resetCountdown];
                return;
            }
            
            // 业务错误处理
            if (![response isKindOfClass:[NSDictionary class]]) {
                [self showAlertWithTitle:@"发送失败" message:@"服务器返回数据异常"];
                [self resetCountdown];
                return;
            }
            
            if ([response[@"success"] boolValue]) {
                [self showAlertWithTitle:@"发送成功" message:@"验证码已发送到您的邮箱"];
                [self startCountdown]; // 开始倒计时
            } else {
                NSString *errorMsg = response[@"message"] ?: @"未知错误";
                [self showAlertWithTitle:@"发送失败" message:errorMsg];
                [self resetCountdown];
            }
        });
    }];
}

- (void)startCountdown {
    self.countdownSeconds = 60;
    self.countdownLabel.hidden = NO;
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld秒后重试", (long)self.countdownSeconds];
    
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
}

- (void)updateCountdown {
    self.countdownSeconds--;
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld秒后重试", (long)self.countdownSeconds];
    
    if (self.countdownSeconds <= 0) {
        [self resetCountdown];
    }
}

- (void)resetCountdown {
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
    self.countdownLabel.hidden = YES;
    self.sendCodeButton.enabled = [self isValidEmail:self.emailTextField.text];
}

#pragma mark - 用户注册

- (IBAction)registerButtonTapped:(id)sender {
    NSString *nickname = self.nicknameTextField.text;
    NSString *userID = self.userIDTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *email = self.emailTextField.text;
    NSString *verificationCode = self.verificationCodeTextField.text;
    
    [[NetworkManager sharedManager] registerWithNickname:nickname password:password email:email code:verificationCode completion:^(NSDictionary * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self showAlertWithTitle:@"注册失败" message:error.localizedDescription];
                return;
            }
            
            if ([response[@"success"] boolValue]) {
                [self showAlertWithTitle:@"注册成功" message:@"请使用您的账号登录" completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [self showAlertWithTitle:@"注册失败" message:response[@"message"] ?: @"未知错误"];
            }
        });
    }];
}

#pragma mark - 表单验证

- (void)textFieldDidChange:(UITextField *)textField {
    [self validateForm];
}

- (void)validateForm {
    BOOL nicknameValid = self.nicknameTextField.text.length >= 2;
    BOOL userIDValid = [self.userIDTextField.text matchesRegex:@"^\\d{8}$"];
    BOOL passwordValid = self.passwordTextField.text.length >= 6;
    BOOL emailValid = [self isValidEmail:self.emailTextField.text];
    BOOL codeValid = self.verificationCodeTextField.text.length >= 4;
    
    self.sendCodeButton.enabled = emailValid && (self.countdownTimer == nil);
    self.registerButton.enabled = nicknameValid && userIDValid && passwordValid && emailValid && codeValid;
}

- (BOOL)isValidEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - 辅助方法

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self showAlertWithTitle:title message:message completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message completion:(void(^)(void))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completion) completion();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nicknameTextField) {
        [self.userIDTextField becomeFirstResponder];
    } else if (textField == self.userIDTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.verificationCodeTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        if (self.registerButton.enabled) {
            [self registerButtonTapped:nil];
        }
    }
    return YES;
}

//- (void)registerAction {
//    //验证输入
//    if (self.nicknameField.text.length == 0 || self.accountField.text.length == 0 || self.passwordField.text.length == 0) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写完整信息" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"用户点击了确定按钮");
//        }];
//        [alertController addAction:okAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//        return;
//    }
//    if (self.nicknameField.text.length > 6) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"昵称不能超过六个字" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"用户点击了确定按钮");
//        }];
//        [alertController addAction:okAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//        return;
//    }
//    if (self.accountField.text.length != 8 || ![self isAllNumber:self.accountField.text]) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"账号必须为8位数字" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"用户点击了确定按钮");
//        }];
//        [alertController addAction:okAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//        return;
//    }
//    if (![self isAlphaNumeric:self.passwordField.text]) {
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码必须为数字和字母混合" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"用户点击了确定按钮");
//        }];
//        [alertController addAction:okAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//        return;
//    }
//    if ([[UserManager shared] getUserByAccount:self.accountField.text]) {
//        
//        return;
//    }
//    
//    //创建新用户
//    User *newUser = [[User alloc] init];
//    newUser.nickname = self.nicknameField.text;
//    newUser.account = self.accountField.text;
//    newUser.password = self.passwordField.text;
//    
//    //保存用户
//    [[UserManager shared] addUser:newUser];
//    
//    //回调代理
//    if ([self.delegate respondsToSelector:@selector(didRegisterSuccessfullyWithUser:)]) {
//        [self.delegate didRegisterSuccessfullyWithUser:newUser];
//    }
//    [self dismiss];
//}

//- (void)dismiss {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (BOOL)isAllNumber:(NSString *)str {
//    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
//    return [str rangeOfCharacterFromSet:notDigits].location == NSNotFound;
//}
//
//- (BOOL)isAlphaNumeric:(NSString *)str {
//    NSCharacterSet *alphaNumericSet = [NSCharacterSet characterSetWithCharactersInString:
//                                      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"];
//    NSCharacterSet *inputSet = [NSCharacterSet characterSetWithCharactersInString:str];
//    return [alphaNumericSet isSupersetOfSet:inputSet];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
