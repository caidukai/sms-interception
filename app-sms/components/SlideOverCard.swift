import SwiftUI

public struct SlideOverCard<Content: View>: View {
    var isPresented: Binding<Bool>
    let onDismiss: (() -> Void)?
    var options: SOCOptions
    let content: Content
    
    public init(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, options: SOCOptions = [], content: @escaping () -> Content) {
        self.isPresented = isPresented
        self.onDismiss = onDismiss
        self.options = options
        self.content = content()
    }
    
    @available(*, deprecated, message: "Replace option parameters with the new option set.")
    public init(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil, dragEnabled: Binding<Bool> = .constant(true), dragToDismiss: Binding<Bool> = .constant(true), displayExitButton: Binding<Bool> = .constant(true), content: @escaping () -> Content) {
        self.isPresented = isPresented
        self.onDismiss = onDismiss
        
        var options = SOCOptions()
        if !dragEnabled.wrappedValue { options.insert(.disableDrag) }
        if !dragToDismiss.wrappedValue { options.insert(.disableDragToDismiss) }
        if !displayExitButton.wrappedValue { options.insert(.hideExitButton) }
        
        self.options = options
        
        self.content = content()
    }
    
    @GestureState private var viewOffset: CGFloat = 0.0
    
    var isiPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    public var body: some View {
        ZStack {
            if isPresented.wrappedValue {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .zIndex(1)
                
                Group {
                    if #available(iOS 14.0, *) {
                        container
                            .ignoresSafeArea(.container, edges: .bottom)
                    } else {
                        container
                            .edgesIgnoringSafeArea(.bottom)
                    }
                }.transition(isiPad ? AnyTransition.opacity.combined(with: .offset(x: 0, y: 200)) : .move(edge: .bottom))
                    .zIndex(2)
            }
        }.animation(.spring(response: 0.35, dampingFraction: 1))
    }
    
    private var container: some View {
        VStack {
            Spacer()
            
            if isiPad {
                card.aspectRatio(1.0, contentMode: .fit)
                Spacer()
            } else {
                card
            }
        }
    }
    
    private var card: some View {
        VStack(alignment: .trailing, spacing: 0) {
            if !options.contains(.hideExitButton) {
                Button(action: dismiss) {
                    SOCExitButton()
                }.frame(width: 24, height: 24)
            }
            
            content
                .padding([.horizontal, options.contains(.hideExitButton) ? .vertical : .bottom], 14)
        }.padding(20)
        .background(RoundedRectangle(cornerRadius: 38.5, style: .continuous)
                        .fill(Color(.systemGray6)))
        .clipShape(RoundedRectangle(cornerRadius: 38.5, style: .continuous))
        .offset(x: 0, y: viewOffset/pow(2, abs(viewOffset)/500+1))
        .gesture(
            options.contains(.disableDrag) ? nil :
                DragGesture()
                .updating($viewOffset) { value, state, transaction in
                    state = value.translation.height
                }
                .onEnded() { value in
                    if value.predictedEndTranslation.height > 175 && !options.contains(.disableDragToDismiss) {
                        dismiss()
                    }
                }
        )
    }
    
    func dismiss() {
        withAnimation {
            isPresented.wrappedValue = false
        }
        if (onDismiss != nil) { onDismiss!() }
    }
}

public struct SOCOptions: OptionSet {
    public let rawValue: Int8
    
    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }
    
    public static let disableDrag = SOCOptions(rawValue: 1)
    public static let disableDragToDismiss = SOCOptions(rawValue: 1 << 1)
    public static let hideExitButton = SOCOptions(rawValue: 1 << 2)
}

struct SlideOverCard_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
        PreviewWrapper().environment(\.colorScheme, .dark)
    }
    
    struct PreviewWrapper: View {
        @State var isPresented = true
        
        @State var disableDrag = false
        @State var disableDragToDismiss = false
        @State var hideExitButton = false
        
        var options: SOCOptions {
            var options = SOCOptions()
            if disableDrag { options.insert(.disableDrag) }
            if disableDragToDismiss { options.insert(.disableDragToDismiss) }
            if hideExitButton { options.insert(.hideExitButton) }
            return options
        }
        
        var body: some View {
            ZStack {
                Color(.systemBackground).edgesIgnoringSafeArea(.all)
                VStack {
                    Button("Show card", action: {
                        isPresented = true
                    })
                    
                    Toggle("Disable drag", isOn: $disableDrag)
                    Toggle("Disable drag to dismiss", isOn: $disableDragToDismiss)
                    Toggle("Hide exit button", isOn: $hideExitButton)
                }.padding()
            }.slideOverCard(isPresented: $isPresented, options: options) {
                PlaceholderContent(isPresented: $isPresented)
            }
        }
    }
    
    struct PlaceholderContent: View {
        @Binding var isPresented: Bool
        
        var body: some View {
            VStack(alignment: .center, spacing: 25) {
                VStack {
                    Text("Large title").font(.system(size: 28, weight: .bold))
                    Text("A nice and brief description")
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(Color.gray)
                    Text("Content").foregroundColor(.white)
                }
                
                VStack(spacing: 0) {
                    Button("Do something", action: {
                        isPresented = false
                    }).buttonStyle(SOCActionButton())
                    Button("Just skip it", action: {
                        isPresented = false
                    }).buttonStyle(SOCEmptyButton())
                }
            }.frame(height: 480)
        }
    }
}
