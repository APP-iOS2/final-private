//
//  RequirementTextEditor.swift
//  Private
//
//  Created by 박성훈 on 10/10/23.
//

import SwiftUI

struct RequirementTextEditor: View {
    enum Field: Hashable {
        case requirement
    }
    
    @FocusState private var focusedField: Field?
    @Binding var requirementText: String
    let limitChar: Int = 100
    let placeholder: String = "업체에 요청하실 내용을 적어주세요"
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $requirementText)
                .foregroundStyle(.primary)
                .keyboardType(.default)
                .frame(height: 80)
                .lineSpacing(10)
                .focused($focusedField, equals: .requirement)
                .onChange(of: self.requirementText, perform: {
                    if $0.count > limitChar {
                        self.requirementText = String($0.prefix(limitChar))
                    }
                })
                .border(.secondary)
            
            if requirementText.isEmpty {
                Text(placeholder)
                    .lineSpacing(10)
                    .foregroundColor(Color.primary.opacity(0.25))
                    .padding(.top, 10)
                    .padding(.leading, 10)
                    .onTapGesture {
                        self.focusedField = .requirement
                    }
            }
        }
    }
}

struct RequirementTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        RequirementTextEditor(requirementText: .constant(""))
    }
}
