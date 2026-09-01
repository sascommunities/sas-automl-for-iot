# Deploying Your Final Project

This phase follows the same pattern used earlier to **create analytic datasets** and **score analytic datasets**, but now AutoML for IoT builds the complete final project.

The final projects include everything defined throughout the project:

- the digital twin and raw sensor processing
- derived attributes and structured output tables
- trained models and model predictions
- business rules
- ESP customizations

The **real-time final project** also includes the output locations configured in the previous step so the resulting real-time outputs can be written to their intended destinations.

At this point, there are two ways to run the final project:

1. **Replay historical data** through the final historical project.
2. **Deploy the final real-time project** into SAS Event Stream Manager and run it live.

## Where You Work

All final deployment work is performed under:

```text
Phase-5---Deployment/
└── 13_deployFinalProject/
    ├── <projectName>_historical_final/
    ├── <projectName>_realtime_final/
    ├── buildFinalESPProjects.sas
    ├── deployRealtimeProject.sas
    ├── replayHistoricalData.sas
    ├── retrieveFinalDatasets.sas
    └── reviewFinalDatasetsInSAS.sas
```

The SAS programs in this directory are used to build, replay, review, and deploy the completed project. The generated historical and real-time final ESP projects are also stored here.

## What This Phase Produces

Run `buildFinalESPProject` to create two final SAS Event Stream Processing projects:

- a **historical final project** for replaying `historicalData.csv`
- a **real-time final project** for continuously processing the live data feed

Both contain the completed analytic logic, integrated models, business rules, and ESP customizations.

The final output records build directly on the scored analytic datasets created in the previous phase. The key addition is that the **calculated business-rule values are now included in the output records as well**.

For example, the scored string-level dataset from the previous phase contained the actual string current, the predicted current, and its standard error:

```text
Output Time   String     Irradiance   String Current   Combiner Box Temp   Predicted Current   Standard Error
10:00         stringA1   612          8.4              31.2                8.3                 0.18
10:00         stringA2   612          8.2              31.2                8.3                 0.18
10:00         stringB1   612          8.5              31.6                8.4                 0.18
10:00         stringB2   612          8.3              31.6                8.4                 0.18
```

Suppose you then defined an `efficiency` business rule that compares actual string current with predicted string current:

```text
efficiency = actual current / predicted current
```

with the result limited to a minimum of **0%** and a maximum of **100%**.

The final output records now include that calculated business-rule value alongside the existing analytic and model results:

```text
Output Time   String     Irradiance   String Current   Combiner Box Temp   Predicted Current   Standard Error   Efficiency
10:00         stringA1   612          8.4              31.2                8.3                 0.18             100.0%
10:00         stringA2   612          8.2              31.2                8.3                 0.18              98.8%
10:00         stringB1   612          8.5              31.6                8.4                 0.18             100.0%
10:00         stringB2   612          8.3              31.6                8.4                 0.18              98.8%
```

For example, `stringA2` has an actual current of `8.2` and a predicted current of `8.3`, giving an efficiency of approximately `98.8%`. For `stringA1`, the actual current is slightly greater than the prediction, so the ratio is capped at `100%`.

The final output record therefore brings together the **structured analytic values, model results, and calculated business-rule values side by side**.

Any ESP customizations defined for the project are also incorporated into the final ESP projects.

The real-time project additionally contains the configured real-time output locations, so these completed output records can be sent to their intended destinations while the project runs live.

## The Two Ways to Run the Final Project

### Option 1: Replay Historical Data

This path is very similar to the historical replay used when creating and scoring the analytic datasets.

Run `replayHistoricalData` to deploy the final historical project and replay `historicalData.csv`.

The replay executes the complete final logic against the historical data, including:

- digital-twin updates
- derived attributes
- output-table creation
- model predictions
- business rules
- ESP customizations

If you run the replay, you can then retrieve the generated final output tables and optionally review them in SAS.

For details, see [Replay Historical Data with the Final Project](replay-final-historical-data.md).

### Option 2: Run the Final Project Live

Instead of replaying historical records, run `deployRealtimeProject` to automatically deploy the final real-time ESP project into **SAS Event Stream Manager**.

The deployed project then processes the live data feed continuously using the complete project logic.

Because this is the real-time project, it also sends the resulting outputs to the output locations configured in the previous step.

For details, see [Deploy the Final Real-Time Project](deploy-realtime-project.md).

## Final Deployment Workflow

### 1. Build the Final ESP Projects

Run `buildFinalESPProject`.

This creates the historical and real-time versions of the completed project.

For details, see [Build the Final ESP Projects](build-final-esp-projects.md).

### 2. Choose How You Want to Run the Project

You can:

- run `replayHistoricalData` to replay historical data through the final historical project
- run `deployRealtimeProject` to deploy the final real-time project into Event Stream Manager and process live data

You can use either or both approaches.

### 3. If You Replayed Historical Data, Retrieve the Results

Run `retrieveFinalDatasets` to copy the generated final output tables back into the project directory.

For details, see [Copy the Final Datasets to the Project Directory](retrieve-final-datasets.md).

### 4. Optionally Review Replayed Results in SAS

Run `reviewFinalDatasetsInSAS` if you want to inspect the final historical output tables in SAS.

For details, see [Load and Review Final Datasets in SAS](review-final-datasets-in-sas.md).

## Common CAS Deployment Pattern

When CAS is configured as the real-time output destination, a useful sequence is:

1. replay historical data using the final historical ESP project
2. retrieve the resulting final output tables
3. load those historical results into CAS, or create blank CAS tables with the correct structure and SAS formats
4. deploy the final real-time ESP project so new live records append to the CAS tables

This sequence is useful because ESP does not apply SAS formats when it creates CAS output tables directly.

## Previous

If final output destinations have not yet been configured, see [Configuring Output Locations](../configuring-output-locations/README.md).

## Next

After the final project is deployed and the implementation is complete, continue to [Archiving Your Project](../archiving-your-project/README.md).
