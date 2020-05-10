import Foundation
import StoreKit

protocol Purchasing {
    
}

@available(iOS 13.0, *)
public class JSVInAppPurchaseClient: NSObject, Purchasing {
    private let purchasedProductsKey = "in-app-purchase_products"

    fileprivate var paymentQueue: SKPaymentQueue
    fileprivate var productRequest: SKProductsRequest?

    public var products: [SKProduct]
    public var purchasedProducts: [SKProduct]

    public var paymentCallback: (([SKProduct]) -> Void)?
    public var productsCallback: (([SKProduct]) -> Void)?

    override public init() {
        paymentQueue = SKPaymentQueue.default()
        products = []
        purchasedProducts = []
        super.init()
        paymentQueue.delegate = self
        paymentQueue.add(self)
        
        if let savedProducts = UserDefaults.standard.array(forKey: purchasedProductsKey) as? [SKProduct] {
            purchasedProducts = savedProducts
        }
    }
    
    deinit {
        UserDefaults.standard.set(purchasedProducts, forKey: purchasedProductsKey)
        paymentQueue.remove(self)
    }
    
    public func fetchProducts(identifiers: [String]) {
        let request = SKProductsRequest(productIdentifiers: Set(identifiers))
        request.delegate = self
        request.start()
        productRequest = request
    }
    
    public func purchase(product: SKProduct) {
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            paymentQueue.add(payment)
        } else {
            paymentCallback?(purchasedProducts)
        }
    }
    
    public func restorePurchase() { // There must be some functionality for the user to restore non-consumable IAP's
        paymentQueue.restoreCompletedTransactions()
    }
    
    public func isPurchased(identifier: String) -> Bool {
        guard let product = (products.filter { (p) -> Bool in
            return p.productIdentifier == identifier
            }.first) else { return false }

        return purchasedProducts.contains(product)
    }
    
    public func canMakePayments() -> Bool { // Important to implement a way to let the user know if payments cannot be made
        return SKPaymentQueue.canMakePayments()
    }
}

@available(iOS 13.0, *)
extension JSVInAppPurchaseClient: SKPaymentQueueDelegate {
    public func paymentQueue(_ paymentQueue: SKPaymentQueue, shouldContinue transaction: SKPaymentTransaction, in newStorefront: SKStorefront) -> Bool {
        return true
    }
}

@available(iOS 13.0, *)
extension JSVInAppPurchaseClient: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        #if DEBUG
        print("Log: Got \(response.products.count) products.")
        print("Log: Invalid product ids \(response.invalidProductIdentifiers)")
        #endif
        products = response.products

        DispatchQueue.main.async {
            self.productsCallback?(self.products)
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Log: Failed to retrieve products.")
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        productRequest = nil
    }
}

@available(iOS 13.0, *)
extension JSVInAppPurchaseClient: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions where transaction.transactionState == .purchased ||
            transaction.transactionState == .restored {
            if let product = (products.first { (prod) -> Bool in
                prod.productIdentifier == transaction.payment.productIdentifier
            }) {
                purchasedProducts.append(product)

                DispatchQueue.main.async {
                    self.paymentCallback?(self.purchasedProducts)
                }
            }
        }
        
        for transaction in transactions where transaction.transactionState == .failed {
            DispatchQueue.main.async {
                self.paymentCallback?(self.purchasedProducts)
            }
        }
    }
}
