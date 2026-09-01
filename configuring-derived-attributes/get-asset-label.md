# Configure a Get Asset Label Derived Attribute

## What It Does

A `getAssetLabel` derived attribute makes an asset's human-readable `assetLabel` available as a normal attribute in the digital twin.

This is especially useful for dashboard and reporting output. For example, a table focused on `string` assets might also include the labels of the connected:

```text
solarFarm
inverter
combinerBox
string
```

Those label fields make it easier for users to understand, filter, and drill through the asset hierarchy without relying only on internal asset IDs.

In most projects, the simplest pattern is to store each asset's own label as an attribute on that asset. AutoML for IoT can then pull those attributes from connected assets when assembling an output table.


## When to Use It

Use `getAssetLabel` when you want a readable asset name available as a field that can easily be included in output tables, dashboards, or reports.

A common dashboard pattern is:

- `solarFarm/solarFarmLabel`
- `inverter/inverterLabel`
- `combinerBox/combinerBoxLabel`
- `string/stringLabel`

A string-level output table can then include the labels of the connected higher-level assets so users can drill from the solar farm to the inverter, combiner box, and individual string.

You can also use `getAssetLabel` to copy the label of a connected asset onto another asset, but that is less typical because output tables can already pull attributes from connected assets directly.


## Where the Configuration Goes

Every derived attribute is defined in two parts:

1. **Define the derived attribute itself** in:

   ```text
   Phase-1---Project-Definition/
   03_defineDataEnrichment/
   derivedAttributes.json
   ```

   This is where you provide the high-level information about the new attribute, including its asset type, attribute ID, label, data type, and derived-attribute type (`getAssetLabel`).

2. **Define the logic used to calculate it** in:

   ```text
   Phase-1---Project-Definition/
   03_defineDataEnrichment/
   derivedAttributeDetails/derivedAttributeDetails_getAssetLabel.json
   ```

   For this derived-attribute type, the detail file is:

   ```text
   derivedAttributeDetails_getAssetLabel.json
   ```

Keep these two responsibilities separate: `derivedAttributes.json` defines **what the attribute is**; `derivedAttributeDetails_getAssetLabel.json` defines **how it is calculated**.

## What You Need to Configure

The configuration follows the same two-step pattern used by other derived attributes: first define **what the new attribute is**, and then define **how AutoML for IoT calculates it**.

| Location | Purpose |
|---|---|
| `03_defineDataEnrichment/derivedAttributes.json` | Defines the high-level information for the new `getAssetLabel` derived attribute. |
| `03_defineDataEnrichment/derivedAttributeDetails/derivedAttributeDetails_getAssetLabel.json` | Defines the type-specific logic used to calculate the derived attribute. |

## Step 1: Define the New Derived Attribute

Each `getAssetLabel` attribute requires a record in `derivedAttributes.json`.

Because the result is an asset label, the new attribute should be configured as a string with sufficient length for the labels used in the project.

### Required Fields

| Field | Type | Description |
|---|---|---|
| `assetType` | string | Asset type that receives the connected asset label. |
| `attributeID` | string | ID of the new derived attribute. Must be unique within the asset type and must not duplicate a raw attribute. |
| `SASAttributeID` | string | SAS-compatible ID. Must be 30 characters or fewer, contain only letters, numbers, and underscores, and cannot begin with a number. |
| `attributeLabel` | string | Human-readable label for the new derived attribute. |
| `attributeType` | string | Must be `"getAssetLabel"`. |
| `dataType` | string | Use `"string"` for the returned label. |
| `dataLength` | number | Positive integer large enough for the expected connected asset labels. |

The standard derived-attribute definition can also include the documented optional format and acceptable-range fields where applicable.

### Example

```json
[
  {
    "assetType": "string",
    "attributeID": "combinerBoxLabel",
    "SASAttributeID": "combinerBoxLabel",
    "attributeLabel": "Combiner Box Label",
    "attributeType": "getAssetLabel",
    "dataType": "string",
    "dataLength": 100
  }
]
```

## Step 2: Identify the Target Asset Type

A `derivedAttributeDetails_getAssetLabel.json` record contains exactly three required fields.

| Field | Type | Description |
|---|---|---|
| `assetType` | string | Asset type of the new derived attribute. |
| `attributeID` | string | ID of the new derived attribute. Must match the Step 1 definition. |
| `targetAssetType` | string | Asset type of the connected asset whose `assetLabel` should be returned. |

There are no optional fields.

The `targetAssetType` must match a valid asset type defined in the project.

## Configuration Example

Suppose you want every combiner box to carry its own label in:

```text
combinerBox/combinerBoxLabel
```

The detail definition identifies the asset type whose label should be returned:

```json
[
  {
    "assetType": "combinerBox",
    "attributeID": "combinerBoxLabel",
    "targetAssetType": "combinerBox"
  }
]
```

The result is a normal attribute that can be included directly in a combiner-box output table or pulled into a connected string-level output table.

### Less Common: Store a Connected Asset Label

You can also define a `getAssetLabel` attribute on one asset type that returns the label of a connected asset type.

For example:

```text
string/combinerBoxLabel
```

could store the label of the connected combiner box on each string.

Use this only when you specifically want that connected asset label stored on the source asset. If several connected assets of the requested type could qualify, the result must be unambiguous.


## Review the Result and Integrate the Attribute

After the high-level derived-attribute definition and the getAssetLabel-specific definition are complete, run the data-enrichment preparation step.

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
- `attributeType` is `"getAssetLabel"`
- `dataType` is appropriate for storing a text label
- `dataLength` is large enough for expected asset labels
- only documented fields are present

### Get-Asset-Label Detail

Confirm that:

- `assetType/attributeID` matches the corresponding `getAssetLabel` derived attribute
- `targetAssetType` exists in the asset-type definition
- exactly the three documented fields are present
- the relationship is unambiguous: only one connected asset of the requested type can validly be selected

## Return to Derived Attributes

[Return to Configuring Derived Attributes](README.md)
