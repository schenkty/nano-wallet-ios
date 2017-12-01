//
//  AccountBalance.swift
//  Raiblocks
//
//  Created by Zack Shapiro on 12/12/17.
//  Copyright © 2017 Zack Shapiro. All rights reserved.
//

/// Subscribes to an address on the network 
struct AccountSubscribe: Decodable {

    private let _blockCount: String // RPC note: this value should return an Int
    private let balance: String
    private let _pendingBalance: String

    let representativeBlock: String
    let openBlock: String // I may not need this
    let frontierBlockHash: String

    enum CodingKeys: String, CodingKey {
        case _blockCount = "block_count"
        case balance
        case _pendingBalance = "pending"
        case representativeBlock = "representative_block"
        case openBlock = "open_block"
        case frontierBlockHash = "frontier"
    }

    var blockCount: Int {
        return Int(_blockCount) ?? 0
    }

    var transactableBalance: NSDecimalNumber? {
        return NSDecimalNumber(string: balance)
    }

    var pendingBalance: NSDecimalNumber? {
        return NSDecimalNumber(string: _pendingBalance)
    }

    var totalBalance: NSDecimalNumber? {
        guard let pendingBalance = pendingBalance else { return nil }

        return transactableBalance?.adding(pendingBalance)
    }

    var totalBalanceAsString: String {
        return totalBalance?.rawAsUsableString ?? ""
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self._blockCount = try container.decode(String.self, forKey: ._blockCount)
        self.balance = try container.decode(String.self, forKey: .balance)
        self._pendingBalance = try container.decode(String.self, forKey: ._pendingBalance)
        self.representativeBlock = try container.decode(String.self, forKey: .representativeBlock)
        self.openBlock = try container.decode(String.self, forKey: .openBlock)
        self.frontierBlockHash = try container.decode(String.self, forKey: .frontierBlockHash)
    }

}