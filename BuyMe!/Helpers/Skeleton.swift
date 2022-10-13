

// MARK: - Sayfa yükleme ve localization süreçlerinin yönetilmesi için eklenen sınıf yapısıdır. API'den veri beklenirken kullanıcıya sayfa iskelet yapısını gösterir. Ayrıca normal süreçte boş görünebilecek olan sayfalarda (örn: Favori sayfası, Arama sayfası) kullanıcıya sayfanın henüz bir içerik yüklemediğini bildirir, nasıl yükleyeceğine dair yönlendirme mesajı çıakrtır.
import Foundation
import SkeletonView

class Skeleton{
    
    static func startAnimation(outlet: UIView) {
        outlet.isSkeletonable = true
        outlet.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
        outlet.startSkeletonAnimation()
    }
    
    static func stopAnimaton(outlet: UIView) {
        outlet.stopSkeletonAnimation()
        outlet.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
    }
    
    static func startAnimationArray(outlets: [UIView]) {
        for outlet in outlets {
            outlet.isSkeletonable = true
            outlet.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .concrete), animation: nil, transition: .crossDissolve(0.25))
            outlet.startSkeletonAnimation()
        }
    }
    static func stopAnimationArray(outlets: [UIView]) {
        for outlet in outlets {
            outlet.stopSkeletonAnimation()
            outlet.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
    }
    
}
extension Skeleton{
    static func hideMessage(parentView: UIView, childView: UIView, state: Bool) {
        switch state{
        case true:
            parentView.isHidden = true
            childView.isHidden = false
        case false:
            parentView.isHidden = false
            childView.isHidden = true
        }
    }
}
