# Create a Custom SAS Pipeline

Use a custom SAS pipeline when you want AutoML for IoT to train a model using SAS code and deploy the resulting model as either **SAS score code** or an **ASTORE**.

The simplest approach is to **copy a current working SAS pipeline that produces the same type of model artifact you need and change only the model-specific portions**.

Two useful examples are:

- `neuralNetworkSAS.sas` — trains a neural network and produces SAS score code.
- `forestSAS.sas` — trains a forest and produces an ASTORE.

AutoML for IoT handles the surrounding model-training workflow. Your custom pipeline receives the prepared modeling data, target, retained predictors, model information, and model output location.

## Where SAS Pipelines Are Stored

Place custom SAS model-pipeline programs in:

```text
AutoMLforIoT/_commons/sasModelPipelines/
```

Start by copying either `neuralNetworkSAS.sas` or `forestSAS.sas`, depending on whether the new model will produce score code or an ASTORE. Rename the program and its macro for the new pipeline.

As you work through the sections below, refer directly to the corresponding blocks in those example programs.

## Keep the Macro Interface

At the beginning of each example, look for the pipeline macro definition:

```sas
%macro <pipelineName>(
    thiscaslib=,
    thiscasdsname=,
    thisTargetVariable=,
    thisProjectName=,
    thisAssetType=,
    thisSplitID=,
    thisSplitVariable=,
    thisModelGUID=,
    thisModelOutloc=,
    msgProjName=,
    msgProjNameTS=
);
```

Keep this interface. AutoML for IoT supplies these values when it calls the pipeline.

The values most directly used by the modeling code are:

| Parameter | What It Provides |
|---|---|
| `thiscaslib` | CAS library containing the prepared modeling table |
| `thiscasdsname` | Prepared modeling table name |
| `thisTargetVariable` | Target variable for the model |
| `thisModelOutloc` | Directory where the resulting model artifact is written |
| `msgProjName` | Model display name used in log and status messages |

The remaining parameters provide project, asset, grouping, and model information used by the surrounding training workflow.

## Keep the Common Framework Code

Both examples contain framework code for initialization, status reporting, and error handling.

When creating a new pipeline, retain these portions and update the pipeline name in the applicable messages. The model-specific work belongs primarily in the middle of the macro.

In particular, retain the framework that manages:

- `quitExecution`
- `hadErrorCustomSASPipeline`
- `hadErrorCustomSASPipelineDet`
- running, success, and failure status updates
- fatal SAS error handling

This lets the new pipeline participate in the same automated training process as the supplied pipelines.

## Prepare Training and Validation Data

Look for the `/* partition data */` section in either example.

The supplied pipelines use `sampling.Stratified` to partition the prepared modeling table and then create:

```text
trnTable
vldTable
```

These tables are used for model training and validation.

If that approach is appropriate for the new model, this section can generally be retained.

## Build the Predictor List

AutoML for IoT provides the predictors retained for the model in:

```text
thisInputVariableList
```

Look for the `/* determine input variable list */` section.

The examples read `SASAttributeID` from this table and construct `inputVarList` for the modeling action.

The exact syntax required by the SAS modeling action can differ. The two supplied examples demonstrate this:

- `neuralNetworkSAS.sas` creates a quoted list such as `"var1","var2","var3"`.
- `forestSAS.sas` creates CAS action parameter entries such as `{name="var1"},{name="var2"}`.

Use the format required by the SAS procedure or CAS action used for the new model.

## Train and Evaluate the Model

This is the main section that you replace for a new analytical technique.

In `neuralNetworkSAS.sas`, look between:

```sas
/*************** START NEURAL NETWORK *****************/
```

and:

```sas
/**************** END NEURAL NETWORK *****************/
```

The model is trained with `neuralNet.annTrain`, and the validation data is scored with `neuralNet.annScore`.

In `forestSAS.sas`, look between:

```sas
/*************** START FOREST *****************/
```

and:

```sas
/**************** END FOREST *****************/
```

The model is trained with `decisionTree.forestTrain`, and validation data is scored with `decisionTree.forestScore`.

For a new pipeline, replace the model-training and evaluation logic with the SAS procedure or CAS action required for the analytical technique.

The target is available as:

```sas
&thisTargetVariable.
```

and the predictor list created in the preceding section is available as:

```sas
&inputVarList.
```

## Choose How the Trained Model Will Be Scored

A custom SAS pipeline must leave AutoML for IoT with a model artifact that can be used later for scoring.

The supplied examples show the two supported patterns.

### Option 1: SAS Score Code

Use `neuralNetworkSAS.sas` as the starting point when the modeling technique generates standalone SAS score code.

Look for:

```sas
/**************** OUTPUT THE SCORE CODE *****************/
```

The example writes the generated code to:

```text
<thisModelOutloc>/score.sas
```

The output location is already supplied through `thisModelOutloc`; the custom pipeline does not need to determine the repository location itself.

For a score-code pipeline, the ASTORE variables are still created but remain blank:

```sas
%global astoreKey astoreKeyShort;
%let astoreKey=;
%let astoreKeyShort=;
```

### Option 2: ASTORE

Use `forestSAS.sas` as the starting point when the modeling technique produces an ASTORE.

Look for:

```sas
/**************** OUTPUT THE ASTORE *****************/
```

The example:

1. describes the trained ASTORE to retrieve its key
2. creates `astoreKey` and `astoreKeyShort`
3. downloads the ASTORE to `thisModelOutloc`

The resulting file follows the pattern:

```text
_<astoreKeyShort>.sasast
```

For an ASTORE pipeline, retain the creation and population of:

```sas
%global astoreKey astoreKeyShort;
```

## Define the Model Output Variables

AutoML for IoT also needs to know which variables the trained model will produce when it scores data.

Look for:

```sas
/**************** UPDATE THE OUTPUT VARIABLES *****************/
```

The pipeline must create:

```text
work.thisoutputvariablelist
```

### For Score Code

In `neuralNetworkSAS.sas`, the output metadata is created directly:

```sas
data work.thisoutputvariablelist; 
    length varname $ 32 vartype $ 10 varlength 8;
    varname="P_&thisTargetVariable.";
    vartype="NUM";
    varlength=8;
    output;
run;
```

For a new score-code model, update this section so it describes the variables that the generated scoring code actually creates.

Each output includes:

- `varname` — output variable name
- `vartype` — output variable type
- `varlength` — output variable length

### For an ASTORE

In `forestSAS.sas`, the pipeline retrieves the output variables directly from the ASTORE:

```sas
ods output OutputVariables=work.thisoutputvariablelist; 
proc astore;
    describe rstore=&thiscaslib..fo_astore;
quit;
```

If the new model produces an ASTORE with its output metadata available through `PROC ASTORE DESCRIBE`, follow this pattern rather than manually defining the output variables.

## Identify the Champion Model and Artifact Type

Look for:

```sas
/**************** UPDATE THE CHAMPION MODEL INFO *****************/
```

Every custom SAS pipeline sets:

```sas
thisChampionModel
thisChampionModelType
```

`thisChampionModel` identifies the analytical model type.

`thisChampionModelType` identifies how AutoML for IoT will score the model:

```text
scorecode
```

or:

```text
astore
```

For example, `neuralNetworkSAS.sas` uses:

```sas
%let thisChampionModel=NEURAL;
%let thisChampionModelType=scorecode;
```

while `forestSAS.sas` uses:

```sas
%let thisChampionModel=forest;
%let thisChampionModelType=astore;
```

Update these values for the new pipeline.

## Clean Up Temporary Tables

Look for:

```sas
/**************** CLEAN UP THE CASLIB *****************/
```

Both examples delete the temporary tables created during training.

Update this list to include temporary CAS tables created by the new model while retaining the common partition, training, and validation cleanup as applicable.

## What You Normally Change

When starting from one of the supplied SAS pipelines, the primary changes are:

1. **Pipeline and macro name** — rename the copied pipeline and its macro.
2. **Predictor-list formatting** — change only if the new SAS procedure or CAS action requires a different input-list syntax.
3. **Model training and evaluation** — replace the example neural-network or forest actions with the desired analytical technique.
4. **Model artifact creation** — generate either SAS score code or an ASTORE using the appropriate example as the pattern.
5. **Output variables** — make `work.thisoutputvariablelist` describe the values produced during scoring.
6. **Champion model information** — set `thisChampionModel` and set `thisChampionModelType` to `scorecode` or `astore`.
7. **Temporary-table cleanup** — remove any temporary tables created by the new pipeline.
8. **Pipeline-specific status text** — update the pipeline name used in log and status messages.

The surrounding AutoML for IoT macro interface, execution-status framework, and error-handling structure should normally remain intact.

## Practical Checklist

Before using the new pipeline, confirm that:

- the program is stored in `AutoMLforIoT/_commons/sasModelPipelines/`
- the macro interface matches the supplied pipelines
- common status and error-handling logic is retained
- the prepared modeling table is partitioned as needed
- predictors are read from `thisInputVariableList`
- the target is taken from `thisTargetVariable`
- the model is trained and evaluated
- the model produces either deployable SAS score code or an ASTORE
- the model artifact is written to `thisModelOutloc`
- `work.thisoutputvariablelist` describes the scoring outputs
- `astoreKey` and `astoreKeyShort` are populated for ASTORE models and left blank for score-code models
- `thisChampionModel` is set
- `thisChampionModelType` is set to `scorecode` or `astore`
- temporary model-training tables are cleaned up
- the common success and failure handling remains in place

## Make the New Pipeline Available

After saving the new SAS pipeline in:

```text
AutoMLforIoT/_commons/sasModelPipelines/
```

run:

```text
queryAvailablePipelines.sas
```

Review:

```text
_reviewModelPipelineList.xls
```

Locate the new pipeline with pipeline type:

```text
SAS
```

Use its pipeline ID as the `pipelineID` in the desired model definition.

## Related Information

For model targets, predictors, grouping logic, training dates, and pipeline selection, see [Define Models](../designing-output-tables-and-models/models.md).
