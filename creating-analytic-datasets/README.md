# Creating Analytic Datasets

Earlier in the project, you defined the digital twin, selected the output tables to generate, and specified any models that should be trained.

This phase uses the historical replay project to transform the raw historical sensor updates into the structured analytic datasets requested earlier.

The workflow is automated but is intentionally split into several interactive tasks:

1. [Build the SAS Event Stream Processing Projects](build-esp-projects.md)
2. [Replay Historical Data to Create Analytic Datasets](replay-historical-data.md)
3. [Copy the Output Tables to the Project Directory](retrieve-analytic-datasets.md)
4. [Optionally Load and Review the Output Tables in SAS](review-analytic-datasets-in-sas.md)

## What This Phase Produces

Real-time analytics projects typically begin with a stream of simple sensor updates. Each incoming record represents **one sensor value changing for one asset at one point in time**.

Consider a simple solar farm with this structure:

```text
solarFarm01
├── combinerBoxA
│   ├── stringA1
│   └── stringA2
└── combinerBoxB
    ├── stringB1
    └── stringB2
```

The solar farm measures irradiance, each combiner box measures temperature, and each string measures current.

A simplified portion of the historical sensor data might therefore look like this:

| Time | Asset ID | Attribute | Value |
|---|---|---|---:|
| 10:00:01 | solarFarm01 | irradiance | 612 |
| 10:00:14 | stringA1 | current_A | 8.4 |
| 10:00:22 | stringA2 | current_A | 8.2 |
| 10:00:41 | combinerBoxA | temperature_C | 31.2 |
| 10:01:08 | stringB1 | current_A | 8.5 |
| 10:01:19 | stringB2 | current_A | 8.3 |
| 10:01:46 | combinerBoxB | temperature_C | 31.6 |
| 10:02:11 | solarFarm01 | irradiance | 625 |

This event-style structure is natural for a live sensor feed. Each sensor reports its own update when a new value becomes available. The result, however, is not yet an analytic-ready table: measurements from related assets arrive independently, at different times, and on separate rows.

During historical replay, AutoML for IoT processes those records in time order and reconstructs what the digital twin would have looked like as the project ran live. It calculates the configured derived attributes and creates the output tables that you defined earlier.

For example, suppose you configured a **string-level output table with a 5-minute output interval** containing:

- solar farm irradiance
- the string's current
- the temperature of the combiner box connected to that string

The resulting analytic dataset could look like this:

| Output Time | String | Solar Farm Irradiance | String Current | Combiner Box Temperature |
|---|---|---:|---:|---:|
| 10:00 | stringA1 | 612 | 8.4 | 31.2 |
| 10:00 | stringA2 | 612 | 8.2 | 31.2 |
| 10:00 | stringB1 | 612 | 8.5 | 31.6 |
| 10:00 | stringB2 | 612 | 8.3 | 31.6 |
| 10:05 | stringA1 | 625 | 8.6 | 31.4 |
| 10:05 | stringA2 | 625 | 8.4 | 31.4 |
| 10:05 | stringB1 | 625 | 8.7 | 31.8 |
| 10:05 | stringB2 | 625 | 8.5 | 31.8 |

Notice how the digital twin brings the related information together:

- `stringA1` and `stringA2` receive the temperature from their connected `combinerBoxA`.
- `stringB1` and `stringB2` receive the temperature from their connected `combinerBoxB`.
- all four strings receive irradiance from their connected `solarFarm01`.
- each string retains its own current measurement.

Instead of separate sensor events, you now have **regularly timed, structured analytic records with the related values side by side**.

The exact columns and output frequency depend on the output tables you configured earlier. In this example, the 5-minute output interval creates one analytic record every five minutes for each string.

These structured output tables become the analytic datasets that can be used for:

- model training
- exploratory analysis
- reviewing predictor and target behavior
- downstream SAS analysis

## The Four Tasks

### 1. Build the ESP Projects

Run `buildESPProjects` to generate the SAS Event Stream Processing projects used for historical replay and real-time testing.

For details, see [Build the SAS Event Stream Processing Projects](build-esp-projects.md).

### 2. Replay the Historical Data

Run `createAnalyticDatasets` to deploy the historical ESP project, replay `historicalData.csv`, generate output records, and shut down the temporary ESP deployment when processing completes.

For details, see [Replay Historical Data to Create Analytic Datasets](replay-historical-data.md).

### 3. Retrieve the Output Tables

Run `retrieveAnalyticDatasets` to copy the generated analytic datasets from the ESP server back into the project directory.

For details, see [Copy the Output Tables to the Project Directory](retrieve-analytic-datasets.md).

### 4. Optionally Review the Data in SAS

If you want to inspect the analytic datasets in SAS, use `reviewAnalyticDatasetsInSAS`.

This optional step can load a selected output table into a SAS library so you can inspect the records, explore relationships among variables, or experiment with modeling approaches.

For details, see [Load and Review Analytic Datasets in SAS](review-analytic-datasets-in-sas.md).

## Next

After the analytic datasets are available, continue to the model-training phase. For details, see [Model Training](../model-training/README.md).
