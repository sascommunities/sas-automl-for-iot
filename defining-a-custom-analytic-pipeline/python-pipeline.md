# Create a Custom Python Pipeline

Use a custom Python pipeline when you want AutoML for IoT to train a model using Python and store the trained model as a `.pkl` file.

The easiest way to create a new Python pipeline is to **start from an existing working Python pipeline and change only the model-specific portions**.

AutoML for IoT already handles the surrounding training framework, including passing the requested target and predictors into the function, providing the training data, supplying project/model metadata, and determining where the trained pickle file should be written.

## Where Python Pipelines Are Stored

Place Python model-pipeline programs in:

```text
AutoMLforIoT/_commons/pythonModelPipelines/
```


After the new pipeline is saved there, it can be discovered through the normal available-pipelines query described later on this page.

The best reference is one of the existing pipeline programs themselves. As you work through this page, compare the sections below directly with a current example such as `linearRegressionScikit.py`, `generalizedAdditiveModelPyGAM.py`, or `linearRegressionInteractionsWeightedRidge.py`.

## Start from an Existing Python Pipeline

Rather than building a pipeline from scratch, copy an existing Python pipeline that is similar to the model you want to create.

The current Python pipelines all follow the same overall pattern:

1. receive the target, predictors, training data, and model information from AutoML for IoT
2. prepare the modeling data
3. train the Python model
4. assess the trained model
5. define the values that the model will produce during scoring
6. package the trained model and scoring information
7. write the completed model to the supplied `.pkl` filename

This means most users only need to change the sections that are specific to their analytical technique.

## Keep the Function Interface

In the example programs, this is the top-level `def <pipelineName>(...)` function declaration.

The Python function is called by the AutoML for IoT model-training framework.

Keep the supplied function arguments in the same structure as the working examples:

```python
def myPipeline(
    projectName,
    trainedBy,
    trainingDttm,
    targetVar,
    inputVarList,
    modelInfo,
    assetList,
    dataFrameSchema,
    variableRenameList,
    modelName,
    modelFileName,
    thisDF,
):
```


The most important inputs for the custom modeling logic are:

| Input | What It Provides |
|---|---|
| `targetVar` | Target variable requested in the model definition |
| `inputVarList` | Predictor variables requested in the model definition |
| `thisDF` | pandas DataFrame containing the data available for training |
| `variableRenameList` | Mappings used when training names and scoring names differ |
| `modelInfo` | Information about the requested model, including pipeline, asset type, grouping, and training period |
| `modelFileName` | Full path and filename where the completed pickle file should be written |

The remaining arguments are used by the common model metadata that is packaged with the trained model.

## What You Normally Change

When starting from an existing pipeline, focus on the following model-specific sections.

### 1. Import the Packages Needed by the Model

Look near the beginning of the function for the import block.

Import the Python libraries needed to train and evaluate your model.

For example:

```python
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from sklearn.model_selection import train_test_split
```

The training program can use the Python packages appropriate for the analytical technique you are implementing.

### 2. Prepare the Modeling Data

In the current examples, this begins with the section that keeps the requested predictors and target, then calls `renameFields(...)`, filters missing values, and creates the final `X` and `y` objects.

AutoML for IoT passes the requested predictors and target into the pipeline.

A common pattern is to:

- keep the requested target and predictor columns
- call `renameFields(...)` so the training names are aligned with the names that will be available during scoring
- remove records with a missing target
- optionally remove predictors that do not have enough usable data
- remove incomplete records for the final set of modeling variables

The supplied pipelines already demonstrate this pattern, so in many cases this section can be retained with little or no change.


### 3. Train the Model

Look for the training block inside the successful-data branch, typically beginning with a train/test split and followed by model fitting.

Replace the model-building section with the Python modeling technique you want to use.

For example, a simple scikit-learn pipeline might contain:

```python
XTrain, XTest, yTrain, yTest = train_test_split(
    X.values,
    y,
    test_size=0.3,
    random_state=101,
)

model = LinearRegression().fit(XTrain, yTrain)
predictions = model.predict(XTest)
```

More advanced pipelines can tune hyperparameters, build transformations, apply weights, or create other modeling workflows as needed.

The important requirement is that the final trained object can be serialized in the pickle file and later used by the scoring code.


### 4. Assess the Model

Immediately after model fitting, the examples calculate assessment statistics and assign `championModelType`, `assessmentCriteria`, and `assessmentScore`.

Set the model description and assessment information that should be stored with the trained model.

The current examples use fields such as:

```python
championModelType = "Linear Regression"
assessmentCriteria = "RASE"
assessmentScore = rase
```

The assessment calculation can be appropriate to the model you are building.

Additional diagnostics that you want retained with the model can be placed in `supportingInfo`.

## Define What the Model Produces During Scoring

In the examples, look for the `outputList = [...]` block.

`outputList` identifies the variables that the trained model will add when it scores a record.

For example:

```python
outputList = [
    ["P_" + targetVarScoring, "NUM", 8],
    ["L_" + targetVarScoring, "NUM", 8],
    ["U_" + targetVarScoring, "NUM", 8],
]
```


This example creates:

- `P_...` — model prediction
- `L_...` — lower prediction bound
- `U_...` — upper prediction bound

A custom pipeline should define the outputs that its scoring logic actually creates.

## Store Any Supporting Values Needed During Scoring

In the examples, look for the `supportingInfo = [...]` block.

Use `supportingInfo` for values calculated during training that must also be available when the model scores new records.

For example:

```python
supportingInfo = [
    ["modelSE", rase],
]
```


The current examples use this to make the model error estimate available when prediction bounds are calculated.

More advanced pipelines can store additional values when their scoring logic requires them.

## Identify Packages Needed When the Pickle Is Used

In the examples, look for the `requiredPackages = [...]` block.

`requiredPackages` lists imports that must be available when the trained pickle is loaded for scoring.

For example:

```python
requiredPackages = [
    "from sklearn.linear_model import LinearRegression",
]
```

Only include the packages needed to load and use the serialized model.

## Define Pickle Initialization Code

In the examples, look for the `pickleInitializationCode = ...` block.

`pickleInitializationCode` runs once when the pickle is loaded.

For many Python models, this can remain very simple:

```python
pickleInitializationCode = '''
model = loaded_model_pickle['model']
'''
```

This retrieves the serialized model object from the pickle so it is available to the record-level scoring logic.

## Define the Record-Level Scoring Code

In the examples, look for the `pickleProcessingCode = ...` block.

`pickleProcessingCode` contains the Python code that is executed to produce the output variables for each record.

For example:

```python
pickleProcessingCode = '''
try:
    locals()['P_' + targetVarScoring] = float(
        model.predict(inputDataRow)[0]
    )
except:
    locals()['P_' + targetVarScoring] = float('nan')
'''
```


This is one of the most important model-specific sections to review. It must:

- call the trained model using the scoring inputs supplied by AutoML for IoT
- populate the variables declared in `outputList`
- use any values from `supportingInfo` that the scoring calculation requires

## Leave the Common Model Packaging Structure Intact

Near the end of each current example, look for the `modelData = { ... }` dictionary.

After the model-specific pieces have been defined, the pipeline packages the trained model and its metadata into `modelData`.

The current Python pipelines use the same common structure for this section.

In most cases, **do not redesign this dictionary**. Start from a current working pipeline and retain the common metadata entries.

The model-specific entries that you will commonly provide or update include:

```python
"model": model,
"supportingInfo": supportingInfo,
"requiredPackages": requiredPackages,
"pickleInitializationCode": pickleInitializationCode,
"pickleProcessingCode": pickleProcessingCode,
"sampleSize": numRows,
"championModelType": championModelType,
"assessmentCriteria": assessmentCriteria,
"assessmentScore": assessmentScore,
"outputList": outputList,
```

The framework-related entries around these values should be kept consistent with the working example.

## Write the Pickle File

Immediately after `modelData`, the examples open `modelFileName` and call `pickle.dump(...)`.

The output filename is already supplied to the pipeline as:

```text
modelFileName
```

Write the completed `modelData` object to that filename:

```python
with open(modelFileName, "wb") as modelFile:
    pickle.dump(modelData, modelFile)
```

You do not need to determine the model repository path yourself. AutoML for IoT supplies the appropriate output filename when it calls the pipeline.

## Return the Training Status

At the end of the function, the examples return `trainingResult`, `trainingErrorMessage`, and `sampleSize`.

The function returns:

```python
trainingResult
trainingErrorMessage
sampleSize
```

A successful run should return:

```python
trainingResult = "Completed"
trainingErrorMessage = ""
```

If training fails, return `"Failed"` with an appropriate error message and sample size.

Retaining the same return structure allows the surrounding AutoML for IoT process to handle the pipeline consistently with the existing Python pipelines.

## A Practical Checklist

When creating a new Python pipeline from an existing one, confirm that you have:

- kept the expected function interface
- retained the target/predictor preparation and `renameFields(...)` logic unless your model requires a deliberate change
- imported the packages required by the analytical technique
- trained and assessed the desired Python model
- defined `outputList`
- defined any required `supportingInfo`
- listed packages needed when the pickle is loaded
- defined pickle initialization code
- defined record-level scoring code that populates every output in `outputList`
- retained the common `modelData` packaging structure
- written `modelData` to the supplied `modelFileName`
- returned the expected training status values

## Make the New Pipeline Available

After saving the new Python pipeline in:

```text
AutoMLforIoT/_commons/pythonModelPipelines/
```

run:

```text
queryAvailablePipelines.sas
```

Review:

```text
_reviewModelPipelineList.xls
```

and locate the new pipeline with pipeline type:

```text
Python
```


Use the returned pipeline ID as the `pipelineID` in the desired model definition.

## Related Information

For model targets, predictors, grouping logic, training dates, and pipeline selection, see [Define Models](../designing-output-tables-and-models/models.md).
