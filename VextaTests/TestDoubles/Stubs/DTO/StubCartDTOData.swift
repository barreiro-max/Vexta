//
//  StubCartDTO.swift
//  VextaTests
//
//  Created by MaxAdmin on 26.06.2026.
//

import Foundation
@testable import Vexta

extension CartDTO {

    static var stubData: Data {
        """
        {
            "id": 1,
            "userId": 1,
            "date": "2020-03-02T00:00:00.000Z",
            "products": [
                {"productId": 1, "quantity": 4},
                {"productId": 2, "quantity": 1},
                {"productId": 3, "quantity": 6}
            ],
            "__v": 0
        }
        """.data(using: .utf8)!
    }

    static var stubsData: Data {
        """
        [
          {
            "id": 1,
            "userId": 1,
            "date": "2020-03-02T00:00:00.000Z",
            "products": [
              {
                "productId": 1,
                "quantity": 4
              },
              {
                "productId": 2,
                "quantity": 1
              },
              {
                "productId": 3,
                "quantity": 6
              }
            ],
            "__v": 0
          },
          {
            "id": 2,
            "userId": 1,
            "date": "2020-01-02T00:00:00.000Z",
            "products": [
              {
                "productId": 2,
                "quantity": 4
              },
              {
                "productId": 1,
                "quantity": 10
              },
              {
                "productId": 5,
                "quantity": 2
              }
            ],
            "__v": 0
          }
        ]
        """.data(using: .utf8)!
    }
}
