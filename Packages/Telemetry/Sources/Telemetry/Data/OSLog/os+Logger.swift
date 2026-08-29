//
//  Logger.swift
//  Vexta
//
//  Created by MaxAdmin on 14.06.2026.
//

import Foundation
import os

extension os.Logger {

    public func debug(
        _ message: @autoclosure () -> String,
        fileID: String = #fileID,
        function: String = #function
    ) {
        let osLogMessage = makeOsLogMessage(
            message,
            fileID: fileID,
            function: function
        )
        debug("\(osLogMessage, privacy: .private)")
    }

    public func info(
        _ message: @autoclosure () -> String,
        fileID: String = #fileID,
        function: String = #function
    ) {
        let osLogMessage = makeOsLogMessage(
            message,
            fileID: fileID,
            function: function
        )
        info("\(osLogMessage, privacy: .private)")
    }

    public func notice(
        _ message: @autoclosure () -> String,
        fileID: String = #fileID,
        function: String = #function
    ) {
        let osLogMessage = makeOsLogMessage(
            message,
            fileID: fileID,
            function: function
        )
        notice("\(osLogMessage, privacy: .private)")
    }

    public func warning(
        _ message: @autoclosure () -> String,
        fileID: String = #fileID,
        function: String = #function
    ) {
        let osLogMessage = makeOsLogMessage(
            message,
            fileID: fileID,
            function: function
        )
        warning("\(osLogMessage, privacy: .private)")
    }

    public func error(
        _ message: @autoclosure () -> String,
        fileID: String = #fileID,
        function: String = #function
    ) {
        let osLogMessage = makeOsLogMessage(
            message,
            fileID: fileID,
            function: function
        )
        error("\(osLogMessage, privacy: .private)")
    }

    public func fault(
        _ message: @autoclosure () -> String,
        fileID: String = #fileID,
        function: String = #function
    ) {
        let osLogMessage = makeOsLogMessage(
            message,
            fileID: fileID,
            function: function
        )
        fault("\(osLogMessage, privacy: .private)")
    }

    private func makeOsLogMessage(
        _ message: () -> String,
        fileID: String,
        function: String
    ) -> String {
        let filename = makeFilename(fileID: fileID)

        let osLogMessage: String
#if DEBUG
        let functionName = makeFunctionName(function: function)
        osLogMessage = "[\(filename): \(functionName)] \(message())"
#else
        osLogMessage = "[\(filename)] \(message())"
#endif
        let finalOsLogMessage = osLogMessage.appending(".")

        return finalOsLogMessage
    }

    private func makeFilename(fileID: String) -> String {
        fileID
            .components(separatedBy: "/")
            .last?
            .replacingOccurrences(of: ".swift", with: "") ?? ""
    }

    private func makeFunctionName(function: String) -> String {
        function
            .replacingOccurrences(of: "()", with: "")
    }
}
