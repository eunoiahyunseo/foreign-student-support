import SwiftUI

struct RefreshableScrollView<Content: View>: UIViewRepresentable {
    let onRefresh: () -> Void
    let content: () -> Content

    init(onRefresh: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.onRefresh = onRefresh
        self.content = content
    }

    func makeUIView(context: Context) -> UIScrollView {
        let control = UIScrollView()
        control.refreshControl = UIRefreshControl()
        control.refreshControl?.addTarget(context.coordinator, action:
                                            #selector(Coordinator.handleRefreshControl),
                                          for: .valueChanged)
        
        let contentView = UIHostingController(rootView: content())
        contentView.view.frame = control.bounds
        contentView.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        control.addSubview(contentView.view)
        control.contentSize = contentView.sizeThatFits(in: control.bounds.size)

        return control
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if uiView.refreshControl?.isRefreshing == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                uiView.refreshControl?.endRefreshing()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, onRefresh: onRefresh)
    }

    class Coordinator: NSObject {
        var control: RefreshableScrollView
        let onRefresh: () -> Void
        @objc func handleRefreshControl(sender: UIRefreshControl) {
            onRefresh()
        }

        init(_ control: RefreshableScrollView, onRefresh: @escaping () -> Void) {
            self.control = control
            self.onRefresh = onRefresh
        }
    }
}
