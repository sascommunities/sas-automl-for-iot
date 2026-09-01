# Configure a Get Asset ID Derived Attribute

## What It Does

A `getAssetID` derived attribute makes an asset's `assetID` available as a normal attribute in the digital twin.

This is especially useful when building output tables for dashboards. For example, a table focused on `string` assets might also include the IDs of the connected:

```text
solarFarm
inverter
combinerBox
string
```

Those ID fields make it easy for a dashboard to filter and drill from the solar farm level down to individual strings.

In most projects, the simplest pattern is to store each asset's own ID as an attribute on that asset. AutoML for IoT can then pull those attributes from connected assets when assembling an output table.

## When to Use It

Use `getAssetID` when you want an asset ID available as a field that can easily be included in output tables or reused elsewhere.

A common dashboard pattern is:

- `solarFarm/solarFarmID`
- `inverter/inverterID`
- `combinerBox/combinerBoxID`
- `string/stringID`

A string-level output table can then include the IDs of the connected higher-level assets so users can group, filter, and drill through the hierarchy.

You can also use `getAssetID` to copy the ID of a connected asset onto another asset, but that is less typical because output tables can already pull attributes from connected assets directly.


## Where the Configuration Goes

Every derived attribute is defined in two parts:

1. **Define the derived attribute itself** in:

   ```text
   Phase-1---Project-Definition/
   03_defineDataEnrichment/
   derivedAttributes.json
   ```

   This is where you provide the high-level information about the new attribute, including its asset type, attribute ID, label, data type, and derived-attribute type (`getAssetID`).

2. **Define the logic used to calculate it** in:

   ```text
   Phase-1---Project-Definition/
   03_defineDataEnrichment/
   derivedAttributeDetails/derivedAttributeDetails_getAssetID.json
   ```

   For this derived-attribute type, the detail file is:

   ```text
   derivedAttributeDetails_getAssetID.json
   ```

Keep these two responsibilities separate: `derivedAttributes.json` defines **what the attribute is**; `derivedAttributeDetails_getAssetID.json` defines **how it is calculated**.

## What You Need to Configure

The configuration follows the same two-step pattern used by other derived attributes: first define **what the new attribute is**, and then define **how AutoML for IoT calculates it**.

| Location | Purpose |
|---|---|
| `03_defineDataEnrichment/derivedAttributes.json` | Defines the high-level information for the new `getAssetID` derived attribute. |
| `03_defineDataEnrichment/derivedAttributeDetails/derivedAttributeDetails_getAssetID.json` | Defines the type-specific logic used to calculate the derived attribute. |

## Step 1: Define the New Derived Attribute

Each `getAssetID` attribute requires a record in `derivedAttributes.json`.

Because the result is an asset ID, the new attribute is normally configured as a string with sufficient length for the asset IDs used in the project.

### Required Fields

| Field | Type | Description |
|---|---|---|
| `assetType` | string | Asset type that receives the connected asset ID. |
| `attributeID` | string | ID of the new derived attribute. Must be unique within the asset type and must not duplicate a raw attribute. |
| `SASAttributeID` | string | SAS-compatible ID. Must be 30 characters or fewer, contain only letters, numbers, and underscores, and cannot begin with a number. |
| `attributeLabel` | string | Human-readable label. |
| `attributeType` | string | Must be `"getAssetID"`. |
| `dataType` | string | Use `"string"` for the returned asset ID. |
| `dataLength` | number | Positive integer large enough for expected asset IDs. |

The standard derived-attribute definition can also include the documented optional format and acceptable-range fields where applicable.

### Example

```json
[
  {
    "assetType": "string",
    "attributeID": "combinerBoxID",
    "SASAttributeID": "combinerBoxID",
    "attributeLabel": "Combiner Box ID",
    "attributeType": "getAssetID",
    "dataType": "string",
    "dataLength": 50
  }
]
```

## Step 2: Identify the Target Asset Type

A `derivedAttributeDetails_getAssetID.json` record contains exactly three required fields.

| Field | Type | Description |
|---|---|---|
| `assetType` | string | Asset type of the new derived attribute. |
| `attributeID` | string | ID of the new derived attribute. Must match the Step 1 definition. |
| `targetAssetType` | string | Asset type of the connected asset whose asset ID should be returned. |

There are no optional fields.

The `targetAssetType` must match a valid asset type defined in the project.

## Configuration Example

Suppose you want every combiner box to carry its own ID in:

```text
combinerBox/combinerBoxID
```

The detail definition identifies the asset type whose ID should be returned:

```json
[
  {
    "assetType": "combinerBox",
    "attributeID": "combinerBoxID",
    "targetAssetType": "combinerBox"
  }
]
```

The result is a normal attribute that can be included directly in a combiner-box output table or pulled into a connected string-level output table.

### Less Common: Store a Connected Asset ID

You can also define a `getAssetID` attribute on one asset type that returns the ID of a connected asset type.

For example:

```text
string/combinerBoxID
```

could store the ID of the connected combiner box on each string.

Use this only when you specifically want that connected asset ID stored on the source asset. If several connected assets of the requested type could qualify, the result must be unambiguous.


## Review the Result and Integrate the Attribute

After the high-level derived-attribute definition and the getAssetID-specific definition are complete, run the data-enrichment preparation step.

Open and run:

```text
03_defineDataEnrichment/prepareDataEnrichment
```

![prepareDataEnrichment program](images/prepare-data-enrichment-program.png)

This integrates the derived-attribute definitions into the project and creates an updated hierarchy review.

Download and open the generated `_reviewHierarchy*` document in a browser.

The derived attributes appear in blue when you inspect the assets in the updated digital twin.

![Derived attribute detail in the hierarchy review](images/derived-attribute-review-detail.png)

![Updated hierarchy with derived attributes](images/derived-attribute-review-hierarchy.png)


## Validate and Continue

Before continuing, verify both parts of the configuration.

### High-Level Derived Attribute

Confirm that:

- `assetType` exists in the asset-type definition
- `attributeID` is unique within the asset type
- the new `assetType/attributeID` does not duplicate a raw attribute
- `SASAttributeID` follows SAS variable-name rules and is no more than 30 characters
- `attributeType` is `"getAssetID"`
- `dataType` and `dataLength` are appropriate for storing the returned asset ID
- only documented fields are present

### Get-Asset-ID Detail

Confirm that:

- `assetType/attributeID` matches a derived attribute whose `attributeType` is `"getAssetID"`
- `targetAssetType` exists in the asset-type definition
- exactly the three documented fields are present
- the relationship is unambiguous: only one connected asset of the requested target type can validly be returned

## Return to Derived Attributes

[Return to Configuring Derived Attributes](README.md)
