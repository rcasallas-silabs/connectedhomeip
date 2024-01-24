exports.model = {
  3 : {
    name : "Identify",
    commands : {
      0 : {
        name : "Identify",
        arguments : [
          "IdentifyTime",
        ],
      },
      64 : {
        name : "TriggerEffect",
        arguments : [
          "EffectIdentifier",
          "EffectVariant",
        ],
      },
    },
    attributes : {
      0 : "IdentifyTime",
      1 : "IdentifyType",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  4 : {
    name : "Groups",
    commands : {
      0 : {
        name : "AddGroup",
        arguments : [
          "GroupId",
          "GroupName",
        ],
      },
      0 : {
        name : "AddGroupResponse",
        arguments : [
          "Status",
          "GroupId",
        ],
      },
      1 : {
        name : "ViewGroup",
        arguments : [
          "GroupId",
        ],
      },
      1 : {
        name : "ViewGroupResponse",
        arguments : [
          "Status",
          "GroupId",
          "GroupName",
        ],
      },
      2 : {
        name : "GetGroupMembership",
        arguments : [
          "GroupList",
        ],
      },
      2 : {
        name : "GetGroupMembershipResponse",
        arguments : [
          "Capacity",
          "GroupList",
        ],
      },
      3 : {
        name : "RemoveGroup",
        arguments : [
          "GroupId",
        ],
      },
      3 : {
        name : "RemoveGroupResponse",
        arguments : [
          "Status",
          "GroupId",
        ],
      },
      4 : {
        name : "RemoveAllGroups",
        arguments : [

        ],
      },
      5 : {
        name : "AddGroupIfIdentifying",
        arguments : [
          "GroupId",
          "GroupName",
        ],
      },
    },
    attributes : {
      0 : "NameSupport",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  5 : {
    name : "Scenes",
    commands : {
      0 : {
        name : "AddScene",
        arguments : [
          "GroupId",
          "SceneId",
          "TransitionTime",
          "SceneName",
          "ExtensionFieldSets",
        ],
      },
      0 : {
        name : "AddSceneResponse",
        arguments : [
          "Status",
          "GroupId",
          "SceneId",
        ],
      },
      1 : {
        name : "ViewScene",
        arguments : [
          "GroupId",
          "SceneId",
        ],
      },
      1 : {
        name : "ViewSceneResponse",
        arguments : [
          "Status",
          "GroupId",
          "SceneId",
          "TransitionTime",
          "SceneName",
          "ExtensionFieldSets",
        ],
      },
      2 : {
        name : "RemoveScene",
        arguments : [
          "GroupId",
          "SceneId",
        ],
      },
      2 : {
        name : "RemoveSceneResponse",
        arguments : [
          "Status",
          "GroupId",
          "SceneId",
        ],
      },
      3 : {
        name : "RemoveAllScenes",
        arguments : [
          "GroupId",
        ],
      },
      3 : {
        name : "RemoveAllScenesResponse",
        arguments : [
          "Status",
          "GroupId",
        ],
      },
      4 : {
        name : "StoreScene",
        arguments : [
          "GroupId",
          "SceneId",
        ],
      },
      4 : {
        name : "StoreSceneResponse",
        arguments : [
          "Status",
          "GroupId",
          "SceneId",
        ],
      },
      5 : {
        name : "RecallScene",
        arguments : [
          "GroupId",
          "SceneId",
          "TransitionTime",
        ],
      },
      6 : {
        name : "GetSceneMembership",
        arguments : [
          "GroupId",
        ],
      },
      6 : {
        name : "GetSceneMembershipResponse",
        arguments : [
          "Status",
          "Capacity",
          "GroupId",
          "SceneList",
        ],
      },
      64 : {
        name : "EnhancedAddScene",
        arguments : [
          "GroupId",
          "SceneId",
          "TransitionTime",
          "SceneName",
          "ExtensionFieldSets",
        ],
      },
      64 : {
        name : "EnhancedAddSceneResponse",
        arguments : [
          "Status",
          "GroupId",
          "SceneId",
        ],
      },
      65 : {
        name : "EnhancedViewScene",
        arguments : [
          "GroupId",
          "SceneId",
        ],
      },
      65 : {
        name : "EnhancedViewSceneResponse",
        arguments : [
          "Status",
          "GroupId",
          "SceneId",
          "TransitionTime",
          "SceneName",
          "ExtensionFieldSets",
        ],
      },
      66 : {
        name : "CopyScene",
        arguments : [
          "Mode",
          "GroupIdFrom",
          "SceneIdFrom",
          "GroupIdTo",
          "SceneIdTo",
        ],
      },
      66 : {
        name : "CopySceneResponse",
        arguments : [
          "Status",
          "GroupIdFrom",
          "SceneIdFrom",
        ],
      },
    },
    attributes : {
      0 : "SceneCount",
      1 : "CurrentScene",
      2 : "CurrentGroup",
      3 : "SceneValid",
      4 : "NameSupport",
      5 : "LastConfiguredBy",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  6 : {
    name : "OnOff",
    commands : {
      0 : {
        name : "Off",
        arguments : [

        ],
      },
      1 : {
        name : "On",
        arguments : [

        ],
      },
      2 : {
        name : "Toggle",
        arguments : [

        ],
      },
      64 : {
        name : "OffWithEffect",
        arguments : [
          "EffectId",
          "EffectVariant",
        ],
      },
      65 : {
        name : "OnWithRecallGlobalScene",
        arguments : [

        ],
      },
      66 : {
        name : "OnWithTimedOff",
        arguments : [
          "OnOffControl",
          "OnTime",
          "OffWaitTime",
        ],
      },
    },
    attributes : {
      0 : "OnOff",
      16384 : "GlobalSceneControl",
      16385 : "OnTime",
      16386 : "OffWaitTime",
      16387 : "StartUpOnOff",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  7 : {
    name : "OnOffSwitchConfiguration",
    commands : {},
    attributes : {
      0 : "SwitchType",
      16 : "SwitchActions",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  8 : {
    name : "LevelControl",
    commands : {
      0 : {
        name : "MoveToLevel",
        arguments : [
          "Level",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      1 : {
        name : "Move",
        arguments : [
          "MoveMode",
          "Rate",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      2 : {
        name : "Step",
        arguments : [
          "StepMode",
          "StepSize",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      3 : {
        name : "Stop",
        arguments : [
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      4 : {
        name : "MoveToLevelWithOnOff",
        arguments : [
          "Level",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      5 : {
        name : "MoveWithOnOff",
        arguments : [
          "MoveMode",
          "Rate",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      6 : {
        name : "StepWithOnOff",
        arguments : [
          "StepMode",
          "StepSize",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      7 : {
        name : "StopWithOnOff",
        arguments : [
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      8 : {
        name : "MoveToClosestFrequency",
        arguments : [
          "Frequency",
        ],
      },
    },
    attributes : {
      0 : "CurrentLevel",
      1 : "RemainingTime",
      2 : "MinLevel",
      3 : "MaxLevel",
      4 : "CurrentFrequency",
      5 : "MinFrequency",
      6 : "MaxFrequency",
      15 : "Options",
      16 : "OnOffTransitionTime",
      17 : "OnLevel",
      18 : "OnTransitionTime",
      19 : "OffTransitionTime",
      20 : "DefaultMoveRate",
      16384 : "StartUpCurrentLevel",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  15 : {
    name : "BinaryInputBasic",
    commands : {},
    attributes : {
      4 : "ActiveText",
      28 : "Description",
      46 : "InactiveText",
      81 : "OutOfService",
      84 : "Polarity",
      85 : "PresentValue",
      103 : "Reliability",
      111 : "StatusFlags",
      256 : "ApplicationType",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  28 : {
    name : "PulseWidthModulation",
    commands : {},
    attributes : {
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  29 : {
    name : "Descriptor",
    commands : {},
    attributes : {
      0 : "DeviceTypeList",
      1 : "ServerList",
      2 : "ClientList",
      3 : "PartsList",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  30 : {
    name : "Binding",
    commands : {},
    attributes : {
      0 : "Binding",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  31 : {
    name : "AccessControl",
    commands : {},
    attributes : {
      0 : "Acl",
      1 : "Extension",
      2 : "SubjectsPerAccessControlEntry",
      3 : "TargetsPerAccessControlEntry",
      4 : "AccessControlEntriesPerFabric",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  37 : {
    name : "Actions",
    commands : {
      0 : {
        name : "InstantAction",
        arguments : [
          "ActionID",
          "InvokeID",
        ],
      },
      1 : {
        name : "InstantActionWithTransition",
        arguments : [
          "ActionID",
          "InvokeID",
          "TransitionTime",
        ],
      },
      2 : {
        name : "StartAction",
        arguments : [
          "ActionID",
          "InvokeID",
        ],
      },
      3 : {
        name : "StartActionWithDuration",
        arguments : [
          "ActionID",
          "InvokeID",
          "Duration",
        ],
      },
      4 : {
        name : "StopAction",
        arguments : [
          "ActionID",
          "InvokeID",
        ],
      },
      5 : {
        name : "PauseAction",
        arguments : [
          "ActionID",
          "InvokeID",
        ],
      },
      6 : {
        name : "PauseActionWithDuration",
        arguments : [
          "ActionID",
          "InvokeID",
          "Duration",
        ],
      },
      7 : {
        name : "ResumeAction",
        arguments : [
          "ActionID",
          "InvokeID",
        ],
      },
      8 : {
        name : "EnableAction",
        arguments : [
          "ActionID",
          "InvokeID",
        ],
      },
      9 : {
        name : "EnableActionWithDuration",
        arguments : [
          "ActionID",
          "InvokeID",
          "Duration",
        ],
      },
      10 : {
        name : "DisableAction",
        arguments : [
          "ActionID",
          "InvokeID",
        ],
      },
      11 : {
        name : "DisableActionWithDuration",
        arguments : [
          "ActionID",
          "InvokeID",
          "Duration",
        ],
      },
    },
    attributes : {
      0 : "ActionList",
      1 : "EndpointLists",
      2 : "SetupURL",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  40 : {
    name : "Basic",
    commands : {
      0 : {
        name : "MfgSpecificPing",
        arguments : [

        ],
      },
    },
    attributes : {
      0 : "DataModelRevision",
      1 : "VendorName",
      2 : "VendorID",
      3 : "ProductName",
      4 : "ProductID",
      5 : "NodeLabel",
      6 : "Location",
      7 : "HardwareVersion",
      8 : "HardwareVersionString",
      9 : "SoftwareVersion",
      10 : "SoftwareVersionString",
      11 : "ManufacturingDate",
      12 : "PartNumber",
      13 : "ProductURL",
      14 : "ProductLabel",
      15 : "SerialNumber",
      16 : "LocalConfigDisabled",
      17 : "Reachable",
      18 : "UniqueID",
      19 : "CapabilityMinima",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  41 : {
    name : "OtaSoftwareUpdateProvider",
    commands : {
      0 : {
        name : "QueryImage",
        arguments : [
          "VendorId",
          "ProductId",
          "SoftwareVersion",
          "ProtocolsSupported",
          "HardwareVersion",
          "Location",
          "RequestorCanConsent",
          "MetadataForProvider",
        ],
      },
      1 : {
        name : "QueryImageResponse",
        arguments : [
          "Status",
          "DelayedActionTime",
          "ImageURI",
          "SoftwareVersion",
          "SoftwareVersionString",
          "UpdateToken",
          "UserConsentNeeded",
          "MetadataForRequestor",
        ],
      },
      2 : {
        name : "ApplyUpdateRequest",
        arguments : [
          "UpdateToken",
          "NewVersion",
        ],
      },
      3 : {
        name : "ApplyUpdateResponse",
        arguments : [
          "Action",
          "DelayedActionTime",
        ],
      },
      4 : {
        name : "NotifyUpdateApplied",
        arguments : [
          "UpdateToken",
          "SoftwareVersion",
        ],
      },
    },
    attributes : {
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  42 : {
    name : "OtaSoftwareUpdateRequestor",
    commands : {
      0 : {
        name : "AnnounceOtaProvider",
        arguments : [
          "ProviderNodeId",
          "VendorId",
          "AnnouncementReason",
          "MetadataForNode",
          "Endpoint",
        ],
      },
    },
    attributes : {
      0 : "DefaultOtaProviders",
      1 : "UpdatePossible",
      2 : "UpdateState",
      3 : "UpdateStateProgress",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  43 : {
    name : "LocalizationConfiguration",
    commands : {},
    attributes : {
      0 : "ActiveLocale",
      1 : "SupportedLocales",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  44 : {
    name : "TimeFormatLocalization",
    commands : {},
    attributes : {
      0 : "HourFormat",
      1 : "ActiveCalendarType",
      2 : "SupportedCalendarTypes",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  45 : {
    name : "UnitLocalization",
    commands : {},
    attributes : {
      0 : "TemperatureUnit",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  46 : {
    name : "PowerSourceConfiguration",
    commands : {},
    attributes : {
      0 : "Sources",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  47 : {
    name : "PowerSource",
    commands : {},
    attributes : {
      0 : "Status",
      1 : "Order",
      2 : "Description",
      3 : "WiredAssessedInputVoltage",
      4 : "WiredAssessedInputFrequency",
      5 : "WiredCurrentType",
      6 : "WiredAssessedCurrent",
      7 : "WiredNominalVoltage",
      8 : "WiredMaximumCurrent",
      9 : "WiredPresent",
      10 : "ActiveWiredFaults",
      11 : "BatVoltage",
      12 : "BatPercentRemaining",
      13 : "BatTimeRemaining",
      14 : "BatChargeLevel",
      15 : "BatReplacementNeeded",
      16 : "BatReplaceability",
      17 : "BatPresent",
      18 : "ActiveBatFaults",
      19 : "BatReplacementDescription",
      20 : "BatCommonDesignation",
      21 : "BatANSIDesignation",
      22 : "BatIECDesignation",
      23 : "BatApprovedChemistry",
      24 : "BatCapacity",
      25 : "BatQuantity",
      26 : "BatChargeState",
      27 : "BatTimeToFullCharge",
      28 : "BatFunctionalWhileCharging",
      29 : "BatChargingCurrent",
      30 : "ActiveBatChargeFaults",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  48 : {
    name : "GeneralCommissioning",
    commands : {
      0 : {
        name : "ArmFailSafe",
        arguments : [
          "ExpiryLengthSeconds",
          "Breadcrumb",
        ],
      },
      1 : {
        name : "ArmFailSafeResponse",
        arguments : [
          "ErrorCode",
          "DebugText",
        ],
      },
      2 : {
        name : "SetRegulatoryConfig",
        arguments : [
          "NewRegulatoryConfig",
          "CountryCode",
          "Breadcrumb",
        ],
      },
      3 : {
        name : "SetRegulatoryConfigResponse",
        arguments : [
          "ErrorCode",
          "DebugText",
        ],
      },
      4 : {
        name : "CommissioningComplete",
        arguments : [

        ],
      },
      5 : {
        name : "CommissioningCompleteResponse",
        arguments : [
          "ErrorCode",
          "DebugText",
        ],
      },
    },
    attributes : {
      0 : "Breadcrumb",
      1 : "BasicCommissioningInfo",
      2 : "RegulatoryConfig",
      3 : "LocationCapability",
      4 : "SupportsConcurrentConnection",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  49 : {
    name : "NetworkCommissioning",
    commands : {
      0 : {
        name : "ScanNetworks",
        arguments : [
          "Ssid",
          "Breadcrumb",
        ],
      },
      1 : {
        name : "ScanNetworksResponse",
        arguments : [
          "NetworkingStatus",
          "DebugText",
          "WiFiScanResults",
          "ThreadScanResults",
        ],
      },
      2 : {
        name : "AddOrUpdateWiFiNetwork",
        arguments : [
          "Ssid",
          "Credentials",
          "Breadcrumb",
        ],
      },
      3 : {
        name : "AddOrUpdateThreadNetwork",
        arguments : [
          "OperationalDataset",
          "Breadcrumb",
        ],
      },
      4 : {
        name : "RemoveNetwork",
        arguments : [
          "NetworkID",
          "Breadcrumb",
        ],
      },
      5 : {
        name : "NetworkConfigResponse",
        arguments : [
          "NetworkingStatus",
          "DebugText",
          "NetworkIndex",
        ],
      },
      6 : {
        name : "ConnectNetwork",
        arguments : [
          "NetworkID",
          "Breadcrumb",
        ],
      },
      7 : {
        name : "ConnectNetworkResponse",
        arguments : [
          "NetworkingStatus",
          "DebugText",
          "ErrorValue",
        ],
      },
      8 : {
        name : "ReorderNetwork",
        arguments : [
          "NetworkID",
          "NetworkIndex",
          "Breadcrumb",
        ],
      },
    },
    attributes : {
      0 : "MaxNetworks",
      1 : "Networks",
      2 : "ScanMaxTimeSeconds",
      3 : "ConnectMaxTimeSeconds",
      4 : "InterfaceEnabled",
      5 : "LastNetworkingStatus",
      6 : "LastNetworkID",
      7 : "LastConnectErrorValue",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  50 : {
    name : "DiagnosticLogs",
    commands : {
      0 : {
        name : "RetrieveLogsRequest",
        arguments : [
          "Intent",
          "RequestedProtocol",
          "TransferFileDesignator",
        ],
      },
      1 : {
        name : "RetrieveLogsResponse",
        arguments : [
          "Status",
          "Content",
          "TimeStamp",
          "TimeSinceBoot",
        ],
      },
    },
    attributes : {
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  51 : {
    name : "GeneralDiagnostics",
    commands : {
      0 : {
        name : "TestEventTrigger",
        arguments : [
          "EnableKey",
          "EventTrigger",
        ],
      },
    },
    attributes : {
      0 : "NetworkInterfaces",
      1 : "RebootCount",
      2 : "UpTime",
      3 : "TotalOperationalHours",
      4 : "BootReasons",
      5 : "ActiveHardwareFaults",
      6 : "ActiveRadioFaults",
      7 : "ActiveNetworkFaults",
      8 : "TestEventTriggersEnabled",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  52 : {
    name : "SoftwareDiagnostics",
    commands : {
      0 : {
        name : "ResetWatermarks",
        arguments : [

        ],
      },
    },
    attributes : {
      0 : "ThreadMetrics",
      1 : "CurrentHeapFree",
      2 : "CurrentHeapUsed",
      3 : "CurrentHeapHighWatermark",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  53 : {
    name : "ThreadNetworkDiagnostics",
    commands : {
      0 : {
        name : "ResetCounts",
        arguments : [

        ],
      },
    },
    attributes : {
      0 : "Channel",
      1 : "RoutingRole",
      2 : "NetworkName",
      3 : "PanId",
      4 : "ExtendedPanId",
      5 : "MeshLocalPrefix",
      6 : "OverrunCount",
      7 : "NeighborTableList",
      8 : "RouteTableList",
      9 : "PartitionId",
      10 : "Weighting",
      11 : "DataVersion",
      12 : "StableDataVersion",
      13 : "LeaderRouterId",
      14 : "DetachedRoleCount",
      15 : "ChildRoleCount",
      16 : "RouterRoleCount",
      17 : "LeaderRoleCount",
      18 : "AttachAttemptCount",
      19 : "PartitionIdChangeCount",
      20 : "BetterPartitionAttachAttemptCount",
      21 : "ParentChangeCount",
      22 : "TxTotalCount",
      23 : "TxUnicastCount",
      24 : "TxBroadcastCount",
      25 : "TxAckRequestedCount",
      26 : "TxAckedCount",
      27 : "TxNoAckRequestedCount",
      28 : "TxDataCount",
      29 : "TxDataPollCount",
      30 : "TxBeaconCount",
      31 : "TxBeaconRequestCount",
      32 : "TxOtherCount",
      33 : "TxRetryCount",
      34 : "TxDirectMaxRetryExpiryCount",
      35 : "TxIndirectMaxRetryExpiryCount",
      36 : "TxErrCcaCount",
      37 : "TxErrAbortCount",
      38 : "TxErrBusyChannelCount",
      39 : "RxTotalCount",
      40 : "RxUnicastCount",
      41 : "RxBroadcastCount",
      42 : "RxDataCount",
      43 : "RxDataPollCount",
      44 : "RxBeaconCount",
      45 : "RxBeaconRequestCount",
      46 : "RxOtherCount",
      47 : "RxAddressFilteredCount",
      48 : "RxDestAddrFilteredCount",
      49 : "RxDuplicatedCount",
      50 : "RxErrNoFrameCount",
      51 : "RxErrUnknownNeighborCount",
      52 : "RxErrInvalidSrcAddrCount",
      53 : "RxErrSecCount",
      54 : "RxErrFcsCount",
      55 : "RxErrOtherCount",
      56 : "ActiveTimestamp",
      57 : "PendingTimestamp",
      58 : "Delay",
      59 : "SecurityPolicy",
      60 : "ChannelPage0Mask",
      61 : "OperationalDatasetComponents",
      62 : "ActiveNetworkFaultsList",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  54 : {
    name : "WiFiNetworkDiagnostics",
    commands : {
      0 : {
        name : "ResetCounts",
        arguments : [

        ],
      },
    },
    attributes : {
      0 : "Bssid",
      1 : "SecurityType",
      2 : "WiFiVersion",
      3 : "ChannelNumber",
      4 : "Rssi",
      5 : "BeaconLostCount",
      6 : "BeaconRxCount",
      7 : "PacketMulticastRxCount",
      8 : "PacketMulticastTxCount",
      9 : "PacketUnicastRxCount",
      10 : "PacketUnicastTxCount",
      11 : "CurrentMaxRate",
      12 : "OverrunCount",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  55 : {
    name : "EthernetNetworkDiagnostics",
    commands : {
      0 : {
        name : "ResetCounts",
        arguments : [

        ],
      },
    },
    attributes : {
      0 : "PHYRate",
      1 : "FullDuplex",
      2 : "PacketRxCount",
      3 : "PacketTxCount",
      4 : "TxErrCount",
      5 : "CollisionCount",
      6 : "OverrunCount",
      7 : "CarrierDetect",
      8 : "TimeSinceReset",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  56 : {
    name : "TimeSynchronization",
    commands : {
      0 : {
        name : "SetUtcTime",
        arguments : [
          "UtcTime",
          "Granularity",
          "TimeSource",
        ],
      },
    },
    attributes : {
      0 : "UTCTime",
      1 : "Granularity",
      2 : "TimeSource",
      3 : "TrustedTimeNodeId",
      4 : "DefaultNtp",
      5 : "TimeZone",
      6 : "DstOffset",
      7 : "LocalTime",
      8 : "TimeZoneDatabase",
      9 : "NtpServerPort",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  57 : {
    name : "BridgedDeviceBasic",
    commands : {},
    attributes : {
      1 : "VendorName",
      2 : "VendorID",
      3 : "ProductName",
      5 : "NodeLabel",
      7 : "HardwareVersion",
      8 : "HardwareVersionString",
      9 : "SoftwareVersion",
      10 : "SoftwareVersionString",
      11 : "ManufacturingDate",
      12 : "PartNumber",
      13 : "ProductURL",
      14 : "ProductLabel",
      15 : "SerialNumber",
      17 : "Reachable",
      18 : "UniqueID",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  59 : {
    name : "Switch",
    commands : {},
    attributes : {
      0 : "NumberOfPositions",
      1 : "CurrentPosition",
      2 : "MultiPressMax",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  60 : {
    name : "AdministratorCommissioning",
    commands : {
      0 : {
        name : "OpenCommissioningWindow",
        arguments : [
          "CommissioningTimeout",
          "PAKEVerifier",
          "Discriminator",
          "Iterations",
          "Salt",
        ],
      },
      1 : {
        name : "OpenBasicCommissioningWindow",
        arguments : [
          "CommissioningTimeout",
        ],
      },
      2 : {
        name : "RevokeCommissioning",
        arguments : [

        ],
      },
    },
    attributes : {
      0 : "WindowStatus",
      1 : "AdminFabricIndex",
      2 : "AdminVendorId",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  62 : {
    name : "OperationalCredentials",
    commands : {
      0 : {
        name : "AttestationRequest",
        arguments : [
          "AttestationNonce",
        ],
      },
      1 : {
        name : "AttestationResponse",
        arguments : [
          "AttestationElements",
          "Signature",
        ],
      },
      2 : {
        name : "CertificateChainRequest",
        arguments : [
          "CertificateType",
        ],
      },
      3 : {
        name : "CertificateChainResponse",
        arguments : [
          "Certificate",
        ],
      },
      4 : {
        name : "CSRRequest",
        arguments : [
          "CSRNonce",
          "IsForUpdateNOC",
        ],
      },
      5 : {
        name : "CSRResponse",
        arguments : [
          "NOCSRElements",
          "AttestationSignature",
        ],
      },
      6 : {
        name : "AddNOC",
        arguments : [
          "NOCValue",
          "ICACValue",
          "IPKValue",
          "CaseAdminSubject",
          "AdminVendorId",
        ],
      },
      7 : {
        name : "UpdateNOC",
        arguments : [
          "NOCValue",
          "ICACValue",
        ],
      },
      8 : {
        name : "NOCResponse",
        arguments : [
          "StatusCode",
          "FabricIndex",
          "DebugText",
        ],
      },
      9 : {
        name : "UpdateFabricLabel",
        arguments : [
          "Label",
        ],
      },
      10 : {
        name : "RemoveFabric",
        arguments : [
          "FabricIndex",
        ],
      },
      11 : {
        name : "AddTrustedRootCertificate",
        arguments : [
          "RootCertificate",
        ],
      },
    },
    attributes : {
      0 : "NOCs",
      1 : "Fabrics",
      2 : "SupportedFabrics",
      3 : "CommissionedFabrics",
      4 : "TrustedRootCertificates",
      5 : "CurrentFabricIndex",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  63 : {
    name : "GroupKeyManagement",
    commands : {
      0 : {
        name : "KeySetWrite",
        arguments : [
          "GroupKeySet",
        ],
      },
      1 : {
        name : "KeySetRead",
        arguments : [
          "GroupKeySetID",
        ],
      },
      2 : {
        name : "KeySetReadResponse",
        arguments : [
          "GroupKeySet",
        ],
      },
      3 : {
        name : "KeySetRemove",
        arguments : [
          "GroupKeySetID",
        ],
      },
      4 : {
        name : "KeySetReadAllIndices",
        arguments : [
          "GroupKeySetIDs",
        ],
      },
      5 : {
        name : "KeySetReadAllIndicesResponse",
        arguments : [
          "GroupKeySetIDs",
        ],
      },
    },
    attributes : {
      0 : "GroupKeyMap",
      1 : "GroupTable",
      2 : "MaxGroupsPerFabric",
      3 : "MaxGroupKeysPerFabric",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  64 : {
    name : "FixedLabel",
    commands : {},
    attributes : {
      0 : "LabelList",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  65 : {
    name : "UserLabel",
    commands : {},
    attributes : {
      0 : "LabelList",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  66 : {
    name : "ProxyConfiguration",
    commands : {},
    attributes : {
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  67 : {
    name : "ProxyDiscovery",
    commands : {},
    attributes : {
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  68 : {
    name : "ProxyValid",
    commands : {},
    attributes : {
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  69 : {
    name : "BooleanState",
    commands : {},
    attributes : {
      0 : "StateValue",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  80 : {
    name : "ModeSelect",
    commands : {
      0 : {
        name : "ChangeToMode",
        arguments : [
          "NewMode",
        ],
      },
    },
    attributes : {
      0 : "Description",
      1 : "StandardNamespace",
      2 : "SupportedModes",
      3 : "CurrentMode",
      4 : "StartUpMode",
      5 : "OnMode",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  257 : {
    name : "DoorLock",
    commands : {
      0 : {
        name : "LockDoor",
        arguments : [
          "PinCode",
        ],
      },
      1 : {
        name : "UnlockDoor",
        arguments : [
          "PinCode",
        ],
      },
      3 : {
        name : "UnlockWithTimeout",
        arguments : [
          "Timeout",
          "PinCode",
        ],
      },
      11 : {
        name : "SetWeekDaySchedule",
        arguments : [
          "WeekDayIndex",
          "UserIndex",
          "DaysMask",
          "StartHour",
          "StartMinute",
          "EndHour",
          "EndMinute",
        ],
      },
      12 : {
        name : "GetWeekDaySchedule",
        arguments : [
          "WeekDayIndex",
          "UserIndex",
        ],
      },
      12 : {
        name : "GetWeekDayScheduleResponse",
        arguments : [
          "WeekDayIndex",
          "UserIndex",
          "Status",
          "DaysMask",
          "StartHour",
          "StartMinute",
          "EndHour",
          "EndMinute",
        ],
      },
      13 : {
        name : "ClearWeekDaySchedule",
        arguments : [
          "WeekDayIndex",
          "UserIndex",
        ],
      },
      14 : {
        name : "SetYearDaySchedule",
        arguments : [
          "YearDayIndex",
          "UserIndex",
          "LocalStartTime",
          "LocalEndTime",
        ],
      },
      15 : {
        name : "GetYearDaySchedule",
        arguments : [
          "YearDayIndex",
          "UserIndex",
        ],
      },
      15 : {
        name : "GetYearDayScheduleResponse",
        arguments : [
          "YearDayIndex",
          "UserIndex",
          "Status",
          "LocalStartTime",
          "LocalEndTime",
        ],
      },
      16 : {
        name : "ClearYearDaySchedule",
        arguments : [
          "YearDayIndex",
          "UserIndex",
        ],
      },
      17 : {
        name : "SetHolidaySchedule",
        arguments : [
          "HolidayIndex",
          "LocalStartTime",
          "LocalEndTime",
          "OperatingMode",
        ],
      },
      18 : {
        name : "GetHolidaySchedule",
        arguments : [
          "HolidayIndex",
        ],
      },
      18 : {
        name : "GetHolidayScheduleResponse",
        arguments : [
          "HolidayIndex",
          "Status",
          "LocalStartTime",
          "LocalEndTime",
          "OperatingMode",
        ],
      },
      19 : {
        name : "ClearHolidaySchedule",
        arguments : [
          "HolidayIndex",
        ],
      },
      26 : {
        name : "SetUser",
        arguments : [
          "OperationType",
          "UserIndex",
          "UserName",
          "UserUniqueId",
          "UserStatus",
          "UserType",
          "CredentialRule",
        ],
      },
      27 : {
        name : "GetUser",
        arguments : [
          "UserIndex",
        ],
      },
      28 : {
        name : "GetUserResponse",
        arguments : [
          "UserIndex",
          "UserName",
          "UserUniqueId",
          "UserStatus",
          "UserType",
          "CredentialRule",
          "Credentials",
          "CreatorFabricIndex",
          "LastModifiedFabricIndex",
          "NextUserIndex",
        ],
      },
      29 : {
        name : "ClearUser",
        arguments : [
          "UserIndex",
        ],
      },
      34 : {
        name : "SetCredential",
        arguments : [
          "OperationType",
          "Credential",
          "CredentialData",
          "UserIndex",
          "UserStatus",
          "UserType",
        ],
      },
      35 : {
        name : "SetCredentialResponse",
        arguments : [
          "Status",
          "UserIndex",
          "NextCredentialIndex",
        ],
      },
      36 : {
        name : "GetCredentialStatus",
        arguments : [
          "Credential",
        ],
      },
      37 : {
        name : "GetCredentialStatusResponse",
        arguments : [
          "CredentialExists",
          "UserIndex",
          "CreatorFabricIndex",
          "LastModifiedFabricIndex",
          "NextCredentialIndex",
        ],
      },
      38 : {
        name : "ClearCredential",
        arguments : [
          "Credential",
        ],
      },
    },
    attributes : {
      0 : "LockState",
      1 : "LockType",
      2 : "ActuatorEnabled",
      3 : "DoorState",
      4 : "DoorOpenEvents",
      5 : "DoorClosedEvents",
      6 : "OpenPeriod",
      17 : "NumberOfTotalUsersSupported",
      18 : "NumberOfPINUsersSupported",
      19 : "NumberOfRFIDUsersSupported",
      20 : "NumberOfWeekDaySchedulesSupportedPerUser",
      21 : "NumberOfYearDaySchedulesSupportedPerUser",
      22 : "NumberOfHolidaySchedulesSupported",
      23 : "MaxPINCodeLength",
      24 : "MinPINCodeLength",
      25 : "MaxRFIDCodeLength",
      26 : "MinRFIDCodeLength",
      27 : "CredentialRulesSupport",
      28 : "NumberOfCredentialsSupportedPerUser",
      33 : "Language",
      34 : "LEDSettings",
      35 : "AutoRelockTime",
      36 : "SoundVolume",
      37 : "OperatingMode",
      38 : "SupportedOperatingModes",
      39 : "DefaultConfigurationRegister",
      40 : "EnableLocalProgramming",
      41 : "EnableOneTouchLocking",
      42 : "EnableInsideStatusLED",
      43 : "EnablePrivacyModeButton",
      44 : "LocalProgrammingFeatures",
      48 : "WrongCodeEntryLimit",
      49 : "UserCodeTemporaryDisableTime",
      50 : "SendPINOverTheAir",
      51 : "RequirePINforRemoteOperation",
      53 : "ExpiringUserTimeout",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  258 : {
    name : "WindowCovering",
    commands : {
      0 : {
        name : "UpOrOpen",
        arguments : [

        ],
      },
      1 : {
        name : "DownOrClose",
        arguments : [

        ],
      },
      2 : {
        name : "StopMotion",
        arguments : [

        ],
      },
      4 : {
        name : "GoToLiftValue",
        arguments : [
          "LiftValue",
        ],
      },
      5 : {
        name : "GoToLiftPercentage",
        arguments : [
          "LiftPercent100thsValue",
        ],
      },
      7 : {
        name : "GoToTiltValue",
        arguments : [
          "TiltValue",
        ],
      },
      8 : {
        name : "GoToTiltPercentage",
        arguments : [
          "TiltPercent100thsValue",
        ],
      },
    },
    attributes : {
      0 : "Type",
      1 : "PhysicalClosedLimitLift",
      2 : "PhysicalClosedLimitTilt",
      3 : "CurrentPositionLift",
      4 : "CurrentPositionTilt",
      5 : "NumberOfActuationsLift",
      6 : "NumberOfActuationsTilt",
      7 : "ConfigStatus",
      8 : "CurrentPositionLiftPercentage",
      9 : "CurrentPositionTiltPercentage",
      10 : "OperationalStatus",
      11 : "TargetPositionLiftPercent100ths",
      12 : "TargetPositionTiltPercent100ths",
      13 : "EndProductType",
      14 : "CurrentPositionLiftPercent100ths",
      15 : "CurrentPositionTiltPercent100ths",
      16 : "InstalledOpenLimitLift",
      17 : "InstalledClosedLimitLift",
      18 : "InstalledOpenLimitTilt",
      19 : "InstalledClosedLimitTilt",
      23 : "Mode",
      26 : "SafetyStatus",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  259 : {
    name : "BarrierControl",
    commands : {
      0 : {
        name : "BarrierControlGoToPercent",
        arguments : [
          "PercentOpen",
        ],
      },
      1 : {
        name : "BarrierControlStop",
        arguments : [

        ],
      },
    },
    attributes : {
      1 : "BarrierMovingState",
      2 : "BarrierSafetyStatus",
      3 : "BarrierCapabilities",
      4 : "BarrierOpenEvents",
      5 : "BarrierCloseEvents",
      6 : "BarrierCommandOpenEvents",
      7 : "BarrierCommandCloseEvents",
      8 : "BarrierOpenPeriod",
      9 : "BarrierClosePeriod",
      10 : "BarrierPosition",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  512 : {
    name : "PumpConfigurationAndControl",
    commands : {},
    attributes : {
      0 : "MaxPressure",
      1 : "MaxSpeed",
      2 : "MaxFlow",
      3 : "MinConstPressure",
      4 : "MaxConstPressure",
      5 : "MinCompPressure",
      6 : "MaxCompPressure",
      7 : "MinConstSpeed",
      8 : "MaxConstSpeed",
      9 : "MinConstFlow",
      10 : "MaxConstFlow",
      11 : "MinConstTemp",
      12 : "MaxConstTemp",
      16 : "PumpStatus",
      17 : "EffectiveOperationMode",
      18 : "EffectiveControlMode",
      19 : "Capacity",
      20 : "Speed",
      21 : "LifetimeRunningHours",
      22 : "Power",
      23 : "LifetimeEnergyConsumed",
      32 : "OperationMode",
      33 : "ControlMode",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  513 : {
    name : "Thermostat",
    commands : {
      0 : {
        name : "SetpointRaiseLower",
        arguments : [
          "Mode",
          "Amount",
        ],
      },
      0 : {
        name : "GetWeeklyScheduleResponse",
        arguments : [
          "NumberOfTransitionsForSequence",
          "DayOfWeekForSequence",
          "ModeForSequence",
          "Transitions",
        ],
      },
      1 : {
        name : "SetWeeklySchedule",
        arguments : [
          "NumberOfTransitionsForSequence",
          "DayOfWeekForSequence",
          "ModeForSequence",
          "Transitions",
        ],
      },
      2 : {
        name : "GetWeeklySchedule",
        arguments : [
          "DaysToReturn",
          "ModeToReturn",
        ],
      },
      3 : {
        name : "ClearWeeklySchedule",
        arguments : [

        ],
      },
    },
    attributes : {
      0 : "LocalTemperature",
      1 : "OutdoorTemperature",
      2 : "Occupancy",
      3 : "AbsMinHeatSetpointLimit",
      4 : "AbsMaxHeatSetpointLimit",
      5 : "AbsMinCoolSetpointLimit",
      6 : "AbsMaxCoolSetpointLimit",
      7 : "PICoolingDemand",
      8 : "PIHeatingDemand",
      9 : "HVACSystemTypeConfiguration",
      16 : "LocalTemperatureCalibration",
      17 : "OccupiedCoolingSetpoint",
      18 : "OccupiedHeatingSetpoint",
      19 : "UnoccupiedCoolingSetpoint",
      20 : "UnoccupiedHeatingSetpoint",
      21 : "MinHeatSetpointLimit",
      22 : "MaxHeatSetpointLimit",
      23 : "MinCoolSetpointLimit",
      24 : "MaxCoolSetpointLimit",
      25 : "MinSetpointDeadBand",
      26 : "RemoteSensing",
      27 : "ControlSequenceOfOperation",
      28 : "SystemMode",
      30 : "ThermostatRunningMode",
      32 : "StartOfWeek",
      33 : "NumberOfWeeklyTransitions",
      34 : "NumberOfDailyTransitions",
      35 : "TemperatureSetpointHold",
      36 : "TemperatureSetpointHoldDuration",
      37 : "ThermostatProgrammingOperationMode",
      41 : "ThermostatRunningState",
      48 : "SetpointChangeSource",
      49 : "SetpointChangeAmount",
      50 : "SetpointChangeSourceTimestamp",
      52 : "OccupiedSetback",
      53 : "OccupiedSetbackMin",
      54 : "OccupiedSetbackMax",
      55 : "UnoccupiedSetback",
      56 : "UnoccupiedSetbackMin",
      57 : "UnoccupiedSetbackMax",
      58 : "EmergencyHeatDelta",
      64 : "ACType",
      65 : "ACCapacity",
      66 : "ACRefrigerantType",
      67 : "ACCompressorType",
      68 : "ACErrorCode",
      69 : "ACLouverPosition",
      70 : "ACCoilTemperature",
      71 : "ACCapacityformat",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  514 : {
    name : "FanControl",
    commands : {},
    attributes : {
      0 : "FanMode",
      1 : "FanModeSequence",
      2 : "PercentSetting",
      3 : "PercentCurrent",
      4 : "SpeedMax",
      5 : "SpeedSetting",
      6 : "SpeedCurrent",
      7 : "RockSupport",
      8 : "RockSetting",
      9 : "WindSupport",
      10 : "WindSetting",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  516 : {
    name : "ThermostatUserInterfaceConfiguration",
    commands : {},
    attributes : {
      0 : "TemperatureDisplayMode",
      1 : "KeypadLockout",
      2 : "ScheduleProgrammingVisibility",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  768 : {
    name : "ColorControl",
    commands : {
      0 : {
        name : "MoveToHue",
        arguments : [
          "Hue",
          "Direction",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      1 : {
        name : "MoveHue",
        arguments : [
          "MoveMode",
          "Rate",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      2 : {
        name : "StepHue",
        arguments : [
          "StepMode",
          "StepSize",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      3 : {
        name : "MoveToSaturation",
        arguments : [
          "Saturation",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      4 : {
        name : "MoveSaturation",
        arguments : [
          "MoveMode",
          "Rate",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      5 : {
        name : "StepSaturation",
        arguments : [
          "StepMode",
          "StepSize",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      6 : {
        name : "MoveToHueAndSaturation",
        arguments : [
          "Hue",
          "Saturation",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      7 : {
        name : "MoveToColor",
        arguments : [
          "ColorX",
          "ColorY",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      8 : {
        name : "MoveColor",
        arguments : [
          "RateX",
          "RateY",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      9 : {
        name : "StepColor",
        arguments : [
          "StepX",
          "StepY",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      10 : {
        name : "MoveToColorTemperature",
        arguments : [
          "ColorTemperature",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      64 : {
        name : "EnhancedMoveToHue",
        arguments : [
          "EnhancedHue",
          "Direction",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      65 : {
        name : "EnhancedMoveHue",
        arguments : [
          "MoveMode",
          "Rate",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      66 : {
        name : "EnhancedStepHue",
        arguments : [
          "StepMode",
          "StepSize",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      67 : {
        name : "EnhancedMoveToHueAndSaturation",
        arguments : [
          "EnhancedHue",
          "Saturation",
          "TransitionTime",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      68 : {
        name : "ColorLoopSet",
        arguments : [
          "UpdateFlags",
          "Action",
          "Direction",
          "Time",
          "StartHue",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      71 : {
        name : "StopMoveStep",
        arguments : [
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      75 : {
        name : "MoveColorTemperature",
        arguments : [
          "MoveMode",
          "Rate",
          "ColorTemperatureMinimumMireds",
          "ColorTemperatureMaximumMireds",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
      76 : {
        name : "StepColorTemperature",
        arguments : [
          "StepMode",
          "StepSize",
          "TransitionTime",
          "ColorTemperatureMinimumMireds",
          "ColorTemperatureMaximumMireds",
          "OptionsMask",
          "OptionsOverride",
        ],
      },
    },
    attributes : {
      0 : "CurrentHue",
      1 : "CurrentSaturation",
      2 : "RemainingTime",
      3 : "CurrentX",
      4 : "CurrentY",
      5 : "DriftCompensation",
      6 : "CompensationText",
      7 : "ColorTemperatureMireds",
      8 : "ColorMode",
      15 : "Options",
      16 : "NumberOfPrimaries",
      17 : "Primary1X",
      18 : "Primary1Y",
      19 : "Primary1Intensity",
      21 : "Primary2X",
      22 : "Primary2Y",
      23 : "Primary2Intensity",
      25 : "Primary3X",
      26 : "Primary3Y",
      27 : "Primary3Intensity",
      32 : "Primary4X",
      33 : "Primary4Y",
      34 : "Primary4Intensity",
      36 : "Primary5X",
      37 : "Primary5Y",
      38 : "Primary5Intensity",
      40 : "Primary6X",
      41 : "Primary6Y",
      42 : "Primary6Intensity",
      48 : "WhitePointX",
      49 : "WhitePointY",
      50 : "ColorPointRX",
      51 : "ColorPointRY",
      52 : "ColorPointRIntensity",
      54 : "ColorPointGX",
      55 : "ColorPointGY",
      56 : "ColorPointGIntensity",
      58 : "ColorPointBX",
      59 : "ColorPointBY",
      60 : "ColorPointBIntensity",
      16384 : "EnhancedCurrentHue",
      16385 : "EnhancedColorMode",
      16386 : "ColorLoopActive",
      16387 : "ColorLoopDirection",
      16388 : "ColorLoopTime",
      16389 : "ColorLoopStartEnhancedHue",
      16390 : "ColorLoopStoredEnhancedHue",
      16394 : "ColorCapabilities",
      16395 : "ColorTempPhysicalMinMireds",
      16396 : "ColorTempPhysicalMaxMireds",
      16397 : "CoupleColorTempToLevelMinMireds",
      16400 : "StartUpColorTemperatureMireds",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  769 : {
    name : "BallastConfiguration",
    commands : {},
    attributes : {
      0 : "PhysicalMinLevel",
      1 : "PhysicalMaxLevel",
      2 : "BallastStatus",
      16 : "MinLevel",
      17 : "MaxLevel",
      20 : "IntrinsicBalanceFactor",
      21 : "BallastFactorAdjustment",
      32 : "LampQuantity",
      48 : "LampType",
      49 : "LampManufacturer",
      50 : "LampRatedHours",
      51 : "LampBurnHours",
      52 : "LampAlarmMode",
      53 : "LampBurnHoursTripPoint",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1024 : {
    name : "IlluminanceMeasurement",
    commands : {},
    attributes : {
      0 : "MeasuredValue",
      1 : "MinMeasuredValue",
      2 : "MaxMeasuredValue",
      3 : "Tolerance",
      4 : "LightSensorType",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1026 : {
    name : "TemperatureMeasurement",
    commands : {},
    attributes : {
      0 : "MeasuredValue",
      1 : "MinMeasuredValue",
      2 : "MaxMeasuredValue",
      3 : "Tolerance",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1027 : {
    name : "PressureMeasurement",
    commands : {},
    attributes : {
      0 : "MeasuredValue",
      1 : "MinMeasuredValue",
      2 : "MaxMeasuredValue",
      3 : "Tolerance",
      16 : "ScaledValue",
      17 : "MinScaledValue",
      18 : "MaxScaledValue",
      19 : "ScaledTolerance",
      20 : "Scale",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1028 : {
    name : "FlowMeasurement",
    commands : {},
    attributes : {
      0 : "MeasuredValue",
      1 : "MinMeasuredValue",
      2 : "MaxMeasuredValue",
      3 : "Tolerance",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1029 : {
    name : "RelativeHumidityMeasurement",
    commands : {},
    attributes : {
      0 : "MeasuredValue",
      1 : "MinMeasuredValue",
      2 : "MaxMeasuredValue",
      3 : "Tolerance",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1030 : {
    name : "OccupancySensing",
    commands : {},
    attributes : {
      0 : "Occupancy",
      1 : "OccupancySensorType",
      2 : "OccupancySensorTypeBitmap",
      16 : "PirOccupiedToUnoccupiedDelay",
      17 : "PirUnoccupiedToOccupiedDelay",
      18 : "PirUnoccupiedToOccupiedThreshold",
      32 : "UltrasonicOccupiedToUnoccupiedDelay",
      33 : "UltrasonicUnoccupiedToOccupiedDelay",
      34 : "UltrasonicUnoccupiedToOccupiedThreshold",
      48 : "PhysicalContactOccupiedToUnoccupiedDelay",
      49 : "PhysicalContactUnoccupiedToOccupiedDelay",
      50 : "PhysicalContactUnoccupiedToOccupiedThreshold",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1283 : {
    name : "WakeOnLan",
    commands : {},
    attributes : {
      0 : "MACAddress",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1284 : {
    name : "Channel",
    commands : {
      0 : {
        name : "ChangeChannel",
        arguments : [
          "Match",
        ],
      },
      1 : {
        name : "ChangeChannelResponse",
        arguments : [
          "Status",
          "Data",
        ],
      },
      2 : {
        name : "ChangeChannelByNumber",
        arguments : [
          "MajorNumber",
          "MinorNumber",
        ],
      },
      3 : {
        name : "SkipChannel",
        arguments : [
          "Count",
        ],
      },
    },
    attributes : {
      0 : "ChannelList",
      1 : "Lineup",
      2 : "CurrentChannel",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1285 : {
    name : "TargetNavigator",
    commands : {
      0 : {
        name : "NavigateTarget",
        arguments : [
          "Target",
          "Data",
        ],
      },
      1 : {
        name : "NavigateTargetResponse",
        arguments : [
          "Status",
          "Data",
        ],
      },
    },
    attributes : {
      0 : "TargetList",
      1 : "CurrentTarget",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1286 : {
    name : "MediaPlayback",
    commands : {
      0 : {
        name : "Play",
        arguments : [

        ],
      },
      1 : {
        name : "Pause",
        arguments : [

        ],
      },
      2 : {
        name : "StopPlayback",
        arguments : [

        ],
      },
      3 : {
        name : "StartOver",
        arguments : [

        ],
      },
      4 : {
        name : "Previous",
        arguments : [

        ],
      },
      5 : {
        name : "Next",
        arguments : [

        ],
      },
      6 : {
        name : "Rewind",
        arguments : [

        ],
      },
      7 : {
        name : "FastForward",
        arguments : [

        ],
      },
      8 : {
        name : "SkipForward",
        arguments : [
          "DeltaPositionMilliseconds",
        ],
      },
      9 : {
        name : "SkipBackward",
        arguments : [
          "DeltaPositionMilliseconds",
        ],
      },
      10 : {
        name : "PlaybackResponse",
        arguments : [
          "Status",
          "Data",
        ],
      },
      11 : {
        name : "Seek",
        arguments : [
          "Position",
        ],
      },
    },
    attributes : {
      0 : "CurrentState",
      1 : "StartTime",
      2 : "Duration",
      3 : "SampledPosition",
      4 : "PlaybackSpeed",
      5 : "SeekRangeEnd",
      6 : "SeekRangeStart",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1287 : {
    name : "MediaInput",
    commands : {
      0 : {
        name : "SelectInput",
        arguments : [
          "Index",
        ],
      },
      1 : {
        name : "ShowInputStatus",
        arguments : [

        ],
      },
      2 : {
        name : "HideInputStatus",
        arguments : [

        ],
      },
      3 : {
        name : "RenameInput",
        arguments : [
          "Index",
          "Name",
        ],
      },
    },
    attributes : {
      0 : "InputList",
      1 : "CurrentInput",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1288 : {
    name : "LowPower",
    commands : {
      0 : {
        name : "Sleep",
        arguments : [

        ],
      },
    },
    attributes : {
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1289 : {
    name : "KeypadInput",
    commands : {
      0 : {
        name : "SendKey",
        arguments : [
          "KeyCode",
        ],
      },
      1 : {
        name : "SendKeyResponse",
        arguments : [
          "Status",
        ],
      },
    },
    attributes : {
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1290 : {
    name : "ContentLauncher",
    commands : {
      0 : {
        name : "LaunchContent",
        arguments : [
          "Search",
          "AutoPlay",
          "Data",
        ],
      },
      1 : {
        name : "LaunchURL",
        arguments : [
          "ContentURL",
          "DisplayString",
          "BrandingInformation",
        ],
      },
      2 : {
        name : "LaunchResponse",
        arguments : [
          "Status",
          "Data",
        ],
      },
    },
    attributes : {
      0 : "AcceptHeader",
      1 : "SupportedStreamingProtocols",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1291 : {
    name : "AudioOutput",
    commands : {
      0 : {
        name : "SelectOutput",
        arguments : [
          "Index",
        ],
      },
      1 : {
        name : "RenameOutput",
        arguments : [
          "Index",
          "Name",
        ],
      },
    },
    attributes : {
      0 : "OutputList",
      1 : "CurrentOutput",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1292 : {
    name : "ApplicationLauncher",
    commands : {
      0 : {
        name : "LaunchApp",
        arguments : [
          "Application",
          "Data",
        ],
      },
      1 : {
        name : "StopApp",
        arguments : [
          "Application",
        ],
      },
      2 : {
        name : "HideApp",
        arguments : [
          "Application",
        ],
      },
      3 : {
        name : "LauncherResponse",
        arguments : [
          "Status",
          "Data",
        ],
      },
    },
    attributes : {
      0 : "CatalogList",
      1 : "CurrentApp",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1293 : {
    name : "ApplicationBasic",
    commands : {},
    attributes : {
      0 : "VendorName",
      1 : "VendorID",
      2 : "ApplicationName",
      3 : "ProductID",
      4 : "Application",
      5 : "Status",
      6 : "ApplicationVersion",
      7 : "AllowedVendorList",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  1294 : {
    name : "AccountLogin",
    commands : {
      0 : {
        name : "GetSetupPIN",
        arguments : [
          "TempAccountIdentifier",
        ],
      },
      1 : {
        name : "GetSetupPINResponse",
        arguments : [
          "SetupPIN",
        ],
      },
      2 : {
        name : "Login",
        arguments : [
          "TempAccountIdentifier",
          "SetupPIN",
        ],
      },
      3 : {
        name : "Logout",
        arguments : [

        ],
      },
    },
    attributes : {
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  2820 : {
    name : "ElectricalMeasurement",
    commands : {
      0 : {
        name : "GetProfileInfoResponseCommand",
        arguments : [
          "ProfileCount",
          "ProfileIntervalPeriod",
          "MaxNumberOfIntervals",
          "ListOfAttributes",
        ],
      },
      0 : {
        name : "GetProfileInfoCommand",
        arguments : [

        ],
      },
      1 : {
        name : "GetMeasurementProfileResponseCommand",
        arguments : [
          "StartTime",
          "Status",
          "ProfileIntervalPeriod",
          "NumberOfIntervalsDelivered",
          "AttributeId",
          "Intervals",
        ],
      },
      1 : {
        name : "GetMeasurementProfileCommand",
        arguments : [
          "AttributeId",
          "StartTime",
          "NumberOfIntervals",
        ],
      },
    },
    attributes : {
      0 : "MeasurementType",
      256 : "DcVoltage",
      257 : "DcVoltageMin",
      258 : "DcVoltageMax",
      259 : "DcCurrent",
      260 : "DcCurrentMin",
      261 : "DcCurrentMax",
      262 : "DcPower",
      263 : "DcPowerMin",
      264 : "DcPowerMax",
      512 : "DcVoltageMultiplier",
      513 : "DcVoltageDivisor",
      514 : "DcCurrentMultiplier",
      515 : "DcCurrentDivisor",
      516 : "DcPowerMultiplier",
      517 : "DcPowerDivisor",
      768 : "AcFrequency",
      769 : "AcFrequencyMin",
      770 : "AcFrequencyMax",
      771 : "NeutralCurrent",
      772 : "TotalActivePower",
      773 : "TotalReactivePower",
      774 : "TotalApparentPower",
      775 : "Measured1stHarmonicCurrent",
      776 : "Measured3rdHarmonicCurrent",
      777 : "Measured5thHarmonicCurrent",
      778 : "Measured7thHarmonicCurrent",
      779 : "Measured9thHarmonicCurrent",
      780 : "Measured11thHarmonicCurrent",
      781 : "MeasuredPhase1stHarmonicCurrent",
      782 : "MeasuredPhase3rdHarmonicCurrent",
      783 : "MeasuredPhase5thHarmonicCurrent",
      784 : "MeasuredPhase7thHarmonicCurrent",
      785 : "MeasuredPhase9thHarmonicCurrent",
      786 : "MeasuredPhase11thHarmonicCurrent",
      1024 : "AcFrequencyMultiplier",
      1025 : "AcFrequencyDivisor",
      1026 : "PowerMultiplier",
      1027 : "PowerDivisor",
      1028 : "HarmonicCurrentMultiplier",
      1029 : "PhaseHarmonicCurrentMultiplier",
      1280 : "InstantaneousVoltage",
      1281 : "InstantaneousLineCurrent",
      1282 : "InstantaneousActiveCurrent",
      1283 : "InstantaneousReactiveCurrent",
      1284 : "InstantaneousPower",
      1285 : "RmsVoltage",
      1286 : "RmsVoltageMin",
      1287 : "RmsVoltageMax",
      1288 : "RmsCurrent",
      1289 : "RmsCurrentMin",
      1290 : "RmsCurrentMax",
      1291 : "ActivePower",
      1292 : "ActivePowerMin",
      1293 : "ActivePowerMax",
      1294 : "ReactivePower",
      1295 : "ApparentPower",
      1296 : "PowerFactor",
      1297 : "AverageRmsVoltageMeasurementPeriod",
      1299 : "AverageRmsUnderVoltageCounter",
      1300 : "RmsExtremeOverVoltagePeriod",
      1301 : "RmsExtremeUnderVoltagePeriod",
      1302 : "RmsVoltageSagPeriod",
      1303 : "RmsVoltageSwellPeriod",
      1536 : "AcVoltageMultiplier",
      1537 : "AcVoltageDivisor",
      1538 : "AcCurrentMultiplier",
      1539 : "AcCurrentDivisor",
      1540 : "AcPowerMultiplier",
      1541 : "AcPowerDivisor",
      1792 : "OverloadAlarmsMask",
      1793 : "VoltageOverload",
      1794 : "CurrentOverload",
      2048 : "AcOverloadAlarmsMask",
      2049 : "AcVoltageOverload",
      2050 : "AcCurrentOverload",
      2051 : "AcActivePowerOverload",
      2052 : "AcReactivePowerOverload",
      2053 : "AverageRmsOverVoltage",
      2054 : "AverageRmsUnderVoltage",
      2055 : "RmsExtremeOverVoltage",
      2056 : "RmsExtremeUnderVoltage",
      2057 : "RmsVoltageSag",
      2058 : "RmsVoltageSwell",
      2305 : "LineCurrentPhaseB",
      2306 : "ActiveCurrentPhaseB",
      2307 : "ReactiveCurrentPhaseB",
      2309 : "RmsVoltagePhaseB",
      2310 : "RmsVoltageMinPhaseB",
      2311 : "RmsVoltageMaxPhaseB",
      2312 : "RmsCurrentPhaseB",
      2313 : "RmsCurrentMinPhaseB",
      2314 : "RmsCurrentMaxPhaseB",
      2315 : "ActivePowerPhaseB",
      2316 : "ActivePowerMinPhaseB",
      2317 : "ActivePowerMaxPhaseB",
      2318 : "ReactivePowerPhaseB",
      2319 : "ApparentPowerPhaseB",
      2320 : "PowerFactorPhaseB",
      2321 : "AverageRmsVoltageMeasurementPeriodPhaseB",
      2322 : "AverageRmsOverVoltageCounterPhaseB",
      2323 : "AverageRmsUnderVoltageCounterPhaseB",
      2324 : "RmsExtremeOverVoltagePeriodPhaseB",
      2325 : "RmsExtremeUnderVoltagePeriodPhaseB",
      2326 : "RmsVoltageSagPeriodPhaseB",
      2327 : "RmsVoltageSwellPeriodPhaseB",
      2561 : "LineCurrentPhaseC",
      2562 : "ActiveCurrentPhaseC",
      2563 : "ReactiveCurrentPhaseC",
      2565 : "RmsVoltagePhaseC",
      2566 : "RmsVoltageMinPhaseC",
      2567 : "RmsVoltageMaxPhaseC",
      2568 : "RmsCurrentPhaseC",
      2569 : "RmsCurrentMinPhaseC",
      2570 : "RmsCurrentMaxPhaseC",
      2571 : "ActivePowerPhaseC",
      2572 : "ActivePowerMinPhaseC",
      2573 : "ActivePowerMaxPhaseC",
      2574 : "ReactivePowerPhaseC",
      2575 : "ApparentPowerPhaseC",
      2576 : "PowerFactorPhaseC",
      2577 : "AverageRmsVoltageMeasurementPeriodPhaseC",
      2578 : "AverageRmsOverVoltageCounterPhaseC",
      2579 : "AverageRmsUnderVoltageCounterPhaseC",
      2580 : "RmsExtremeOverVoltagePeriodPhaseC",
      2581 : "RmsExtremeUnderVoltagePeriodPhaseC",
      2582 : "RmsVoltageSagPeriodPhaseC",
      2583 : "RmsVoltageSwellPeriodPhaseC",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  4166 : {
    name : "ClientMonitoring",
    commands : {
      0 : {
        name : "RegisterClientMonitoring",
        arguments : [
          "ClientNodeId",
          "ICid",
        ],
      },
      1 : {
        name : "StayAwakeRequest",
        arguments : [

        ],
      },
    },
    attributes : {
      0 : "IdleModeInterval",
      1 : "ActiveModeInterval",
      2 : "ActiveModeThreshold",
      3 : "ExpectedClients",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  4294048773 : {
    name : "UnitTesting",
    commands : {
      0 : {
        name : "Test",
        arguments : [

        ],
      },
      0 : {
        name : "TestSpecificResponse",
        arguments : [
          "ReturnValue",
        ],
      },
      1 : {
        name : "TestNotHandled",
        arguments : [

        ],
      },
      1 : {
        name : "TestAddArgumentsResponse",
        arguments : [
          "ReturnValue",
        ],
      },
      2 : {
        name : "TestSpecific",
        arguments : [

        ],
      },
      2 : {
        name : "TestSimpleArgumentResponse",
        arguments : [
          "ReturnValue",
        ],
      },
      3 : {
        name : "TestUnknownCommand",
        arguments : [

        ],
      },
      3 : {
        name : "TestStructArrayArgumentResponse",
        arguments : [
          "Arg1",
          "Arg2",
          "Arg3",
          "Arg4",
          "Arg5",
          "Arg6",
        ],
      },
      4 : {
        name : "TestAddArguments",
        arguments : [
          "Arg1",
          "Arg2",
        ],
      },
      4 : {
        name : "TestListInt8UReverseResponse",
        arguments : [
          "Arg1",
        ],
      },
      5 : {
        name : "TestSimpleArgumentRequest",
        arguments : [
          "Arg1",
        ],
      },
      5 : {
        name : "TestEnumsResponse",
        arguments : [
          "Arg1",
          "Arg2",
        ],
      },
      6 : {
        name : "TestStructArrayArgumentRequest",
        arguments : [
          "Arg1",
          "Arg2",
          "Arg3",
          "Arg4",
          "Arg5",
          "Arg6",
        ],
      },
      6 : {
        name : "TestNullableOptionalResponse",
        arguments : [
          "WasPresent",
          "WasNull",
          "Value",
          "OriginalValue",
        ],
      },
      7 : {
        name : "TestStructArgumentRequest",
        arguments : [
          "Arg1",
        ],
      },
      7 : {
        name : "TestComplexNullableOptionalResponse",
        arguments : [
          "NullableIntWasNull",
          "NullableIntValue",
          "OptionalIntWasPresent",
          "OptionalIntValue",
          "NullableOptionalIntWasPresent",
          "NullableOptionalIntWasNull",
          "NullableOptionalIntValue",
          "NullableStringWasNull",
          "NullableStringValue",
          "OptionalStringWasPresent",
          "OptionalStringValue",
          "NullableOptionalStringWasPresent",
          "NullableOptionalStringWasNull",
          "NullableOptionalStringValue",
          "NullableStructWasNull",
          "NullableStructValue",
          "OptionalStructWasPresent",
          "OptionalStructValue",
          "NullableOptionalStructWasPresent",
          "NullableOptionalStructWasNull",
          "NullableOptionalStructValue",
          "NullableListWasNull",
          "NullableListValue",
          "OptionalListWasPresent",
          "OptionalListValue",
          "NullableOptionalListWasPresent",
          "NullableOptionalListWasNull",
          "NullableOptionalListValue",
        ],
      },
      8 : {
        name : "TestNestedStructArgumentRequest",
        arguments : [
          "Arg1",
        ],
      },
      8 : {
        name : "BooleanResponse",
        arguments : [
          "Value",
        ],
      },
      9 : {
        name : "TestListStructArgumentRequest",
        arguments : [
          "Arg1",
        ],
      },
      9 : {
        name : "SimpleStructResponse",
        arguments : [
          "Arg1",
        ],
      },
      10 : {
        name : "TestListInt8UArgumentRequest",
        arguments : [
          "Arg1",
        ],
      },
      10 : {
        name : "TestEmitTestEventResponse",
        arguments : [
          "Value",
        ],
      },
      11 : {
        name : "TestNestedStructListArgumentRequest",
        arguments : [
          "Arg1",
        ],
      },
      11 : {
        name : "TestEmitTestFabricScopedEventResponse",
        arguments : [
          "Value",
        ],
      },
      12 : {
        name : "TestListNestedStructListArgumentRequest",
        arguments : [
          "Arg1",
        ],
      },
      13 : {
        name : "TestListInt8UReverseRequest",
        arguments : [
          "Arg1",
        ],
      },
      14 : {
        name : "TestEnumsRequest",
        arguments : [
          "Arg1",
          "Arg2",
        ],
      },
      15 : {
        name : "TestNullableOptionalRequest",
        arguments : [
          "Arg1",
        ],
      },
      16 : {
        name : "TestComplexNullableOptionalRequest",
        arguments : [
          "NullableInt",
          "OptionalInt",
          "NullableOptionalInt",
          "NullableString",
          "OptionalString",
          "NullableOptionalString",
          "NullableStruct",
          "OptionalStruct",
          "NullableOptionalStruct",
          "NullableList",
          "OptionalList",
          "NullableOptionalList",
        ],
      },
      17 : {
        name : "SimpleStructEchoRequest",
        arguments : [
          "Arg1",
        ],
      },
      18 : {
        name : "TimedInvokeRequest",
        arguments : [

        ],
      },
      19 : {
        name : "TestSimpleOptionalArgumentRequest",
        arguments : [
          "Arg1",
        ],
      },
      20 : {
        name : "TestEmitTestEventRequest",
        arguments : [
          "Arg1",
          "Arg2",
          "Arg3",
        ],
      },
      21 : {
        name : "TestEmitTestFabricScopedEventRequest",
        arguments : [
          "Arg1",
        ],
      },
    },
    attributes : {
      0 : "Boolean",
      1 : "Bitmap8",
      2 : "Bitmap16",
      3 : "Bitmap32",
      4 : "Bitmap64",
      5 : "Int8u",
      6 : "Int16u",
      7 : "Int24u",
      8 : "Int32u",
      9 : "Int40u",
      10 : "Int48u",
      11 : "Int56u",
      12 : "Int64u",
      13 : "Int8s",
      14 : "Int16s",
      15 : "Int24s",
      16 : "Int32s",
      17 : "Int40s",
      18 : "Int48s",
      19 : "Int56s",
      20 : "Int64s",
      21 : "Enum8",
      22 : "Enum16",
      23 : "FloatSingle",
      24 : "FloatDouble",
      25 : "OctetString",
      26 : "ListInt8u",
      27 : "ListOctetString",
      28 : "ListStructOctetString",
      29 : "LongOctetString",
      30 : "CharString",
      31 : "LongCharString",
      32 : "EpochUs",
      33 : "EpochS",
      34 : "VendorId",
      35 : "ListNullablesAndOptionalsStruct",
      36 : "EnumAttr",
      37 : "StructAttr",
      38 : "RangeRestrictedInt8u",
      39 : "RangeRestrictedInt8s",
      40 : "RangeRestrictedInt16u",
      41 : "RangeRestrictedInt16s",
      42 : "ListLongOctetString",
      43 : "ListFabricScoped",
      48 : "TimedWriteBoolean",
      49 : "GeneralErrorBoolean",
      50 : "ClusterErrorBoolean",
      255 : "Unsupported",
      16384 : "NullableBoolean",
      16385 : "NullableBitmap8",
      16386 : "NullableBitmap16",
      16387 : "NullableBitmap32",
      16388 : "NullableBitmap64",
      16389 : "NullableInt8u",
      16390 : "NullableInt16u",
      16391 : "NullableInt24u",
      16392 : "NullableInt32u",
      16393 : "NullableInt40u",
      16394 : "NullableInt48u",
      16395 : "NullableInt56u",
      16396 : "NullableInt64u",
      16397 : "NullableInt8s",
      16398 : "NullableInt16s",
      16399 : "NullableInt24s",
      16400 : "NullableInt32s",
      16401 : "NullableInt40s",
      16402 : "NullableInt48s",
      16403 : "NullableInt56s",
      16404 : "NullableInt64s",
      16405 : "NullableEnum8",
      16406 : "NullableEnum16",
      16407 : "NullableFloatSingle",
      16408 : "NullableFloatDouble",
      16409 : "NullableOctetString",
      16414 : "NullableCharString",
      16420 : "NullableEnumAttr",
      16421 : "NullableStruct",
      16422 : "NullableRangeRestrictedInt8u",
      16423 : "NullableRangeRestrictedInt8s",
      16424 : "NullableRangeRestrictedInt16u",
      16425 : "NullableRangeRestrictedInt16s",
      16426 : "WriteOnlyInt8u",
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },
  4294048774 : {
    name : "FaultInjection",
    commands : {
      0 : {
        name : "FailAtFault",
        arguments : [
          "Type",
          "Id",
          "NumCallsToSkip",
          "NumCallsToFail",
          "TakeMutex",
        ],
      },
      1 : {
        name : "FailRandomlyAtFault",
        arguments : [
          "Type",
          "Id",
          "Percentage",
        ],
      },
    },
    attributes : {
      65528 : "GeneratedCommandList",
      65529 : "AcceptedCommandList",
      65531 : "AttributeList",
      65532 : "FeatureMap",
      65533 : "ClusterRevision",
    },
  },

  enums : {
    "ActionErrorEnum" : [
      "Unknown",
      "Interrupted",
    ], //
    "ActionStateEnum" : [
      "Inactive",
      "Active",
      "Paused",
      "Disabled",
    ], //
    "ActionTypeEnum" : [
      "Other",
      "Scene",
      "Sequence",
      "Automation",
      "Exception",
      "Notification",
      "Alarm",
    ], //
    "AmiRegistrationState" : [
      "Unregistered",
      "JoiningNetwork",
      "JoinedNetwork",
      "SubmittedRegistrationRequest",
      "RegistrationRejected",
      "Registered",
      "RegisterationNotPossible",
    ], //
    "AnonymousDataState" : [
      "NoSourceFound",
      "SourceFound",
    ], //
    "ApplicationLauncherStatusEnum" : [
      "Success",
      "AppNotAvailable",
      "SystemBusy",
    ], //
    "ApplicationStatusEnum" : [
      "Stopped",
      "ActiveVisibleFocus",
      "ActiveHidden",
      "ActiveVisibleNotFocus",
    ], //
    "AssociationFailureCause" : [
      "Unknown",
      "AssociationFailed",
      "AuthenticationFailed",
      "SsidNotFound",
    ], //
    "AttributeWritePermission" : [
      "DenyWrite",
      "AllowWriteNormal",
      "AllowWriteOfReadOnly",
      "UnsupportedAttribute",
      "InvalidValue",
      "ReadOnly",
      "InvalidDataType",
    ], //
    "AuthMode" : [
      "Pase",
      "Case",
      "Group",
    ], //
    "BarrierControlBarrierPosition" : [
      "Closed",
      "Open",
      "Unknown",
    ], //
    "BarrierControlMovingState" : [
      "Stopped",
      "Closing",
      "Opening",
    ], //
    "BatChargeFault" : [
      "Unspecfied",
      "AmbientTooHot",
      "AmbientTooCold",
      "BatteryTooHot",
      "BatteryTooCold",
      "BatteryAbsent",
      "BatteryOverVoltage",
      "BatteryUnderVoltage",
      "ChargerOverVoltage",
      "ChargerUnderVoltage",
      "SafetyTimeout",
    ], //
    "BatChargeLevel" : [
      "Ok",
      "Warning",
      "Critical",
    ], //
    "BatChargeState" : [
      "Unknown",
      "IsCharging",
      "IsAtFullCharge",
      "IsNotCharging",
    ], //
    "BatFault" : [
      "Unspecfied",
      "OverTemp",
      "UnderTemp",
    ], //
    "BatReplaceability" : [
      "Unspecified",
      "NotReplaceable",
      "UserReplaceable",
      "FactoryReplaceable",
    ], //
    "BatterySize" : [
      "NoBattery",
      "BuiltIn",
      "Other",
      "Aa",
      "Aaa",
      "C",
      "D",
      "Unknown",
    ], //
    "BootReasonType" : [
      "Unspecified",
      "PowerOnReboot",
      "BrownOutReset",
      "SoftwareWatchdogReset",
      "HardwareWatchdogReset",
      "SoftwareUpdateCompleted",
      "SoftwareReset",
    ], //
    "CalendarType" : [
      "Buddhist",
      "Chinese",
      "Coptic",
      "Ethiopian",
      "Gregorian",
      "Hebrew",
      "Indian",
      "Islamic",
      "Japanese",
      "Korean",
      "Persian",
      "Taiwanese",
    ], //
    "CecKeyCode" : [
      "Select",
      "Up",
      "Down",
      "Left",
      "Right",
      "RightUp",
      "RightDown",
      "LeftUp",
      "LeftDown",
      "RootMenu",
      "SetupMenu",
      "ContentsMenu",
      "FavoriteMenu",
      "Exit",
      "MediaTopMenu",
      "MediaContextSensitiveMenu",
      "NumberEntryMode",
      "Number11",
      "Number12",
      "Number0OrNumber10",
      "Numbers1",
      "Numbers2",
      "Numbers3",
      "Numbers4",
      "Numbers5",
      "Numbers6",
      "Numbers7",
      "Numbers8",
      "Numbers9",
      "Dot",
      "Enter",
      "Clear",
      "NextFavorite",
      "ChannelUp",
      "ChannelDown",
      "PreviousChannel",
      "SoundSelect",
      "InputSelect",
      "DisplayInformation",
      "Help",
      "PageUp",
      "PageDown",
      "Power",
      "VolumeUp",
      "VolumeDown",
      "Mute",
      "Play",
      "Stop",
      "Pause",
      "Record",
      "Rewind",
      "FastForward",
      "Eject",
      "Forward",
      "Backward",
      "StopRecord",
      "PauseRecord",
      "Reserved",
      "Angle",
      "SubPicture",
      "VideoOnDemand",
      "ElectronicProgramGuide",
      "TimerProgramming",
      "InitialConfiguration",
      "SelectBroadcastType",
      "SelectSoundPresentation",
      "PlayFunction",
      "PausePlayFunction",
      "RecordFunction",
      "PauseRecordFunction",
      "StopFunction",
      "MuteFunction",
      "RestoreVolumeFunction",
      "TuneFunction",
      "SelectMediaFunction",
      "SelectAvInputFunction",
      "SelectAudioInputFunction",
      "PowerToggleFunction",
      "PowerOffFunction",
      "PowerOnFunction",
      "F1Blue",
      "F2Red",
      "F3Green",
      "F4Yellow",
      "F5",
      "Data",
    ], //
    "CecedSpecificationVersion" : [
      "CompliantWithV10NotCertified",
      "CompliantWithV10Certified",
    ], //
    "ChangeTypeEnum" : [
      "Changed",
      "Added",
      "Removed",
    ], //
    "ChannelStatusEnum" : [
      "Success",
      "MultipleMatches",
      "NoMatches",
    ], //
    "ColorControlOptions" : [
      "ExecuteIfOff",
    ], //
    "ColorLoopAction" : [
      "Deactivate",
      "ActivateFromColorLoopStartEnhancedHue",
      "ActivateFromEnhancedCurrentHue",
    ], //
    "ColorLoopDirection" : [
      "DecrementHue",
      "IncrementHue",
    ], //
    "ColorMode" : [
      "CurrentHueAndCurrentSaturation",
      "CurrentXAndCurrentY",
      "ColorTemperature",
    ], //
    "CommissioningError" : [
      "Ok",
      "ValueOutsideRange",
      "InvalidAuthentication",
      "NoFailSafe",
      "BusyWithOtherAdmin",
    ], //
    "CommissioningWindowStatus" : [
      "WindowNotOpen",
      "EnhancedWindowOpen",
      "BasicWindowOpen",
    ], //
    "ContentLaunchStatusEnum" : [
      "Success",
      "UrlNotAvailable",
      "AuthFailed",
    ], //
    "DataQualityId" : [
      "AllDataCertified",
      "OnlyInstantaneousPowerNotCertified",
      "OnlyCumulatedConsumptionNotCertified",
      "NotCertifiedData",
    ], //
    "DehumidifcationLockout" : [
      "NotAllowed",
      "Allowed",
    ], //
    "DeviceStatus2Structure" : [
      "IrisSymptomCode",
    ], //
    "DlAlarmCode" : [
      "LockJammed",
      "LockFactoryReset",
      "LockRadioPowerCycled",
      "WrongCodeEntryLimit",
      "FrontEsceutcheonRemoved",
      "DoorForcedOpen",
      "DoorAjar",
      "ForcedUser",
    ], //
    "DlCredentialRule" : [
      "Single",
      "Double",
      "Tri",
    ], //
    "DlCredentialType" : [
      "ProgrammingPIN",
      "Pin",
      "Rfid",
      "Fingerprint",
      "FingerVein",
      "Face",
    ], //
    "DlDataOperationType" : [
      "Add",
      "Clear",
      "Modify",
    ], //
    "DlDoorState" : [
      "DoorOpen",
      "DoorClosed",
      "DoorJammed",
      "DoorForcedOpen",
      "DoorUnspecifiedError",
      "DoorAjar",
    ], //
    "DlLockDataType" : [
      "Unspecified",
      "ProgrammingCode",
      "UserIndex",
      "WeekDaySchedule",
      "YearDaySchedule",
      "HolidaySchedule",
      "Pin",
      "Rfid",
      "Fingerprint",
    ], //
    "DlLockOperationType" : [
      "Lock",
      "Unlock",
      "NonAccessUserEvent",
      "ForcedUserEvent",
    ], //
    "DlLockState" : [
      "NotFullyLocked",
      "Locked",
      "Unlocked",
    ], //
    "DlLockType" : [
      "DeadBolt",
      "Magnetic",
      "Other",
      "Mortise",
      "Rim",
      "LatchBolt",
      "CylindricalLock",
      "TubularLock",
      "InterconnectedLock",
      "DeadLatch",
      "DoorFurniture",
    ], //
    "DlOperatingMode" : [
      "Normal",
      "Vacation",
      "Privacy",
      "NoRemoteLockUnlock",
      "Passage",
    ], //
    "DlOperationError" : [
      "Unspecified",
      "InvalidCredential",
      "DisabledUserDenied",
      "Restricted",
      "InsufficientBattery",
    ], //
    "DlOperationSource" : [
      "Unspecified",
      "Manual",
      "ProprietaryRemote",
      "Keypad",
      "Auto",
      "Button",
      "Schedule",
      "Remote",
      "Rfid",
      "Biometric",
    ], //
    "DlStatus" : [
      "Success",
      "Failure",
      "Duplicate",
      "Occupied",
      "InvalidField",
      "ResourceExhausted",
      "NotFound",
    ], //
    "DlUserStatus" : [
      "Available",
      "OccupiedEnabled",
      "OccupiedDisabled",
    ], //
    "DlUserType" : [
      "UnrestrictedUser",
      "YearDayScheduleUser",
      "WeekDayScheduleUser",
      "ProgrammingUser",
      "NonAccessUser",
      "ForcedUser",
      "DisposableUser",
      "ExpiringUser",
      "ScheduleRestrictedUser",
      "RemoteOnlyUser",
    ], //
    "DoorLockEventSource" : [
      "Keypad",
      "Rf",
      "Manual",
      "Rfid",
      "Indeterminate",
    ], //
    "DoorLockEventType" : [
      "Operation",
      "Programming",
      "Alarm",
    ], //
    "DoorLockOperatingMode" : [
      "NormalMode",
      "VacationMode",
      "PrivacyMode",
      "NoRfLockOrUnlock",
      "LocalProgrammingMode",
      "PassageMode",
    ], //
    "DoorLockOperationEventCode" : [
      "UnknownOrMfgSpecific",
      "Lock",
      "Unlock",
      "LockInvalidPinOrId",
      "LockInvalidSchedule",
      "UnlockInvalidPinOrId",
      "UnlockInvalidSchedule",
      "OneTouchLock",
      "KeyLock",
      "KeyUnlock",
      "AutoLock",
      "ScheduleLock",
      "ScheduleUnlock",
      "ManualLock",
      "ManualUnlock",
    ], //
    "DoorLockProgrammingEventCode" : [
      "UnknownOrMfgSpecific",
      "MasterCodeChanged",
      "PinAdded",
      "PinDeleted",
      "PinChanged",
      "IdAdded",
      "IdDeleted",
    ], //
    "DoorLockSecurityLevel" : [
      "NetworkSecurity",
      "ApsSecurity",
    ], //
    "DoorLockSetPinOrIdStatus" : [
      "Success",
      "GeneralFailure",
      "MemoryFull",
      "DuplicateCodeError",
    ], //
    "DoorLockSoundVolume" : [
      "Silent",
      "Low",
      "High",
    ], //
    "DoorLockState" : [
      "NotFullyLocked",
      "Locked",
      "Unlocked",
    ], //
    "DoorLockType" : [
      "DeadBolt",
      "Magnetic",
      "Mortise",
      "Rim",
      "LatchBolt",
      "Cylindrical",
      "Tubular",
      "Interconnected",
      "DeadLatch",
      "Other",
    ], //
    "DoorLockUserStatus" : [
      "Available",
      "OccupiedEnabled",
      "OccupiedDisabled",
      "NotSupported",
    ], //
    "DoorLockUserType" : [
      "Unrestricted",
      "YearDayScheduleUser",
      "WeekDayScheduleUser",
      "MasterUser",
      "NonAccessUser",
      "NotSupported",
    ], //
    "DoorState" : [
      "Open",
      "Closed",
      "ErrorJammed",
      "ErrorForcedOpen",
      "ErrorUnspecified",
    ], //
    "EndProductType" : [
      "RollerShade",
      "RomanShade",
      "BalloonShade",
      "WovenWood",
      "PleatedShade",
      "CellularShade",
      "LayeredShade",
      "LayeredShade2D",
      "SheerShade",
      "TiltOnlyInteriorBlind",
      "InteriorBlind",
      "VerticalBlindStripCurtain",
      "InteriorVenetianBlind",
      "ExteriorVenetianBlind",
      "LateralLeftCurtain",
      "LateralRightCurtain",
      "CentralCurtain",
      "RollerShutter",
      "ExteriorVerticalScreen",
      "AwningTerracePatio",
      "AwningVerticalScreen",
      "TiltOnlyPergola",
      "SwingingShutter",
      "SlidingShutter",
      "Unknown",
    ], //
    "EndpointListTypeEnum" : [
      "Other",
      "Room",
      "Zone",
    ], //
    "EnhancedColorMode" : [
      "CurrentHueAndCurrentSaturation",
      "CurrentXAndCurrentY",
      "ColorTemperature",
      "EnhancedCurrentHueAndCurrentSaturation",
    ], //
    "FanMode" : [
      "Off",
      "Low",
      "Medium",
      "High",
      "On",
      "Auto",
      "Smart",
    ], //
    "FanModeSequence" : [
      "LowMedHigh",
      "LowHigh",
      "LowMedHighAuto",
      "LowHighAuto",
      "OnAuto",
    ], //
    "FanModeSequenceType" : [
      "OffLowMedHigh",
      "OffLowHigh",
      "OffLowMedHighAuto",
      "OffLowHighAuto",
      "OffOnAuto",
      "OffOn",
    ], //
    "FanModeType" : [
      "Off",
      "Low",
      "Medium",
      "High",
      "On",
      "Auto",
      "Smart",
    ], //
    "FaultType" : [
      "Unspecified",
      "SystemFault",
      "InetFault",
      "ChipFault",
      "CertFault",
    ], //
    "GenericDeviceType" : [
      "Incandescent",
      "SpotlightHalogen",
      "HalogenBulb",
      "Cfl",
      "LinearFlourescent",
      "LedBulb",
      "SpotlightLed",
      "LedStrip",
      "LedTube",
      "GenericIndoorFixture",
      "GenericOutdoorFixture",
      "PendantFixture",
      "FloorStandingFixture",
      "GenericController",
      "WallSwitch",
      "PortableRemoteController",
      "MotionOrLightSensor",
      "GenericActuator",
      "PluginUnit",
      "RetrofitActuator",
      "Unspecified",
    ], //
    "GranularityEnum" : [
      "NoTimeGranularity",
      "MinutesGranularity",
      "SecondsGranularity",
      "MillisecondsGranularity",
      "MicrosecondsGranularity",
    ], //
    "GroupKeySecurityPolicy" : [
      "TrustFirst",
      "CacheAndSync",
    ], //
    "HardwareFaultType" : [
      "Unspecified",
      "Radio",
      "Sensor",
      "ResettableOverTemp",
      "NonResettableOverTemp",
      "PowerSource",
      "VisualDisplayFault",
      "AudioOutputFault",
      "UserInterfaceFault",
      "NonVolatileMemoryError",
      "TamperDetected",
    ], //
    "HourFormat" : [
      "12hr",
      "24hr",
    ], //
    "HueDirection" : [
      "ShortestDistance",
      "LongestDistance",
      "Up",
      "Down",
    ], //
    "HueMoveMode" : [
      "Stop",
      "Up",
      "Down",
    ], //
    "HueStepMode" : [
      "Up",
      "Down",
    ], //
    "IdentifyEffectIdentifier" : [
      "Blink",
      "Breathe",
      "Okay",
      "ChannelChange",
      "FinishEffect",
      "StopEffect",
    ], //
    "IdentifyEffectVariant" : [
      "Default",
    ], //
    "IdentifyIdentifyType" : [
      "None",
      "VisibleLight",
      "VisibleLED",
      "AudibleBeep",
      "Display",
      "Actuator",
    ], //
    "InputTypeEnum" : [
      "Internal",
      "Aux",
      "Coax",
      "Composite",
      "Hdmi",
      "Input",
      "Line",
      "Optical",
      "Video",
      "Scart",
      "Usb",
      "Other",
    ], //
    "InterfaceType" : [
      "Unspecified",
      "WiFi",
      "Ethernet",
      "Cellular",
      "Thread",
    ], //
    "KeypadInputStatusEnum" : [
      "Success",
      "UnsupportedKey",
      "InvalidKeyInCurrentState",
    ], //
    "KeypadLockout" : [
      "NoLockout",
      "LevelOneLockout",
      "LevelTwoLockout",
      "LevelThreeLockout",
      "LevelFourLockout",
      "LevelfiveLockout",
    ], //
    "LevelStatus" : [
      "OnTarget",
      "BelowTarget",
      "AboveTarget",
    ], //
    "LightSensorType" : [
      "Photodiode",
      "Cmos",
    ], //
    "LineupInfoTypeEnum" : [
      "Mso",
    ], //
    "LogsIntent" : [
      "EndUserSupport",
      "NetworkDiag",
      "CrashLogs",
    ], //
    "LogsStatus" : [
      "Success",
      "Exhausted",
      "NoLogs",
      "Busy",
      "Denied",
    ], //
    "LogsTransferProtocol" : [
      "ResponsePayload",
      "Bdx",
    ], //
    "MediaPlaybackStatusEnum" : [
      "Success",
      "InvalidStateForCommand",
      "NotAllowed",
      "NotActive",
      "SpeedOutOfRange",
      "SeekOutOfRange",
    ], //
    "MeterTypeId" : [
      "UtilityPrimaryMeter",
      "UtilityProductionMeter",
      "UtilitySecondaryMeter",
      "PrivatePrimaryMeter",
      "PrivateProductionMeter",
      "PrivateSecondaryMeters",
      "GenericMeter",
    ], //
    "MetricTypeEnum" : [
      "Pixels",
      "Percentage",
    ], //
    "MoveMode" : [
      "Up",
      "Down",
    ], //
    "NetworkCommissioningStatus" : [
      "Success",
      "OutOfRange",
      "BoundsExceeded",
      "NetworkIDNotFound",
      "DuplicateNetworkID",
      "NetworkNotFound",
      "RegulatoryError",
      "AuthFailure",
      "UnsupportedSecurity",
      "OtherConnectionFailure",
      "IPV6Failed",
      "IPBindFailed",
      "UnknownError",
    ], //
    "NetworkFault" : [
      "Unspecified",
      "LinkDown",
      "HardwareFailure",
      "NetworkJammed",
    ], //
    "NetworkFaultType" : [
      "Unspecified",
      "HardwareFailure",
      "NetworkJammed",
      "ConnectionFailed",
    ], //
    "OTAAnnouncementReason" : [
      "SimpleAnnouncement",
      "UpdateAvailable",
      "UrgentUpdateAvailable",
    ], //
    "OTAApplyUpdateAction" : [
      "Proceed",
      "AwaitNextAction",
      "Discontinue",
    ], //
    "OTAChangeReasonEnum" : [
      "Unknown",
      "Success",
      "Failure",
      "TimeOut",
      "DelayByProvider",
    ], //
    "OTADownloadProtocol" : [
      "BDXSynchronous",
      "BDXAsynchronous",
      "Https",
      "VendorSpecific",
    ], //
    "OTAQueryStatus" : [
      "UpdateAvailable",
      "Busy",
      "NotAvailable",
      "DownloadProtocolNotSupported",
    ], //
    "OTAUpdateStateEnum" : [
      "Unknown",
      "Idle",
      "Querying",
      "DelayedOnQuery",
      "Downloading",
      "Applying",
      "DelayedOnApply",
      "RollingBack",
      "DelayedOnUserConsent",
    ], //
    "OccupancySensorType" : [
      "Pir",
      "Ultrasonic",
      "PirAndUltrasonic",
      "PhysicalContact",
    ], //
    "OnOffDelayedAllOffEffectVariant" : [
      "FadeToOffIn0p8Seconds",
      "NoFade",
      "50PercentDimDownIn0p8SecondsThenFadeToOffIn12Seconds",
    ], //
    "OnOffDyingLightEffectVariant" : [
      "20PercenterDimUpIn0p5SecondsThenFadeToOffIn1Second",
    ], //
    "OnOffEffectIdentifier" : [
      "DelayedAllOff",
      "DyingLight",
    ], //
    "OnOffStartUpOnOff" : [
      "Off",
      "On",
      "TogglePreviousOnOff",
    ], //
    "OperatingMode" : [
      "Normal",
      "Configure",
    ], //
    "OperationalCertStatus" : [
      "Success",
      "InvalidPublicKey",
      "InvalidNodeOpId",
      "InvalidNOC",
      "MissingCsr",
      "TableFull",
      "InvalidAdminSubject",
      "FabricConflict",
      "LabelConflict",
      "InvalidFabricIndex",
    ], //
    "OutputTypeEnum" : [
      "Hdmi",
      "Bt",
      "Optical",
      "Headphone",
      "Internal",
      "Other",
    ], //
    "PHYRateType" : [
      "10m",
      "100m",
      "1000m",
      "25g",
      "5g",
      "10g",
      "40g",
      "100g",
      "200g",
      "400g",
    ], //
    "ParameterEnum" : [
      "Actor",
      "Channel",
      "Character",
      "Director",
      "Event",
      "Franchise",
      "Genre",
      "League",
      "Popularity",
      "Provider",
      "Sport",
      "SportsTeam",
      "Type",
    ], //
    "PhysicalEnvironment" : [
      "Unspecified",
      "FirstProfileSpecifiedValue",
      "LastProfileSpecifiedValue",
      "Unknown",
    ], //
    "PlaybackStateEnum" : [
      "Playing",
      "Paused",
      "NotPlaying",
      "Buffering",
    ], //
    "PowerProfileState" : [
      "PowerProfileWaitingToStart",
      "PowerProfileStarted",
      "EnergyPhaseRunning",
      "EnergyPhaseEnded",
      "EnergyPhaseWaitingToStart",
      "EnergyPhaseStarted",
      "PowerProfileEnded",
      "ProfileReadyForScheduling",
      "PowerProfileScheduled",
    ], //
    "PowerSource" : [
      "Unknown",
      "SinglePhaseMains",
      "ThreePhaseMains",
      "Battery",
      "DcSource",
      "EmergencyMainsConstantPower",
      "EmergencyMainsTransferSwitch",
      "BatteryBackup",
    ], //
    "PowerSourceStatus" : [
      "Unspecfied",
      "Active",
      "Standby",
      "Unavailable",
    ], //
    "Privilege" : [
      "View",
      "ProxyView",
      "Operate",
      "Manage",
      "Administer",
    ], //
    "ProductCode" : [
      "ManufacturerDefined",
      "IternationalArticleNumber",
      "GlobalTradeItemNumber",
      "UniversalProductCode",
      "StockKeepingUnit",
    ], //
    "ProductTypeId" : [
      "WhiteGoods",
      "Dishwasher",
      "TumbleDryer",
      "WasherDryer",
      "WashingMachine",
      "Hobs",
      "InductionHobs",
      "Oven",
      "ElectricalOven",
      "RefrigeratorFreezer",
    ], //
    "PumpControlMode" : [
      "ConstantSpeed",
      "ConstantPressure",
      "ProportionalPressure",
      "ConstantFlow",
      "ConstantTemperature",
      "Automatic",
    ], //
    "PumpOperationMode" : [
      "Normal",
      "Minimum",
      "Maximum",
      "Local",
    ], //
    "RadioFaultType" : [
      "Unspecified",
      "WiFiFault",
      "CellularFault",
      "ThreadFault",
      "NFCFault",
      "BLEFault",
      "EthernetFault",
    ], //
    "RegulatoryLocationType" : [
      "Indoor",
      "Outdoor",
      "IndoorOutdoor",
    ], //
    "RelativeHumidityDisplay" : [
      "NotDisplayed",
      "Displayed",
    ], //
    "RelativeHumidityMode" : [
      "MeasureLocally",
      "UpdatedOverTheNetwork",
    ], //
    "RemoteEnableFlags" : [
      "Disabled",
      "TemporarilyLockedDisabled",
      "EnabledRemoteControl",
      "EnabledRemoteAndEnergyControl",
    ], //
    "RoutingRole" : [
      "Unspecified",
      "Unassigned",
      "SleepyEndDevice",
      "EndDevice",
      "Reed",
      "Router",
      "Leader",
    ], //
    "SaturationMoveMode" : [
      "Stop",
      "Up",
      "Down",
    ], //
    "SaturationStepMode" : [
      "Up",
      "Down",
    ], //
    "SecurityType" : [
      "Unspecified",
      "None",
      "Wep",
      "Wpa",
      "Wpa2",
      "Wpa3",
    ], //
    "SetpointAdjustMode" : [
      "HeatSetpoint",
      "CoolSetpoint",
      "HeatAndCoolSetpoints",
    ], //
    "SimpleEnum" : [
      "Unspecified",
      "ValueA",
      "ValueB",
      "ValueC",
    ], //
    "SquawkLevel" : [
      "LowLevel",
      "MediumLevel",
      "HighLevel",
      "VeryHighLevel",
    ], //
    "SquawkMode" : [
      "SystemIsArmed",
      "SystemIsDisarmed",
    ], //
    "SquawkStobe" : [
      "NoStrobe",
      "UseStrobe",
    ], //
    "StartOfWeek" : [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
    ], //
    "StartUpOnOffValue" : [
      "SetToOff",
      "SetToOn",
      "SetToToggle",
    ], //
    "Status" : [
      "Success",
      "Failure",
      "NotAuthorized",
      "MalformedCommand",
      "UnsupCommand",
      "UnsupGeneralCommand",
      "UnsupManufClusterCommand",
      "UnsupManufGeneralCommand",
      "InvalidField",
      "UnsupportedAttribute",
      "InvalidValue",
      "ReadOnly",
      "InsufficientSpace",
      "DuplicateExists",
      "NotFound",
      "UnreportableAttribute",
      "InvalidDataType",
      "InvalidSelector",
      "WriteOnly",
      "InconsistentStartupState",
      "DefinedOutOfBand",
      "ActionDenied",
      "Timeout",
      "Abort",
      "InvalidImage",
      "WaitForData",
      "NoImageAvailable",
      "RequireMoreImage",
      "NotificationPending",
      "HardwareFailure",
      "SoftwareFailure",
      "UnsupportedCluster",
      "LimitReached",
    ], //
    "StatusCode" : [
      "Busy",
      "PAKEParameterError",
      "WindowNotOpen",
    ], //
    "StepMode" : [
      "Up",
      "Down",
    ], //
    "SwitchActions" : [
      "On",
      "Off",
      "Toggle",
    ], //
    "SwitchType" : [
      "Toggle",
      "Momentary",
      "MultiFunction",
    ], //
    "TargetNavigatorStatusEnum" : [
      "Success",
      "TargetNotFound",
      "NotAllowed",
    ], //
    "TempUnit" : [
      "Fahrenheit",
      "Celsius",
      "Kelvin",
    ], //
    "TemperatureDisplayMode" : [
      "Celsius",
      "Fahrenheit",
    ], //
    "TemperatureSetpointHold" : [
      "SetpointHoldOff",
      "SetpointHoldOn",
    ], //
    "ThermostatControlSequence" : [
      "CoolingOnly",
      "CoolingWithReheat",
      "HeatingOnly",
      "HeatingWithReheat",
      "CoolingAndHeating",
      "CoolingAndHeatingWithReheat",
    ], //
    "ThermostatRunningMode" : [
      "Off",
      "Cool",
      "Heat",
    ], //
    "ThermostatSystemMode" : [
      "Off",
      "Auto",
      "Cool",
      "Heat",
      "EmergencyHeating",
      "Precooling",
      "FanOnly",
    ], //
    "ThreadConnectionStatus" : [
      "Connected",
      "NotConnected",
    ], //
    "TimeEncoding" : [
      "Relative",
      "Absolute",
    ], //
    "TimeSourceEnum" : [
      "None",
      "Unknown",
      "Admin",
      "NodeTimeCluster",
      "NonFabricSntp",
      "NonFabricNtp",
      "FabricSntp",
      "FabricNtp",
      "MixedNtp",
      "NonFabricSntpNts",
      "NonFabricNtpNts",
      "FabricSntpNts",
      "FabricNtpNts",
      "MixedNtpNts",
      "CloudSource",
      "Ptp",
      "Gnss",
    ], //
    "Type" : [
      "RollerShade",
      "RollerShade2Motor",
      "RollerShadeExterior",
      "RollerShadeExterior2Motor",
      "Drapery",
      "Awning",
      "Shutter",
      "TiltBlindTiltOnly",
      "TiltBlindLiftAndTilt",
      "ProjectorScreen",
      "Unknown",
    ], //
    "WarningMode" : [
      "Stop",
      "Burglar",
      "Fire",
      "Emergency",
      "PolicePanic",
      "FirePanic",
      "EmergencyPanic",
    ], //
    "WarningStobe" : [
      "NoStrobe",
      "UseStrobe",
    ], //
    "WiFiBand" : [
      "2g4",
      "3g65",
      "5g",
      "6g",
      "60g",
    ], //
    "WiFiConnectionStatus" : [
      "Connected",
      "NotConnected",
    ], //
    "WiFiVersionType" : [
      "80211a",
      "80211b",
      "80211g",
      "80211n",
      "80211ac",
      "80211ax",
    ], //
    "WiredCurrentType" : [
      "Ac",
      "Dc",
    ], //
    "WiredFault" : [
      "Unspecfied",
      "OverVoltage",
      "UnderVoltage",
    ], //
  },

  bitmaps : {
    "AlarmMask" : {
      1 : "GeneralHwFault",
      2 : "GeneralSwFault",
    },
    "ApplicationLauncherFeature" : {
      1 : "ApplicationPlatform",
    },
    "AudioOutputFeature" : {
      1 : "NameUpdates",
    },
    "BallastStatus" : {
      1 : "NonOperational",
      2 : "LampNotInSocket",
    },
    "BarrierControlCapabilities" : {
      1 : "PartialBarrier",
    },
    "BarrierControlSafetyStatus" : {
      1 : "RemoteLockout",
      2 : "TemperDetected",
      4 : "FailedCommunication",
      8 : "PositionFailure",
    },
    "BatteryAlarmMask" : {
      1 : "VoltageTooLow",
    },
    "Bitmap16MaskMap" : {
      1 : "MaskVal1",
      2 : "MaskVal2",
      4 : "MaskVal3",
      16384 : "MaskVal4",
    },
    "Bitmap32MaskMap" : {
      1 : "MaskVal1",
      2 : "MaskVal2",
      4 : "MaskVal3",
      1073741824 : "MaskVal4",
    },
    "Bitmap64MaskMap" : {
      1 : "MaskVal1",
      2 : "MaskVal2",
      4 : "MaskVal3",
      4611686018427388000 : "MaskVal4",
    },
    "Bitmap8MaskMap" : {
      1 : "MaskVal1",
      2 : "MaskVal2",
      4 : "MaskVal3",
      64 : "MaskVal4",
    },
    "ChannelFeature" : {
      1 : "ChannelList",
      2 : "LineupInfo",
    },
    "ColorCapabilities" : {
      1 : "HueSaturationSupported",
      2 : "EnhancedHueSupported",
      4 : "ColorLoopSupported",
      8 : "XYAttributesSupported",
      16 : "ColorTemperatureSupported",
    },
    "ColorControlFeature" : {
      1 : "HueAndSaturation",
      2 : "EnhancedHue",
      4 : "ColorLoop",
      8 : "Xy",
      16 : "ColorTemperature",
    },
    "ColorLoopUpdateFlags" : {
      1 : "UpdateAction",
      2 : "UpdateDirection",
      4 : "UpdateTime",
      8 : "UpdateStartHue",
    },
    "CommandBits" : {
      1 : "InstantAction",
      2 : "InstantActionWithTransition",
      4 : "StartAction",
      8 : "StartActionWithDuration",
      16 : "StopAction",
      32 : "PauseAction",
      64 : "PauseActionWithDuration",
      128 : "ResumeAction",
      256 : "EnableAction",
      512 : "EnableActionWithDuration",
      1024 : "DisableAction",
      2048 : "DisableActionWithDuration",
    },
    "ConfigStatus" : {
      1 : "Operational",
      2 : "OnlineReserved",
      4 : "LiftMovementReversed",
      8 : "LiftPositionAware",
      16 : "TiltPositionAware",
      32 : "LiftEncoderControlled",
      64 : "TiltEncoderControlled",
    },
    "ContentLauncherFeature" : {
      1 : "ContentSearch",
      2 : "URLPlayback",
    },
    "DayOfWeek" : {
      1 : "Sunday",
      2 : "Monday",
      4 : "Tuesday",
      8 : "Wednesday",
      16 : "Thursday",
      32 : "Friday",
      64 : "Saturday",
      128 : "AwayOrVacation",
    },
    "DeviceTempAlarmMask" : {
      1 : "TooLow",
      2 : "TooHigh",
    },
    "DlCredentialRuleMask" : {
      1 : "Single",
      2 : "Dual",
      4 : "Tri",
    },
    "DlCredentialRulesSupport" : {
      1 : "Single",
      2 : "Dual",
      4 : "Tri",
    },
    "DlDaysMaskMap" : {
      1 : "Sunday",
      2 : "Monday",
      4 : "Tuesday",
      8 : "Wednesday",
      16 : "Thursday",
      32 : "Friday",
      64 : "Saturday",
    },
    "DlDefaultConfigurationRegister" : {
      1 : "EnableLocalProgrammingEnabled",
      2 : "KeypadInterfaceDefaultAccessEnabled",
      4 : "RemoteInterfaceDefaultAccessIsEnabled",
      32 : "SoundEnabled",
      64 : "AutoRelockTimeSet",
      128 : "LEDSettingsSet",
    },
    "DlKeypadOperationEventMask" : {
      1 : "Unknown",
      2 : "Lock",
      4 : "Unlock",
      8 : "LockInvalidPIN",
      16 : "LockInvalidSchedule",
      32 : "UnlockInvalidCode",
      64 : "UnlockInvalidSchedule",
      128 : "NonAccessUserOpEvent",
    },
    "DlKeypadProgrammingEventMask" : {
      1 : "Unknown",
      2 : "ProgrammingPINChanged",
      4 : "PINAdded",
      8 : "PINCleared",
      16 : "PINChanged",
    },
    "DlLocalProgrammingFeatures" : {
      1 : "AddUsersCredentialsSchedulesLocally",
      2 : "ModifyUsersCredentialsSchedulesLocally",
      4 : "ClearUsersCredentialsSchedulesLocally",
      8 : "AdjustLockSettingsLocally",
    },
    "DlManualOperationEventMask" : {
      1 : "Unknown",
      2 : "ThumbturnLock",
      4 : "ThumbturnUnlock",
      8 : "OneTouchLock",
      16 : "KeyLock",
      32 : "KeyUnlock",
      64 : "AutoLock",
      128 : "ScheduleLock",
      256 : "ScheduleUnlock",
      512 : "ManualLock",
      1024 : "ManualUnlock",
    },
    "DlRFIDOperationEventMask" : {
      1 : "Unknown",
      2 : "Lock",
      4 : "Unlock",
      8 : "LockInvalidRFID",
      16 : "LockInvalidSchedule",
      32 : "UnlockInvalidRFID",
      64 : "UnlockInvalidSchedule",
    },
    "DlRFIDProgrammingEventMask" : {
      1 : "Unknown",
      32 : "RFIDCodeAdded",
      64 : "RFIDCodeCleared",
    },
    "DlRemoteOperationEventMask" : {
      1 : "Unknown",
      2 : "Lock",
      4 : "Unlock",
      8 : "LockInvalidCode",
      16 : "LockInvalidSchedule",
      32 : "UnlockInvalidCode",
      64 : "UnlockInvalidSchedule",
    },
    "DlRemoteProgrammingEventMask" : {
      1 : "Unknown",
      2 : "ProgrammingPINChanged",
      4 : "PINAdded",
      8 : "PINCleared",
      16 : "PINChanged",
      32 : "RFIDCodeAdded",
      64 : "RFIDCodeCleared",
    },
    "DlSupportedOperatingModes" : {
      1 : "Normal",
      2 : "Vacation",
      4 : "Privacy",
      8 : "NoRemoteLockUnlock",
      16 : "Passage",
    },
    "DoorLockDayOfWeek" : {
      1 : "Sunday",
      2 : "Monday",
      4 : "Tuesday",
      8 : "Wednesday",
      16 : "Thursday",
      32 : "Friday",
      64 : "Saturday",
    },
    "DoorLockFeature" : {
      1 : "PINCredentials",
      2 : "RFIDCredentials",
      4 : "FingerCredentials",
      8 : "Logging",
      16 : "WeekDaySchedules",
      32 : "DoorPositionSensor",
      64 : "FaceCredentials",
      128 : "CredentialsOTA",
      256 : "UsersManagement",
      512 : "Notifications",
      1024 : "YearDaySchedules",
      2048 : "HolidaySchedules",
    },
    "EnergyFormatting" : {
      7 : "NumberOfDigitsToTheRightOfTheDecimalPoint",
      120 : "NumberOfDigitsToTheLeftOfTheDecimalPoint",
      128 : "SuppressLeadingZeros",
    },
    "EthernetNetworkDiagnosticsFeature" : {
      1 : "PacketCounts",
      2 : "ErrorCounts",
    },
    "FanControlFeature" : {
      1 : "MultiSpeed",
      2 : "Auto",
      4 : "Rocking",
      8 : "Wind",
    },
    "Feature" : {
      1 : "Lift",
      2 : "Tilt",
      4 : "PositionAwareLift",
      8 : "AbsolutePosition",
      16 : "PositionAwareTilt",
    },
    "GroupClusterFeature" : {
      1 : "GroupNames",
    },
    "IasZoneStatus" : {
      1 : "Alarm1",
      2 : "Alarm2",
      4 : "Tamper",
      8 : "Battery",
      16 : "SupervisionReports",
      32 : "RestoreReports",
      64 : "Trouble",
      128 : "Ac",
      256 : "Test",
      512 : "BatteryDefect",
    },
    "KeypadInputFeature" : {
      1 : "NavigationKeyCodes",
      2 : "LocationKeys",
      4 : "NumberKeys",
    },
    "LampAlarmMode" : {
      1 : "LampBurnHours",
    },
    "LevelControlFeature" : {
      1 : "OnOff",
      2 : "Lighting",
      4 : "Frequency",
    },
    "LevelControlOptions" : {
      1 : "ExecuteIfOff",
      2 : "CoupleColorTempToLevel",
    },
    "MainsAlarmMask" : {
      1 : "VoltageTooLow",
      2 : "VoltageTooHigh",
      4 : "MainsPowerSupplyLost",
    },
    "MediaInputFeature" : {
      1 : "NameUpdates",
    },
    "MediaPlaybackFeature" : {
      1 : "AdvancedSeek",
      2 : "VariableSpeed",
    },
    "Mode" : {
      1 : "MotorDirectionReversed",
      2 : "CalibrationMode",
      4 : "MaintenanceMode",
      8 : "LedFeedback",
    },
    "ModeForSequence" : {
      1 : "HeatSetpointFieldPresent",
      2 : "CoolSetpointFieldPresent",
    },
    "ModeSelectFeature" : {
      1 : "Deponoff",
    },
    "NetworkCommissioningFeature" : {
      1 : "WiFiNetworkInterface",
      2 : "ThreadNetworkInterface",
      4 : "EthernetNetworkInterface",
    },
    "Occupancy" : {
      1 : "Occupied",
    },
    "OccupancySensorTypeBitmap" : {
      1 : "Pir",
      2 : "Ultrasonic",
      4 : "PhysicalContact",
    },
    "OnOffControl" : {
      1 : "AcceptOnlyWhenOn",
    },
    "OnOffFeature" : {
      1 : "Lighting",
    },
    "OperationalStatus" : {
      3 : "Global",
      12 : "Lift",
      48 : "Tilt",
    },
    "PowerSourceFeature" : {
      1 : "Wired",
      2 : "Battery",
      4 : "Rechargeable",
      8 : "Replaceable",
    },
    "PressureFeature" : {
      1 : "Ext",
    },
    "PumpStatus" : {
      1 : "DeviceFault",
      2 : "Supplyfault",
      4 : "SpeedLow",
      8 : "SpeedHigh",
      16 : "LocalOverride",
      32 : "Running",
      64 : "RemotePressure",
      128 : "RemoteFlow",
      256 : "RemoteTemperature",
    },
    "RockSupportMask" : {
      1 : "RockLeftRight",
      2 : "RockUpDown",
      4 : "RockRound",
    },
    "SafetyStatus" : {
      1 : "RemoteLockout",
      2 : "TamperDetection",
      4 : "FailedCommunication",
      8 : "PositionFailure",
      16 : "ThermalProtection",
      32 : "ObstacleDetected",
      64 : "Power",
      128 : "StopInput",
      256 : "MotorJammed",
      512 : "HardwareFailure",
      1024 : "ManualOperation",
      2048 : "Protection",
    },
    "SceneFeatures" : {
      1 : "SceneNames",
    },
    "ScenesCopyMode" : {
      1 : "CopyAllScenes",
    },
    "ShadeClosureStatus" : {
      1 : "Operational",
      2 : "Adjusting",
      4 : "Opening",
      8 : "MotorOpening",
    },
    "SimpleBitmap" : {
      1 : "ValueA",
      2 : "ValueB",
      4 : "ValueC",
    },
    "SoftwareDiagnosticsFeature" : {
      1 : "WaterMarks",
    },
    "SquawkInfo" : {
      240 : "Mode",
      8 : "Strobe",
      3 : "Level",
    },
    "StartTime" : {
      63 : "Minutes",
      192 : "TimeEncoding",
      65280 : "Hours",
    },
    "SupportedStreamingProtocol" : {
      1 : "Dash",
      2 : "Hls",
    },
    "SwitchFeature" : {
      1 : "LatchingSwitch",
      2 : "MomentarySwitch",
      4 : "MomentarySwitchRelease",
      8 : "MomentarySwitchLongPress",
      16 : "MomentarySwitchMultiPress",
    },
    "ThermostatAlarmMask" : {
      1 : "InitializationFailure",
      2 : "HardwareFailure",
      4 : "SelfcalibrationFailure",
    },
    "ThermostatFeature" : {
      1 : "Heating",
      2 : "Cooling",
      4 : "Occupancy",
      8 : "Schedule",
      16 : "Setback",
      32 : "Automode",
    },
    "ThermostatOccupancy" : {
      1 : "Occupied",
    },
    "ThermostatRunningState" : {
      1 : "HeatStateOn",
      2 : "CoolStateOn",
      4 : "FanStateOn",
      8 : "HeatSecondStageStateOn",
      16 : "CoolSecondStageStateOn",
      32 : "FanSecondStageStateOn",
      64 : "FanThirdStageStateOn",
    },
    "ThermostatSensing" : {
      1 : "LocalTempSensedRemotely",
      2 : "OutdoorTempSensedRemotely",
      4 : "OccupancySensedRemotely",
    },
    "ThreadNetworkDiagnosticsFeature" : {
      1 : "PacketCounts",
      2 : "ErrorCounts",
      4 : "MLECounts",
      8 : "MACCounts",
    },
    "TimeStatusMask" : {
      1 : "MasterClock",
      2 : "Synchronized",
      4 : "MasterZoneDst",
      8 : "Superseding",
    },
    "UnitLocalizationFeature" : {
      1 : "TemperatureUnit",
    },
    "WarningInfo" : {
      240 : "Mode",
      12 : "Strobe",
      3 : "SirenLevel",
    },
    "WiFiNetworkDiagnosticsFeature" : {
      1 : "PacketCounts",
      2 : "ErrorCounts",
    },
    "WiFiSecurity" : {
      1 : "Unencrypted",
      2 : "WepPersonal",
      4 : "WpaPersonal",
      8 : "Wpa2Personal",
      16 : "Wpa3Personal",
    },
    "WindSettingMask" : {
      1 : "SleepWind",
      2 : "NaturalWind",
    },
    "WindSupportMask" : {
      1 : "SleepWind",
      2 : "NaturalWind",
    },
    "Bitmap16" : {},
    "Bitmap24" : {},
    "Bitmap32" : {},
    "Bitmap64" : {},
    "Bitmap8" : {},
  }
}
