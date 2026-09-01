# Retrieving Historical Data

AutoML for IoT can replay historical sensor data **as if the measurements were arriving live**. This replay is used to build the analytic datasets needed for model training.

There are two ways to prepare the raw historical data:

1. **Retrieve it automatically from a configured data source.**
2. **Create `historicalData.csv` manually.**

## Path 1: Retrieve Historical Data from a Configured Data Source

If you configured a historical database or ClearBlade connection earlier in the project, AutoML for IoT can use that configuration to retrieve the historical records for you.

The retrieval process creates:

```text
<projectName>/data/input/historicalData.csv
```

and places the retrieved sensor updates into the format required for historical replay.

For details about running the retrieval program, selecting the historical period, monitoring progress, and validating the generated file, see [Retrieve Historical Data from a Configured Data Source](retrieve-from-data-source.md).

## Path 2: Create `historicalData.csv` Manually

If the historical measurements are coming from another source, the user will manually create:

```text
<projectName>/data/input/historicalData.csv
```

The format is intentionally simple.

For an ordinary project, **each row represents one update to one sensor value in the digital twin**.

For the exact field order, ESP field meanings, timestamp details, examples, and validation rules, see [Create the Historical Data File Manually](create-historical-data.md).

## If the Digital Twin Changes Over Time

Most projects replay sensor measurements against a digital twin whose assets and connections stay fixed.

Some projects are dynamic. In this case, assets can be added or removed, or connections between assets can change while the project runs.

When the project information config is set to allow dynamic changes:

```text
allowDynamicChangesToTwin = "Y"
```

the historical replay can include those asset and connection changes along with ordinary sensor updates.

In that situation, `historicalData.csv` uses an expanded 18-field structure so the replay can reproduce both:

- changes to sensor values
- changes to the structure of the digital twin

The manual-creation page shows the full dynamic structure and an example that mixes sensor, asset, and connection updates in timestamp order.

## Why the Order Matters

Historical replay processes the rows chronologically.

As each record is processed, AutoML for IoT updates the state of the digital twin. At the configured output times, it can then calculate derived attributes, assemble output tables, and create the historical analytic data needed for model training.

That is why the CSV must be sorted in nondecreasing timestamp order.

## Next

After the historical dataset is available and validated, continue to [Reviewing Data Quality](../reviewing-data-quality/README.md).
