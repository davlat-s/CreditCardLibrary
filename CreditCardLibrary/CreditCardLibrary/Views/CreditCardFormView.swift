import SwiftUI

struct CreditCardFormView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Binding var cardName: String
    @Binding var isBusiness: Bool
    @Binding var selectedBank: Bank?
    @State var isNewBank: Bool
    var existingBanks: [Bank]
    var onSave: () -> Void
    
    var body: some View {
        Form {
            TextField("Card Name", text: $cardName)
            Toggle("Business", isOn: $isBusiness)

            if !existingBanks.isEmpty {
                Picker("Bank", selection: $selectedBank) {
                    ForEach(existingBanks) { bank in
                        Text(bank.name).tag(Optional(bank))
                    }
                }
            }

            Toggle("New Bank", isOn: $isNewBank)

            if isNewBank {
                AddBankView { newBank in
                    modelContext.insert(newBank)
                    selectedBank = newBank
                }
            }
        }
        .onAppear {
            if existingBanks.isEmpty {
                isNewBank = true
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    onSave()
                }
                .disabled(cardName.isEmpty || selectedBank == nil)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}


#Preview {
    CreditCardFormView(cardName: .constant(""), isBusiness: .constant(false), selectedBank: .constant(SampleData.shared.bank), isNewBank: false, existingBanks: Bank.sampleData, onSave: {print("yay")})
}
