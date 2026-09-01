# Model Training

Model training is a **fully automated execution step**.

Earlier, you told AutoML for IoT which models you want to train by defining the target, predictors, model-grouping approach, analytic pipeline, and training date range. In this step, AutoML for IoT simply executes those instructions.

If you need to review or change those choices, return to [Specify Models to Train and Deploy](../designing-output-tables-and-models/models.md).

If the project does not include any model definitions, this phase can be skipped.

## What Happens During Model Training

For each model definition, AutoML for IoT already knows:

- which `assetType/attributeID` to predict
- which raw and/or derived attributes to use as predictors
- which historical date range to use
- which model pipeline to execute
- whether to train one model per asset, one model across all assets, or one model per unique grouping-attribute value

The analytic datasets created in the previous step provide the historical records needed to execute those model definitions.

You do not redesign the models here. You run the training process and AutoML for IoT executes the model definitions you provided earlier.

## Three Types of Model Pipelines

AutoML for IoT supports three types of model pipelines.

### SAS Model Studio Pipelines

These pipelines are executed and trained in **SAS Model Studio**.

The resulting models are managed in **SAS Model Manager**.

### Custom SAS Model Pipelines

These pipelines train models using SAS code.

The trained model content is stored in the local model repository under:

```text
AutoMLforIoT/
└── _modelRepository/
    └── sas/
```

When a custom SAS model is trained on SAS Viya, the model is also registered in **SAS Model Manager**.

### Python Model Pipelines

Python model pipelines produce trained models stored as `.pkl` files in the local model repository under:

```text
AutoMLforIoT/
└── _modelRepository/
    └── python/
```

The pickle file contains the trained Python model and the information AutoML for IoT needs to use it later.

## Where the Local Model Repository Is Located

The local repository is part of the AutoML for IoT installation:

```text
AutoMLforIoT/
└── _modelRepository/
    ├── python/
    └── sas/
```

The `python` and `sas` directories hold the locally stored model artifacts created by the corresponding custom model pipelines.

## Run Model Training

The exact program you run depends on the environment:

- [Train Models in SAS Viya](train-models-viya.md)
- [Train Models in SAS Viya Workbench](train-models-workbench.md)

The training programs can also be limited to a subset of the requested models when you do not want to execute the entire model set.

## Previous

If the analytic datasets have not yet been generated and copied into the project, see [Creating Analytic Datasets](../creating-analytic-datasets/README.md).

## Next

After model training completes, the trained models are integrated into the project and can be evaluated by scoring historical analytic data. For details, see [Scoring the Analytic Dataset](../scoring-the-analytic-dataset/README.md).
