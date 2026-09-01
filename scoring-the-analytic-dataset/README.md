# Scoring Analytic Datasets

Earlier in the project, you created the analytic datasets and then trained the models specified in the model definitions.

This phase is very similar to creating the analytic datasets. AutoML for IoT rebuilds the SAS Event Stream Processing projects, this time **integrating the trained models**, and replays the historical data again.

The result is a set of **scored analytic datasets** containing the same type of structured output records created earlier, now with model predictions added.

The workflow is automated but is intentionally split into several interactive tasks:

1. [Build the SAS Event Stream Processing Projects with Trained Models](build-scoring-esp-projects.md)
2. [Replay Historical Data to Create Scored Analytic Datasets](score-analytic-datasets.md)
3. [Copy the Scored Output Tables to the Project Directory](retrieve-scored-datasets.md)
4. [Optionally Load and Review the Scored Output Tables in SAS](review-scored-datasets-in-sas.md)

## What This Phase Produces

Historical sensor records again begin as event-style updates such as:

```text
timestamp + assetID + attributeID + value
```

During replay, AutoML for IoT reconstructs the digital twin over historical time, calculates the configured derived attributes, creates the output tables defined earlier, and executes the trained models.

The difference from the earlier analytic-dataset replay is simple:

> **The trained models are now integrated into the ESP project, so the output records also contain model predictions.**

For example, suppose the string-level analytic dataset created earlier contained solar farm irradiance, string current, and combiner box temperature:

```text
Output Time   String     Irradiance   String Current   Combiner Box Temperature
10:00         stringA1   612          8.4              31.2
10:00         stringA2   612          8.2              31.2
10:00         stringB1   612          8.5              31.6
10:00         stringB2   612          8.3              31.6
```

If a model was trained to predict **string current**, the scored dataset keeps those same analytic-ready columns and adds the model results alongside them:

```text
Output Time   String     Irradiance   String Current   Combiner Box Temp   Predicted Current   Standard Error
10:00         stringA1   612          8.4              31.2                8.3                 0.18
10:00         stringA2   612          8.2              31.2                8.3                 0.18
10:00         stringB1   612          8.5              31.6                8.4                 0.18
10:00         stringB2   612          8.3              31.6                8.4                 0.18
```

The important change is the addition of the **prediction and standard error** for string current. The original analytic values remain available on the same row, making it easy to compare the observed current with the model prediction at each output interval.

These scored analytic datasets can be used to:

- compare actual values with model predictions
- review how the trained models would have behaved over the historical period
- examine prediction behavior under different operating conditions
- support later business-rule and alert configuration

## The Four Tasks

### 1. Build the ESP Projects with the Trained Models

Run `buildESPProjectWModels` to generate the SAS Event Stream Processing projects used for historical scoring and real-time scoring.

This is similar to the earlier `buildESPProjects` step, but the trained models are now integrated into the generated ESP projects.

For details, see [Build the SAS Event Stream Processing Projects with Trained Models](build-scoring-esp-projects.md).

### 2. Replay the Historical Data

Run `scoreAnalyticDatasets` to deploy the historical scoring project, replay `historicalData.csv`, execute the integrated models, generate scored output records, and shut down the temporary ESP deployment when processing completes.

For details, see [Replay Historical Data to Create Scored Analytic Datasets](score-analytic-datasets.md).

### 3. Retrieve the Scored Output Tables

Run `retrieveScoredDatasets` to copy the generated scored analytic datasets from the ESP server back into the project directory.

For details, see [Copy the Scored Output Tables to the Project Directory](retrieve-scored-datasets.md).

### 4. Optionally Review the Scored Data in SAS

If you want to inspect the scored analytic datasets in SAS, use `reviewScoredDatasetsInSAS`.

This optional step lets you load a selected scored output table into a SAS library and review the historical values alongside the model predictions.

For details, see [Load and Review Scored Analytic Datasets in SAS](review-scored-datasets-in-sas.md).

## Previous

If the requested models have not yet been trained, see [Model Training](../model-training/README.md).

## Next

After the scored datasets have been reviewed, they can be used to help define business rules and other project customizations. For details, see [Adding Customizations](../adding-customizations/README.md).
