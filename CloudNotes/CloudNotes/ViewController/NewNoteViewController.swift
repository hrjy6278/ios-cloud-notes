//
//  NewNoteViewController.swift
//  CloudNotes
//
//  Created by Jinho Choi on 2021/02/17.
//

import UIKit

class NewNoteViewController: UIViewController {
    private let noteTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureTextView()
    }
    
    private func configureTextView() {
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noteTextView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            noteTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            noteTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}
