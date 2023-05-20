import SwiftUI
import Combine
import FirebaseAuth

private enum FocusableField: Hashable {
  case email
  case password
}

struct SignInView: View {
    @State var pushActive = false
    @FocusState private var focus: FocusableField?
    @Environment(\.presentationMode) var presentationMode
    @Binding var index: Int
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    
    init(index: Binding<Int>) {
        _index = index
    }
    
    var body: some View {
        VStack {
            // 이 상태에서 HomeView에는 state정보가 들어있을 것임
            // 여기에서 원천정보를 다시 설정해 주는게 맞다고 판단.
            NavigationLink(destination: HomeView(),
                           isActive: self.$pushActive) {
              EmptyView()
            }.hidden()
            
            VStack(alignment: .leading, spacing: 30) {
                // login image
                Image("Login")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxHeight: 400)
                
                Text("로그인")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .center, spacing: 30) {
                    VStack(alignment: .center, spacing: 25) {
                        HStack {
                            Image(systemName: "at")
                            TextField("Email", text: $signInViewModel.email)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .focused($focus, equals: .email)
                                .submitLabel(.next)
                                
                                .onSubmit {
                                    self.focus = .password
                                }
                        }
                        .padding(.bottom, 6)
                        .background(Divider(), alignment: .bottom)
                        
                        HStack {
                            Image(systemName: "lock")
                            SecureField("Password", text: $signInViewModel.password)
                                .focused($focus, equals: .password)
                                .submitLabel(.go)
                                .onSubmit {
                                    signInViewModel.login()
                                }
                         }
                         .padding(.vertical, 6)
                         .background(Divider(), alignment: .bottom)
                         .padding(.bottom, 8)
                    }.padding(.horizontal, 25)
                    
                    VStack(alignment: .center) {
                        Button(action: {
                            print(signInViewModel.email)
                            print(signInViewModel.password)
                            signInViewModel.login()
                        }) {
                            Text("로그인")
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                        }
                        
                        .disabled(!signInViewModel.isValid)
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                        .tint(Color(UIConfiguration.tintColor))
                        
                        HStack {
                            VStack { Divider() }
                            Text("OR")
                            VStack { Divider() }
                        }
                   
                        Button(action: {
                            Task {
                                await signInViewModel.googleLogin()
                            }
                        }) {
                            Text("구글 로그인")
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(alignment: .leading) {
                                    Image("google")
                                        .resizable()
                                        .frame(width: 35, alignment: .center)
                                }
                        }
                        .foregroundColor(.black)
                        .buttonStyle(.bordered)
                        
                    }
                    
                    HStack {
                            Text("아직 계정이 없으신가요?")
                            Button(action: {
                                self.index = 3
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                              Text("회원가입")
                                .fontWeight(.semibold)
                                .foregroundColor(Color(UIConfiguration.tintColor))
                            }
                    }.padding([.top, .bottom], 50)
                }
            }
        }
        .alert(item: $signInViewModel.statusViewModel) { status in
            Alert(title: Text(status.title),
                  message: Text(status.message),
                  dismissButton: .default(Text("OK"), action: {
                    signInViewModel.initField(email: true, password: true)
                    if status.title == "Successful" {
                        self.pushActive = true
                    }
            }))
        }
        .listStyle(.plain)
        .padding()
    }

    
    private func customButton(title: String,
                              backgroundColor: UIColor,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .modifier(ButtonModifier(font: UIConfiguration.buttonFont,
                                         color: backgroundColor,
                                         textColor: .white,
                                         width: 275,
                                         height: 55))
        }
    }
}

