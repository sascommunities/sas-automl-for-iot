# Define Attributes

After defining the asset types, specify the raw attributes that you will track for each asset type.

These are the values that AutoML for IoT receives updates for, or values that can later be initialized as static metadata.

Examples include:

- solar: irradiance, temperature, electrical current
- HVAC: fan speed, duct pressure, supply-air temperature
- healthcare: blood pressure, heart rate, glucose
- manufacturing: line speed, temperatures, amounts of raw materials

Calculated metrics belong in the derived-attributes step rather than in this raw-attribute definition. For details about supported calculated metrics and how they are configured, see [Configuring Derived Attributes](../configuring-derived-attributes/README.md).


## Where the Configuration Goes

Define raw attributes in:

```text
Phase-1---Project-Definition/
└── 02_defineDigitalTwin/
    └── attributes.json
```

Use `attributes.json` to define the raw attributes that belong to each asset type. Calculated attributes are defined later in `03_defineDataEnrichment`.

## Required Fields

| Field | Type | Description |
|---|---|---|
| `assetType` | string | Asset type that owns the attribute. Must already exist in `assetTypes.json`. |
| `attributeID` | string | Attribute identifier. Must be unique within the asset type. |
| `SASAttributeID` | string | SAS-compatible variable name, no more than 30 characters. |
| `attributeType` | string | Must be `"raw"`. |
| `dataType` | string | `"double"` for numeric values or `"string"` for text values. |
| `dataLength` | number | `8` for a double; a positive integer large enough for a string value. |
| `retentionPeriod` | number | Seconds until a reading becomes stale. Use `0` to retain the current reading indefinitely (until a new reading is observed). |

## Optional Fields

| Field | Type | Description |
|---|---|---|
| `dataFormat` | string | Valid SAS format for displaying the value. |
| `acceptableMin` | number | Minimum acceptable value. |
| `acceptableMinLogic` | string | `"missing"` or `"limit"`; required when `acceptableMin` is supplied. |
| `acceptableMax` | number | Maximum acceptable value. |
| `acceptableMaxLogic` | string | `"missing"` or `"limit"`; required when `acceptableMax` is supplied. |

## SAS Attribute IDs

`SASAttributeID` must:

- be 30 characters or fewer
- begin with a letter or underscore
- contain only letters, numbers, and underscores

For example:

```text
current_A
CMBX_temperature_C
supplyFanSpeed
```

## Acceptable Ranges

When a minimum or maximum is defined, choose how values outside that range are handled.

- `missing` ignores values outside the acceptable range.
- `limit` replaces an out-of-range value with the corresponding minimum or maximum.

## Retention Period

`retentionPeriod` is the number of seconds that a sensor reading remains valid before it is considered stale.

For example, if a value is received at 10:15 AM and the retention period is `900`, that value remains in effect for 15 minutes. If no new reading arrives by 10:30 AM, the value becomes missing.

Use:

```text
0
```

when a value should remain in effect until a newer reading arrives.

Attributes that will hold static metadata (described later) are normally assigned a retention period of `0`.

When defining static attributes (metadata), first define the attributes here, and then assign its value for individual assets in the static-attributes step. For details about assigning those values, see [Define Static Attributes](static-attributes.md).

## Example

```json
[
  {
    "assetType": "string",
    "attributeID": "current_A",
    "SASAttributeID": "current_A",
    "attributeType": "raw",
    "dataType": "double",
    "dataLength": 8,
    "retentionPeriod": 900,
    "acceptableMin": 0,
    "acceptableMinLogic": "missing",
    "acceptableMax": 100,
    "acceptableMaxLogic": "missing"
  }
]
```

## Validate the Attributes

Confirm that:

- every `assetType` exists in `assetTypes.json`
- `attributeID` is unique within its asset type
- `SASAttributeID` follows SAS variable-name rules and is unique within the asset type
- `attributeType` is `"raw"`
- `dataType` is `"double"` or `"string"`
- `dataLength` is `8` for numeric values
- `retentionPeriod` is zero or greater
- acceptable minimum and maximum values include their corresponding logic fields

## Previous

To review how the classes of assets are defined, see [Define Asset Types](asset-types.md).

## Next

After the raw attributes are defined and validated, identify the individual asset instances in the system. See [Define Assets](assets.md).
