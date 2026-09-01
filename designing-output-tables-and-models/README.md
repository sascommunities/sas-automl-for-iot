# Designing Output Tables and Models

In the previous steps, you defined the digital twin and enriched it with any calculated metrics needed for the use case.

Now decide what AutoML for IoT should **output** and what it should **model**.

Depending on the project, you can use either or both options:

- **Output tables** organize selected digital-twin attributes into structured datasets for analysis, dashboards, reporting, or downstream processing.
- **Models** define the machine learning targets, predictors, training period, grouping strategy, and analytical pipeline that AutoML for IoT should train and deploy.

For new users, it is often useful to define one or two output tables first. This makes it easier to review the analytic-ready data before adding machine learning models.

## Where the Configuration Goes

Output tables and analytical models are configured under:

```text
Phase-1---Project-Definition/
└── 04_defineOutputAndModels/
    ├── outputDefinitions.json
    ├── modelDefinitions.json
    ├── processDefinitions.sas
    └── queryAvailablePipelines.sas
```

Use the two configuration files for different purposes:

| File | Purpose |
|---|---|
| `outputDefinitions.json` | Defines the output tables AutoML for IoT should create and the attributes that should be included in those tables. |
| `modelDefinitions.json` | Defines the analytical models to train, including the target, predictors, and model-related settings. |

After the output and model definitions are complete, run `processDefinitions.sas` to validate and integrate the configuration.

If you need to review the analytic pipelines available for model definitions, run `queryAvailablePipelines.sas`.

## Designing Output Tables

An output table is created for a selected asset type. At each project output interval, AutoML for IoT generates records for the assets of that type and includes the attributes you selected as columns.

The selected columns can come from:

- the output table's own asset type
- connected asset types, when the relationship is unambiguous
- raw attributes
- derived attributes

For details about selecting the output-table asset type, choosing attributes, understanding the resulting columns and row structure, and entering the required output configuration, see [Design Output Tables](output-tables.md).

## Specifying Models to Train and Deploy

A model definition describes:

- the attribute to predict
- the predictor attributes
- the historical date range used for training
- the analytical pipeline
- whether models are trained per asset, across all assets, or by groups of assets

Predictions from trained models can later become part of the project output.

For details about selecting targets and predictors, choosing a model grouping strategy, reviewing available pipelines, defining the training period, and entering the required model configuration, see [Specify Models to Train and Deploy](models.md).

## You Can Configure One or Both

You do not need to configure both output tables and models at the same time.

### Output Tables Only

If the immediate goal is to create structured, analytic-ready datasets, define the required output tables and leave model definitions for later.

You can return to this section and add models after reviewing the generated data.

### Models Only

If the primary goal is model training and scoring, define the required model specifications. The project workflow will use those definitions during later training and deployment phases.

### Output Tables and Models

Many projects use both. Output tables provide reusable analytic datasets and model predictions add analytical results to the digital twin and downstream output.

## You Do Not Need an Output Table for Every Asset Type

Create output tables only for the asset types that matter to the use case.

A table focused on one asset type can also include attributes from connected asset types when the relationship is unambiguous.

For example, a combiner-box table might include:

- a combiner-box temperature
- an inverter-level measure
- a solar-farm irradiance measure

If multiple connected assets could satisfy the same request, first create an appropriate derived attribute that makes the desired relationship explicit.

For details about connection-based calculations, see [Configuring Derived Attributes](../configuring-derived-attributes/README.md).

## Integrate the Definitions

After the required output and model definitions are complete, run:

```text
04_defineOutputAndModels/processDefinitions
```

This checks the definitions and integrates them into the project.

The detailed output-table and model pages show the corresponding review workflow.

## Previous

If you need to review or add calculated metrics before choosing outputs and models, see [Configuring Derived Attributes](../configuring-derived-attributes/README.md).

## Next

After output tables and model definitions are complete, the next phase prepares the historical sensor data required for analytic dataset creation and model training. For details, see [Retrieving Historical Data](../retrieving-historical-data/README.md).

## Related Information

For the asset types, raw attributes, assets, metadata, and hierarchies referenced by output and model definitions, see [Describing Your Digital Twin](../describing-your-digital-twin/README.md).
