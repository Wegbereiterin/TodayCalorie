//
//  KeyboardExtension.swift
//  TodayCalorie
//
//  Created by 박선구 on 10/29/24.
//

import UIKit

extension UIViewController {
    
    
    // MARK: - Properties
    
    var keyboardToolbar: UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flexSpace, doneButton]
        toolbar.tintColor = .black
        
        return toolbar
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Selectors
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func handleKeyboardWillShow(_ notification: NSNotification) {
        guard let scrollView = getScrollView(),
              let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardFrame.height,
            right: 0
        )
        
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func handleKeyboardWillHide(_ notification: NSNotification) {
        guard let scrollView = getScrollView() else { return }
        
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // MARK: - Helpers
    
    func setupKeyboardHandling(for scrollView: UIScrollView? = nil) {
        hideKeyboardWhenTappedAround()
        
        if let scrollView = scrollView {
            setupKeyboardNotifications(for: scrollView)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupKeyboardNotifications(for scrollView: UIScrollView) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func addKeyboardToolbar(to textFields: UITextField...) {
        textFields.forEach { $0.inputAccessoryView = keyboardToolbar }
    }
    
    func addKeyboardToolbar(to textViews: UITextView...) {
        textViews.forEach { $0.inputAccessoryView = keyboardToolbar }
    }
    
    private func getScrollView() -> UIScrollView? {
        if let scrollView = view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
            return scrollView
        }
        return nil
    }
    
}
