//
//  PersistenceErrorMapper.swift
//  Vexta
//
//  Created by MaxAdmin on 18.07.2026.
//

import Foundation
import SwiftData
import CoreData
import Domain

extension PersistenceError {

    init(from error: any Error) {
        switch error {

        case let swiftDataError as SwiftDataError:
            self.init(from: swiftDataError)

        case let dataStoreError as DataStoreError:
            self.init(from: dataStoreError)

        case let cocoaError as CocoaError:
            self.init(from: cocoaError)

        case let nsError as NSError where nsError.domain == NSSQLiteErrorDomain:
            self.init(from: nsError)

        default:
            self = .unknown(underlying: error as NSError)
        }
    }

    private init(from swiftDataError: SwiftDataError) {
        switch swiftDataError {

        case .modelValidationFailure:
            self = .savingContext

        case .sortingPendingChangesWithIdentifiers,
                .invalidTransactionFetchRequest,
                .includePendingChangesWithBatchSize,
                .unsupportedPredicate,
                .unsupportedSortDescriptor,
                .unsupportedKeyPath,
                .historyTokenExpired:
            self = .readingData

        case .backwardMigration:
            self = .migrationFailed

        case .loadIssueModelContainer,
                .configurationFileNameContainsInvalidCharacters,
                .configurationFileNameTooLong,
                .duplicateConfiguration,
                .configurationSchemaNotFoundInContainerSchema,
                .unknownSchema,
                .missingModelContext:
            self = .internalStore

        default:
            self = .unknown(underlying: swiftDataError as NSError)
        }
    }

    private init(from dataStoreError: DataStoreError) {
        self = switch dataStoreError {

        case .invalidPredicate,
                .preferInMemorySort,
                .preferInMemoryFilter,
                .unsupportedFeature:
            .internalStore

        default:
            .unknown(underlying: dataStoreError as NSError)
        }
    }

    private init(from cocoaError: CocoaError) {
        let cocoaErrorCode = cocoaError.code

        // error codes taken from https://gist.github.com/hishma/7cb505f94230ac7d7ed53d52a1e6dab6
        let isCoreDataError = (1550...1690).contains(cocoaErrorCode.rawValue) || (132000...134301).contains(cocoaErrorCode.rawValue)

        if isCoreDataError {
            self = switch cocoaErrorCode {

            case .coreData, .sqlite:
                .internalStore

            case .persistentStoreOpen,
                    .persistentStoreUnsupportedRequestType,
                    .managedObjectReferentialIntegrity,
                    .managedObjectExternalRelationship,
                    .managedObjectConstraintMerge:
                .readingData

            case .persistentStoreSave,
                    .persistentStoreTimeout,
                    .persistentStoreIncompleteSave,
                    .persistentStoreSaveConflicts,
                    .managedObjectValidation,
                    .validationMultipleErrors,
                    .validationMissingMandatoryProperty,
                    .validationNumberTooLarge,
                    .validationNumberTooSmall,
                    .validationInvalidDate,
                    .validationDateTooLate,
                    .validationDateTooSoon,
                    .validationStringTooLong,
                    .validationStringTooShort,
                    .validationStringPatternMatching,
                    .validationRelationshipLacksMinimumCount,
                    .validationRelationshipExceedsMaximumCount:
                .savingContext

            case .validationRelationshipDeniedDelete:
                .deletingFromFile

            case .migration,
                    .migrationCancelled,
                    .entityMigrationPolicy,
                    .migrationManagerSourceStore,
                    .migrationManagerDestinationStore,
                    .migrationMissingSourceModel,
                    .migrationMissingMappingModel,
                    .inferredMappingModel,
                    .persistentStoreIncompatibleVersionHash:
                .migrationFailed

            default:
                .internalStore
            }
        }

        if cocoaError.isFileError { // error codes between 0 and 1024
            self = switch cocoaErrorCode {

            case .fileWriteUnknown,
                    .fileWriteFileExists,
                    .fileWriteNoPermission,
                    .fileWriteOutOfSpace,
                    .fileWriteUnsupportedScheme,
                    .fileWriteVolumeReadOnly,
                    .fileWriteInvalidFileName,
                    .fileWriteInapplicableStringEncoding:
                .writingToFile

            case .fileReadUnknown,
                    .fileReadTooLarge,
                    .fileReadCorruptFile,
                    .fileReadNoSuchFile,
                    .fileReadNoPermission,
                    .fileReadUnsupportedScheme,
                    .fileReadInvalidFileName,
                    .fileReadUnknownStringEncoding,
                    .fileReadInapplicableStringEncoding:
                .readingData

            default:
                .unknown(underlying: cocoaError as NSError)
            }
        }
        self = .unknown(underlying: cocoaError as NSError)
    }

    private init(from nsError: NSError) {
        let sqliteErrorCode = nsError.code

        let rawPersistenceError = SQLiteError(rawValue: sqliteErrorCode)
        self = switch rawPersistenceError {
        case .internal:         .internalStore
        case .perm:             .writingToFile
        case .busy:             .invalidated
        case .interrupt:        .cancelled
        case .inputOutputError: .deletingFromFile
        case .schema:           .migrationFailed
        case .constraint:       .savingContext
        case .notaDB:           .readingData
        case nil:               .unknown(underlying: nsError)
        }
    }
}

extension PersistenceError: RepositoryErrorConvertible {

    public var asRepositoryError: RepositoryError {
        switch self {
        case .internalStore, .writingToFile, .invalidated,
             .deletingFromFile, .migrationFailed, .savingContext:
            .storageFailure
        case .readingData:
            .dataCorrupted
        case .cancelled:
            .cancelled
        case .unknown:
            .unknown(underlying: self as NSError)
        }
    }
}
