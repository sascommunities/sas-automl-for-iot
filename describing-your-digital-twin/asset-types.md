# Define Asset Types

When defining your digital twin, first list the types of assets that exist in the use case.

The asset types depend entirely on the problem that you want to analyze.

Examples include:

- solar: solar farm, inverter, combiner box, string
- HVAC: chiller, boiler, air handler, fan powered box
- healthcare: hospital, patient, hospital bed, physician
- manufacturing: meaningful equipment or process stages

Sensors such as temperature, pressure, or electrical-current sensors are normally represented as **attributes** of an asset rather than as separate asset types.


## Where the Configuration Goes

Define asset types in:

```text
Phase-1---Project-Definition/
└── 02_defineDigitalTwin/
    └── assetTypes.json
```

Use `assetTypes.json` to define the types of things that exist in the digital twin. Each asset type is defined once here and is then referenced by attributes and individual assets.

## Fields

Each asset type contains exactly two fields.

| Field | Type | Description |
|---|---|---|
| `assetType` | string | Unique ID for the asset type. Generally use a short camel-case value. |
| `assetTypeLabel` | string | Human-readable label that can be used in dashboards and other displays. |

There are no optional fields.

## Example

```json
[
  { "assetType": "solarFarm", "assetTypeLabel": "Solar Farm" },
  { "assetType": "inverter", "assetTypeLabel": "Inverter" },
  { "assetType": "combinerBox", "assetTypeLabel": "Combiner Box" },
  { "assetType": "string", "assetTypeLabel": "String" }
]
```

## Rules

- `assetType` must be unique.
- `assetType` should contain letters and numbers and is generally camel case.
- `assetTypeLabel` should contain only letters, numbers, spaces, dashes, and underscores.

## Previous

Return to the main menu focused on [Describing Your Digital Twin](README.md)

## Next

To define the raw attributes that you will track for each asset type, [Define Attributes](attributes.md)
