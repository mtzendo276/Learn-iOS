//
//  EndpointType.swift
//  NetworkingLayer
//
//  Created by Arturs Derkintis on 01/11/2017.
//  Copyright © 2017 Arturs Derkintis. All rights reserved.
//

import Foundation

protocol EndpointType {

    var baseURL: URL { get }

    var path: String { get }

}
